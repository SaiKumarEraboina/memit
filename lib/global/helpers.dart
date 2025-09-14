import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
import 'package:path_provider/path_provider.dart';

bool isVideoFile(File file) {
  final isVideo = file.path.toLowerCase().endsWith('mp4') ||
      file.path.toLowerCase().endsWith('mov');

  return isVideo;
}

Future<String?> mergeImagesAsCollage(
  List<String> filePaths, {
  bool outputAsImage = true,
  int videoDurationSeconds = 3,
}) async {
  if (filePaths.isEmpty) return null;
  if (filePaths.length > 4) {
    // If you need >4 support, we can expand this later.
    throw ArgumentError('This function supports up to 4 images currently.');
  }

  // Create stable directory and output path
  final tmpDir = await getTemporaryDirectory();
  final outDir = Directory('${tmpDir.path}/collage_temp');
  if (!await outDir.exists()) await outDir.create(recursive: true);

  final outputPath = outputAsImage
      ? '${outDir.path}/${DateTime.now().millisecondsSinceEpoch}_collage.jpg'
      : '${outDir.path}/${DateTime.now().millisecondsSinceEpoch}_collage.mp4';

  // Build input arguments: for images, use -loop 1 -t 1 -i "path" (or -t videoDurationSeconds for video)
  // Using -t 1 for each looped image provides at least 1 second stream; for still image output
  // we will use -frames:v 1 so the duration doesn't matter.
  final inputParts = filePaths.map((p) {
    final safe = p.replaceAll('"', r'\"');
    // We add -t <seconds> to each to make them a stream; using 1s is enough for still extraction
    final t = outputAsImage ? 1 : videoDurationSeconds;
    return '-loop 1 -t $t -i "$safe"';
  }).join(' ');

  // Build filter: scale+pad each input to a uniform size, then vstack them vertically
  // Use 640x360 as base; change if you want different width/height
  const int targetW = 640;
  const int targetH = 360;

  final buffer = StringBuffer();
  for (var i = 0; i < filePaths.length; i++) {
    buffer.write(
      '[$i:v]scale=$targetW:$targetH:force_original_aspect_ratio=decrease,'
      'pad=$targetW:$targetH:(ow-iw)/2:(oh-ih)/2,setsar=1[i$i];',
    );
  }

  // Build vstack input list like [i0][i1][i2]vstack=inputs=3[v]
  final inputLabels = List.generate(filePaths.length, (i) => '[i$i]').join();
  buffer.write('$inputLabels' 'vstack=inputs=${filePaths.length}[v]');

  final filter = buffer.toString();

  // Final command
  String command;
  if (outputAsImage) {
    // Output single JPG still
    // -frames:v 1 ensures only one frame written; -q:v 2 gives good quality jpg
    command =
        '-y $inputParts -filter_complex "$filter" -map "[v]" -frames:v 1 -q:v 2 "$outputPath"';
  } else {
    // Output a short MP4 video (libx264). -shortest ensures it won't exceed streams length.
    // Add -r 30 for fps and -movflags for faststart.
    command =
        '-y $inputParts -filter_complex "$filter" -map "[v]" -c:v libx264 -r 30 -pix_fmt yuv420p -shortest -movflags +faststart "$outputPath"';
  }

  log('FFmpeg command: $command');

  final session = await FFmpegKit.execute(command);

  final returnCode = await session.getReturnCode();
  final outLog = await session.getOutput();
  final errLog = await session.getAllLogs(); // optional more verbose logs

  log('FFmpeg return code: $returnCode');
  log('FFmpeg output: $outLog');

  // Check success
  if (returnCode != null && returnCode.isValueSuccess()) {
    log('Collage created: $outputPath');
    return outputPath;
  } else {
    log('FFmpeg failed. ReturnCode=$returnCode. Output=$outLog');
    return null;
  }
}

/// Merge two videos into one output
/// [isVertical] = true -> stack vertically (top/bottom)
/// [isVertical] = false -> stack horizontally (left/right)
Future<String?> mergeTwoVideos(
  String videoPath1,
  String videoPath2, {
  bool isVertical = true,
}) async {
  if (!File(videoPath1).existsSync()) {
    print('Error: Video file does not exist at path: $videoPath1');
    return null;
  }
  if (!File(videoPath2).existsSync()) {
    print('Error: Video file does not exist at path: $videoPath2');
    return null;
  }

  // Create stable directory and output path
  final tmpDir = await getTemporaryDirectory();
  final outDir = Directory('${tmpDir.path}/collage_temp');
  if (!await outDir.exists()) await outDir.create(recursive: true);

  final outputPath =
      '${outDir.path}/${DateTime.now().millisecondsSinceEpoch}_collage.mp4';

  // Stable paths
  final appDocsDir = await getApplicationDocumentsDirectory();
  final tempDir = Directory('${appDocsDir.path}/temp_media');
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }

  final stablePath1 =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_v1.mp4';
  final stablePath2 =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_v2.mp4';

  await File(videoPath1).copy(stablePath1);
  await File(videoPath2).copy(stablePath2);

  // Choose stacking mode
  final stackFilter =
      isVertical ? 'vstack=inputs=2[outv]' : 'hstack=inputs=2[outv]';

  // Both videos are scaled to same size before stacking
  final command = '-y -i $stablePath1 -i $stablePath2 '
      '-filter_complex "[0:v]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1[v0];'
      '[1:v]scale=640:360:force_original_aspect_ratio=decrease,pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1[v1];'
      '[v0][v1]$stackFilter" '
      '-map "[outv]" -map 0:a? -map 1:a? '
      '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest -movflags +faststart '
      '"$outputPath"';

  log('FFmpeg command: $command');

  final session = await FFmpegKit.execute(command);
  final logs = await session.getOutput();

  log('FFmpeg logs: $logs');
  return outputPath;
}

