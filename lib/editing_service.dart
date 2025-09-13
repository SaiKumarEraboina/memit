// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:path_provider/path_provider.dart';

// class EditingService {
//   // Trim video
//   Future<void> trimVideo(String inputPath, String outputPath, String start, String end) async {
//     await FFmpegKit.execute('-i $inputPath -ss $start -to $end -c copy $outputPath');
//   }

//   // Crop video
//   Future<void> cropVideo(String inputPath, String outputPath, int width, int height, int x, int y) async {
//     await FFmpegKit.execute('-i $inputPath -filter:v "crop=$width:$height:$x:$y" $outputPath');
//   }

//   // Resize video
//   Future<void> resizeVideo(String inputPath, String outputPath, int width, int height) async {
//     await FFmpegKit.execute('-i $inputPath -vf "scale=$width:$height" $outputPath');
//   }

//   // Rotate video
//   Future<void> rotateVideo(String inputPath, String outputPath, int angle) async {
//     String transpose;
//     switch (angle) {
//       case 90:
//         transpose = 'transpose=1';
//         break;
//       case 180:
//         transpose = 'transpose=2,transpose=2';
//         break;
//       case 270:
//         transpose = 'transpose=2';
//         break;
//       default:
//         transpose = '';
//     }
//     await FFmpegKit.execute('-i $inputPath -vf "$transpose" $outputPath');
//   }

//   // Extract audio
//   Future<void> extractAudio(String inputPath, String outputPath) async {
//     await FFmpegKit.execute('-i $inputPath -q:a 0 -map a $outputPath');
//   }
// }

// class ImageEditingPage extends StatefulWidget {
//   const ImageEditingPage({Key? key}) : super(key: key);

//   @override
//   State<ImageEditingPage> createState() => _ImageEditingPageState();
// }

// class _ImageEditingPageState extends State<ImageEditingPage> {
//   File? _imageFile;

//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _cropImage() async {
//     if (_imageFile == null) return;
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: _imageFile!.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Image',
//           toolbarColor: Colors.deepOrange,
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//         ),
//         IOSUiSettings(
//           title: 'Crop Image',
//         ),
//       ],
//     );
//     if (croppedFile != null) {
//       setState(() {
//         _imageFile = File(croppedFile.path);
//       });
//     }
//   }

//   Future<void> _rotateImage() async {
//     if (_imageFile == null) return;
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: _imageFile!.path,
//       rotateDegrees: 90,
//       uiSettings: [
//         AndroidUiSettings(toolbarTitle: 'Rotate Image'),
//         IOSUiSettings(title: 'Rotate Image'),
//       ],
//     );
//     if (croppedFile != null) {
//       setState(() {
//         _imageFile = File(croppedFile.path);
//       });
//     }
//   }

//   Future<void> _saveImage() async {
//     if (_imageFile == null) return;
//     final directory = await getApplicationDocumentsDirectory();
//     final String path = directory.path;
//     final String fileName = 'edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
//     final File newImage = await _imageFile!.copy('$path/$fileName');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Image saved to $path/$fileName')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Editing UI')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: Center(
//                 child: _imageFile == null
//                     ? const Text('No image selected.')
//                     : Image.file(_imageFile!),
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.photo_library),
//                   label: const Text('Pick'),
//                   onPressed: _pickImage,
//                 ),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.crop),
//                   label: const Text('Crop'),
//                   onPressed: _cropImage,
//                 ),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.rotate_right),
//                   label: const Text('Rotate'),
//                   onPressed: _rotateImage,
//                 ),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.save),
//                   label: const Text('Save'),
//                   onPressed: _saveImage,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
