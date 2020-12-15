package com.octmon.flutterEasyExample

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import androidx.multidex.MultiDex

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 初始化MultiDex
        MultiDex.install(this)
    }

}
