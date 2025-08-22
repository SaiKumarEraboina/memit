package com.example.memit

import io.flutter.embedding.android.FlutterActivity
// import android.os.Bundle
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
// import com.arthenica.mobileffmpeg.FFmpeg
// import com.arthenica.mobileffmpeg.Config
// import com.arthenica.mobileffmpeg.FFmpeg
// import com.arthenica.mobileffmpeg.FFprobe


class MainActivity: FlutterActivity() {
    // private val CHANNEL = "video_image_merger"

    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)

    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
    //         if (call.method == "mergeVideoAndImage") {
    //             val videoPath = call.argument<String>("videoPath")
    //             val imagePath = call.argument<String>("imagePath")
    //             val outputPath = call.argument<String>("outputPath")

    //             if (videoPath != null && imagePath != null && outputPath != null) {
    //                 val command = arrayOf(
    //                     "-i", videoPath,
    //                     "-i", imagePath,
    //                     "-filter_complex",
    //                     "[0:v]scale=640:360[v0];[1:v]scale=640:360[v1];[v0][v1]vstack=inputs=2[out]",
    //                     "-map", "[out]",
    //                     "-map", "0:a?",
    //                     "-c:v", "libx264",
    //                     "-c:a", "aac",
    //                     "-shortest",
    //                     outputPath
    //                 )

    //                 val rc = FFmpeg.execute(command)

    //                 if (rc == 0) {
    //                     result.success(outputPath)
    //                 } else {
    //                     result.error("FFMPEG_ERROR", "Failed with rc=$rc", null)
    //                 }
    //             } else {
    //                 result.error("INVALID_ARGS", "Missing arguments", null)
    //             }
    //         } else {
    //             result.notImplemented()
    //         }
    //     }
    // }
}