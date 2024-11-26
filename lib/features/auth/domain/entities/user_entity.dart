// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String phoneNumber;
  final String name;
  final String userType;
  final String? imageUrl;
  const UserEntity({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.userType,
    this.imageUrl,
  });

  @override
  List<Object?> get props =>[id, email, phoneNumber, name, userType, imageUrl];
}
