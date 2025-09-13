import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

const _channel = MethodChannel('video_image_merger');

Future<String?> mergeVideoAndImage({
  required String videoPath,
  required String imagePath,
  required String outputPath,
}) async {
  final result = await _channel.invokeMethod<String>('mergeVideoAndImage', {
    'videoPath': videoPath,
    'imagePath': imagePath,
    'outputPath': outputPath,
  });
  return result;
}

Future<void> mergeImageOnTopVideoBottom(
  String videoPath,
  String imagePath,
  String outputPath,
) async {
  // Use a more robust check for file existence
  if (!File(imagePath).existsSync()) {
    print('Error: Image file does not exist at path: $imagePath');
    return;
  }
  if (!File(videoPath).existsSync()) {
    print('Error: Video file does not exist at path: $videoPath');
    return;
  }

  // Define a stable, app-specific directory to store the files
  final appDocsDir = await getApplicationDocumentsDirectory();
  final tempDir = Directory('${appDocsDir.path}/temp_media');
  if (!await tempDir.exists()) {
    await tempDir.create();
  }

  // Create new paths and copy the files
  final stableImagePath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_image.png';
  final stableVideoPath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_video.mp4';

  try {
    await File(imagePath).copy(stableImagePath);
    await File(videoPath).copy(stableVideoPath);
  } catch (e) {
    print('Error copying files: $e');
    return;
  }

  //   // Now, use the stable paths in your FFmpeg command
  //   final command = '''
  // -i $stableImagePath -i $stableVideoPath -filter_complex "[0:v]scale=iw:ih/2[top];[1:v]scale=iw:ih/2[bottom];[top][bottom]vstack=inputs=2[v]" -map "[v]" -map 1:a $outputPath
  //   ''';

  // final command =
  //     '-i $stableImagePath -i $stableVideoPath -filter_complex "[0:v]scale=1280:-1[top];[1:v]scale=1280:-1[bottom];[top][bottom]vstack=inputs=2[v]" -map "[v]" -map 1:a -c:v libx264 -crf 23 -preset veryfast $outputPath';

  final command =
      '-y -loop 1 -i $stableImagePath -i $stableVideoPath '
      '-filter_complex "[0:v]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[top];'
      '[1:v]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1[bot];'
      '[top][bot]vstack=inputs=2[outv]" '
      '-map "[outv]" -map 1:a? '
      '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest -movflags +faststart '
      '$outputPath';

  FFmpegSession session = await FFmpegKit.execute(command);
  // Rest of your code to handle session result

  String? output = await session.getOutput();

  log(output.toString());
}
