import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class ExerciseCsvFileSelection {
  const ExerciseCsvFileSelection({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

abstract interface class ExerciseCsvFileSelector {
  Future<ExerciseCsvFileSelection?> selectCsv();
}

class FilePickerExerciseCsvFileSelector implements ExerciseCsvFileSelector {
  const FilePickerExerciseCsvFileSelector();

  @override
  Future<ExerciseCsvFileSelection?> selectCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.length != 1) return null;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return null;
    return ExerciseCsvFileSelection(name: file.name, bytes: bytes);
  }
}
