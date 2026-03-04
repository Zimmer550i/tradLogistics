package com.example.tradlogistics
import android.os.Bundle
import com.google.android.gms.maps.MapsInitializer
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Force Google Maps to use the modern OpenGL renderer
        MapsInitializer.initialize(
            applicationContext,
            MapsInitializer.Renderer.MAP_RENDERER_GL
        )
    }
}