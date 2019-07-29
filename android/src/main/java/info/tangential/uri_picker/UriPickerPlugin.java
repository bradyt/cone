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
      result.notImplemented();
    }
  }

  private void performFileSearch() {
    Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("text/plain");
    intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
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
}
