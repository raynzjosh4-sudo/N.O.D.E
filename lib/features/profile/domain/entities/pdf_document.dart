import 'package:equatable/equatable.dart';

class PdfDocument extends Equatable {
  final String id;
  final String title;
  final String fileUrl;
  final String fileSize;
  final DateTime updatedAt;

  const PdfDocument({
    required this.id,
    required this.title,
    required this.fileUrl,
    required this.fileSize,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, fileUrl, fileSize, updatedAt];
}
