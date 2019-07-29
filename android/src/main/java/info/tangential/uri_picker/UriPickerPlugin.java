package info.tangential.uri_picker;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

/** UriPickerPlugin */
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
      Uri uri = Uri.parse(call.argument("uri"));
      switch(call.method) {
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
          alterDocument(uri, call.argument("newContents"));
          break;
        default:
          result.notImplemented();
      }
    }
  }

  private void performFileSearch() {
    Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("text/plain");
    intent.setFlags(
        Intent.FLAG_GRANT_READ_URI_PERMISSION
            | Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
    registrar.activity().startActivityForResult(intent, OPEN_REQUEST_CODE);
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent resultData) {
    if (requestCode == OPEN_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
      Uri uri = resultData.getData();
      if (uri != null) {
        result.success(uri.toString());
        return true;
      }
    }
    result.error("onActivityResult",
        "Unhandled request code, or null result data", null);
    return true;
  }

  public void getDisplayName(Uri uri) {
    String displayName = null;
    Cursor cursor = this.getContentResolver().query(uri, null, null, null, null, null);
    try {
      if (cursor != null && cursor.moveToFirst()) {
        displayName = cursor.getString(
          cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
      }
    } finally {
      cursor.close();
    }
    channelResult.success(displayName);
  }

  private void isUriOpenable(Uri uri) {
    InputStream inputStream = null;
    String name = null;
    String message = null;
    try {
      inputStream = this.getContentResolver().openInputStream(uri);
    } catch (FileNotFoundException e) {
      name = e.getClass().getName();
      message = e.getMessage();
    } finally {
      if (inputStream != null) {
        try {
          inputStream.close();
        } catch (IOException e) {
        }
      }
      if (name == null) {
        channelResult.success(null);
      } else {
        channelResult.error(name, message, null);
      }
    }
  }

  private void takePersistablePermission(Uri uri) {
    try {
      this.getContentResolver().takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
    } catch(Exception e) {
      e.printStackTrace();
    } finally {
      channelResult.success(null);
    }
  }


  public void readTextFromUri(Uri uri) {
    InputStream inputStream = null;
    StringBuilder stringBuilder = new StringBuilder();
    String name = null;
    String message = null;
    try {
      inputStream = this.getContentResolver().openInputStream(uri);
      BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
      String line;
      while ((line = reader.readLine()) != null) {
        stringBuilder.append(line + "\n");
      }
    } catch (IOException e) {
      e.printStackTrace();
    } finally {
      if (inputStream != null) {
        try {
          inputStream.close();
        } catch (IOException e) {

        }
      }
    }
    if (name == null) {
      channelResult.success(stringBuilder.toString());
    } else {
      channelResult.error(name, message, null);
    }
  }

  private void alterDocument(Uri uri, String newContents) {
    String name = null;
    String message = null;
    ParcelFileDescriptor pfd = null;
    FileOutputStream fileOutputStream = null;
    try {
      pfd = this.getContentResolver().openFileDescriptor(uri, "w");
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
    } catch (FileNotFoundException e) {
      name = e.getClass().getName();
      message = e.getMessage();
    } finally {
      try {
        pfd.close();
      } catch (IOException e) {
        name = e.getClass().getName();
        message = e.getMessage();
      }
    }
    if (name == null) {
      channelResult.success(null);
    } else {
      channelResult.error(name, message, null);
    }
  }
}