///////////////////////
///
///
///
///
Future<String?> mergeImageOnTopVideoBottom(
  String videoPath,
  String imagePath,
) async {
  if (!File(imagePath).existsSync()) {
    print('Error: Image file does not exist at path: $imagePath');
    return null;
  }
  if (!File(videoPath).existsSync()) {
    print('Error: Video file does not exist at path: $videoPath');
    return null;
  }

  final appDocsDir = await getApplicationDocumentsDirectory();
  final tempDir = Directory('${appDocsDir.path}/temp_media');
  if (!await tempDir.exists()) {
    await tempDir.create();
  }

  final tmpDir = await getTemporaryDirectory();
  final outDir = Directory('${tmpDir.path}/collage_temp');
  if (!await outDir.exists()) await outDir.create(recursive: true);

  final outputPath =
      '${outDir.path}/${DateTime.now().millisecondsSinceEpoch}_collage.mp4';

  final stableImagePath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_image.png';
  final stableVideoPath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_video.mp4';

  await File(imagePath).copy(stableImagePath);
  await File(videoPath).copy(stableVideoPath);

  // 🔹 Get video duration using ffprobe
  final probeSession =
      await FFmpegKit.execute('-i "$stableVideoPath" -hide_banner');
  final probeOutput = await probeSession.getAllLogsAsString();
  final durationMatch =
      RegExp(r'Duration: (\d+):(\d+):(\d+\.\d+)').firstMatch(probeOutput ?? '');
  int totalSeconds = 10; // fallback
  if (durationMatch != null) {
    final h = int.parse(durationMatch.group(1)!);
    final m = int.parse(durationMatch.group(2)!);
    final s = double.parse(durationMatch.group(3)!);
    totalSeconds = (h * 3600 + m * 60 + s).floor();
  }

  // 🔹 Add `-t $totalSeconds` to the image input
  final command =
      '-y -loop 1 -t $totalSeconds -i "$stableImagePath" -i "$stableVideoPath" '
      '-filter_complex "[0:v]scale=640:360:force_original_aspect_ratio=decrease,'
      'pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[top];'
      '[1:v]scale=640:360:force_original_aspect_ratio=decrease,'
      'pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1[bot];'
      '[top][bot]vstack=inputs=2[outv]" '
      '-map "[outv]" -map 1:a? '
      '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest -movflags +faststart '
      '"$outputPath"';

  log('FFmpeg command: $command');

  final session = await FFmpegKit.execute(command);
  final logs = await session.getOutput();
  log('FFmpeg logs: $logs');

  return outputPath;
}

Future<String?> mergeVideoOnTopImageBottom(
  String videoPath,
  String imagePath,
) async {
  if (!File(imagePath).existsSync()) {
    print('Error: Image file does not exist at path: $imagePath');
    return null;
  }
  if (!File(videoPath).existsSync()) {
    print('Error: Video file does not exist at path: $videoPath');
    return null;
  }

  final appDocsDir = await getApplicationDocumentsDirectory();
  final tempDir = Directory('${appDocsDir.path}/temp_media');
  if (!await tempDir.exists()) {
    await tempDir.create();
  }

  final tmpDir = await getTemporaryDirectory();
  final outDir = Directory('${tmpDir.path}/collage_temp');
  if (!await outDir.exists()) await outDir.create(recursive: true);

  final outputPath =
      '${outDir.path}/${DateTime.now().millisecondsSinceEpoch}_collage.mp4';

  final stableImagePath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_image.png';
  final stableVideoPath =
      '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_video.mp4';

  await File(imagePath).copy(stableImagePath);
  await File(videoPath).copy(stableVideoPath);

  // 🔹 Get video duration using ffprobe (via ffmpeg logs)
  final probeSession =
      await FFmpegKit.execute('-i "$stableVideoPath" -hide_banner');
  final probeOutput = await probeSession.getAllLogsAsString();
  final durationMatch =
      RegExp(r'Duration: (\d+):(\d+):(\d+\.\d+)').firstMatch(probeOutput ?? '');
  int totalSeconds = 10; // fallback
  if (durationMatch != null) {
    final h = int.parse(durationMatch.group(1)!);
    final m = int.parse(durationMatch.group(2)!);
    final s = double.parse(durationMatch.group(3)!);
    totalSeconds = (h * 3600 + m * 60 + s).floor();
  }

  // 🔹 Build ffmpeg command (video on top, image on bottom)
  final command =
      '-y -i "$stableVideoPath" -loop 1 -t $totalSeconds -i "$stableImagePath" '
      '-filter_complex "[0:v]scale=640:360:force_original_aspect_ratio=decrease,'
      'pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1[top];'
      '[1:v]scale=640:360:force_original_aspect_ratio=decrease,'
      'pad=640:360:(ow-iw)/2:(oh-ih)/2,setsar=1,fps=30[bot];'
      '[top][bot]vstack=inputs=2[outv]" '
      '-map "[outv]" -map 0:a? '
      '-c:v libx264 -pix_fmt yuv420p -c:a aac -shortest -movflags +faststart '
      '"$outputPath"';

  log('FFmpeg command: $command');

  final session = await FFmpegKit.execute(command);
  final logs = await session.getOutput();
  log('FFmpeg logs: $logs');

  return outputPath;
}
