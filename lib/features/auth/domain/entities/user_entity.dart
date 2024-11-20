import 'package:equatable/equatable.dart';

class UserEntity extends Equatable{
  final int id;

  const UserEntity({required this.id});

  @override
  List<Object?> get props =>[id];
}