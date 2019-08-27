package info.tangential.uri_picker;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import android.provider.OpenableColumns;
import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * UriPickerPlugin
 */
public class UriPickerPlugin implements MethodCallHandler, ActivityResultListener {

  private static final int OPEN_REQUEST_CODE = 0;


  private Result result;
  private final Registrar registrar;

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel =
        new MethodChannel(registrar.messenger(), "tangential.info/uri_picker");
    UriPickerPlugin plugin = new UriPickerPlugin(registrar);
    channel.setMethodCallHandler(plugin);
    registrar.addActivityResultListener(plugin);
  }

  private UriPickerPlugin(Registrar registrar) {
    this.registrar = registrar;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    this.result = result;
    if (call.method.equals("pickUri")) {
      performFileSearch();
    } else {
      Uri uri = Uri.parse((String) call.argument("uri"));
      switch (call.method) {
        case "getDisplayName":
          getDisplayName(uri);
          break;
        case "isUriOpenable":
          isUriOpenable(uri);
          break;
        case "takePersistablePermission":
          takePersistablePermission(uri);
          break;
        case "readTextFromUri":
          readTextFromUri(uri);
          break;
        case "alterDocument":
          alterDocument(uri, (String) call.argument("newContents"));
          break;
        default:
          result.notImplemented();
      }
    }
  }

  private void performFileSearch() {
    Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("*/*");
    String[] mimetypes = {"text/plain", "application/octet-stream"};
    intent.putExtra(Intent.EXTRA_MIME_TYPES, mimetypes);
    intent.setFlags(
        Intent.FLAG_GRANT_READ_URI_PERMISSION
            | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
    registrar.activity().startActivityForResult(intent, OPEN_REQUEST_CODE);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent resultData) {
    if (requestCode == OPEN_REQUEST_CODE) {
      if (resultCode == Activity.RESULT_OK) {
        Uri uri = resultData.getData();
        if (uri != null) {
          result.success(uri.toString());
          return true;
        }
      } else {
        result.success(null);
        return true;
      }
    }
    result.error("onActivityResult",
        "Unhandled request code, or null result data", null);
    return true;
  }

  private void getDisplayName(Uri uri) {
    String displayName = null;
    try (Cursor cursor = registrar.activity().getContentResolver()
        .query(uri, null, null, null, null, null);) {
      if (cursor != null && cursor.moveToFirst()) {
        displayName = cursor.getString(
            cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
      }
    }
    result.success(displayName);
  }

  private void isUriOpenable(Uri uri) {
    String name = null;
    String message = null;
    try (InputStream inputStream = registrar.activity().getContentResolver()
        .openInputStream(uri);) {
      result.success(null);
      return;
    } catch (FileNotFoundException e) {
      name = e.getClass().getName();
      message = e.getMessage();
    } catch (IOException e) {
      name = e.getClass().getName();
      message = e.getMessage();
    }
    result.error(name, message, null);
  }

  private void takePersistablePermission(Uri uri) {
    try {
      registrar.activeContext().getContentResolver()
          .takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      result.success(null);
    }
  }

  private void readTextFromUri(Uri uri) {
    StringBuilder stringBuilder = new StringBuilder();
    String name = null;
    String message = null;
    try (InputStream inputStream = registrar.activeContext().getContentResolver()
        .openInputStream(uri);) {
      BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
      String line;
      while ((line = reader.readLine()) != null) {
        stringBuilder.append(line);
        stringBuilder.append("\n");
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
    result.success(stringBuilder.toString());
  }

  private void alterDocument(Uri uri, String newContents) {
    String name = null;
    String message = null;
    ParcelFileDescriptor pfd = null;
    FileOutputStream fileOutputStream = null;
    try {
      pfd = registrar.activeContext().getContentResolver().openFileDescriptor(uri, "w");
      if (pfd != null) {
        fileOutputStream = new FileOutputStream(pfd.getFileDescriptor());
        try {
          fileOutputStream.write((newContents).getBytes());
        } catch (IOException e) {
          name = e.getClass().getName();
          message = e.getMessage();
        } finally {
          try {
            fileOutputStream.close();
          } catch (IOException e) {
            name = e.getClass().getName();
            message = e.getMessage();
          }
        }
      }
    } catch (FileNotFoundException e) {
      name = e.getClass().getName();
      message = e.getMessage();
    } finally {
      try {
        if (pfd != null) {
          pfd.close();
        }
      } catch (IOException e) {
        name = e.getClass().getName();
        message = e.getMessage();
      }
    }
    if (name == null) {
      result.success(null);
    } else {
      result.error(name, message, null);
    }
  }
}
