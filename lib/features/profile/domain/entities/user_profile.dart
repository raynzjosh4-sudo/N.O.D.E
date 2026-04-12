import 'package:equatable/equatable.dart';
import 'business_profile.dart';
import 'wholesale_order.dart';
import 'draft_order.dart';
import 'saved_product.dart';
import 'pdf_document.dart';

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String? profilePicUrl;
  final BusinessProfile businessProfile;
  final List<WholesaleOrder> orders;
  final List<DraftOrder> drafts;
  final List<SavedProduct> savedItems;
  final List<PdfDocument> documents;

  const UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePicUrl,
    required this.businessProfile,
    this.orders = const [],
    this.drafts = const [],
    this.savedItems = const [],
    this.documents = const [],
  });

  @override
  List<Object?> get props => [
    id,
    email,
    fullName,
    profilePicUrl,
    businessProfile,
    orders,
    drafts,
    savedItems,
    documents,
  ];
}
