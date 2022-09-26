package com.akash.trivia_fun

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.widget.Toast
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull;

class MainActivity: FlutterActivity() {
    private val CHANNEL = "ourproject.sendstring"

    	 override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    	MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler { call, result ->
      		if (call.method == "callSendStringFun") {
     			showHelloFromFlutter(call.argument("arg"))
     			val temp = sendString()
	         //     String message = "Vibrated device for 2500ms";
             //     Vibrator vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE); 
			 //		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			 //		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			 //			vibrator.vibrate(VibrationEffect.createOneShot(2500,VibrationEffect.DEFAULT_AMPLITUDE));
			 //		}
			 //		}else{
			 //		vibrator.vibrate(2500);
			 //		}  
          		result.success(temp)
      		} else {
        		result.notImplemented()
      		}
    	}
  	}

  	private fun sendString(): String {
    	val stringToSend: String = "Hello from Kotlin"
    	return stringToSend
  	}

  	private fun showHelloFromFlutter(argFromFlutter : String?){
  		Toast.makeText(this, argFromFlutter, Toast.LENGTH_SHORT).show()
  	}
}
