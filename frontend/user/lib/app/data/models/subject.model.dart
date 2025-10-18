/* this is a dummy model of a subject
  It contains basic information about a subject, such as its ID, title, and image URL.

  created by : Muhammed Shabeer OP
  date : 2025-08-13
  updated on : 2025-08-13
 */

class SubjectModel {
  final int subjectId;
  final String title;
  final String imageUrl;

  SubjectModel({
    required this.subjectId,
    required this.title,
    required this.imageUrl,
  });
}
