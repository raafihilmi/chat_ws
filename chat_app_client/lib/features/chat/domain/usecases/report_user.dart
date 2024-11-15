import 'package:chat_app_client/core/usecases/usecase.dart';
import 'package:chat_app_client/features/chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class ReportUser implements UseCase<void, ReportUserParams> {
  final UserRepository userRepository;

  ReportUser(this.userRepository);


  @override
  Future<Either<Failure, void>> call(ReportUserParams params) {
    return userRepository.reportUser(params.reason, params.reportedUserId);
  }
}

class ReportUserParams {
  final int reportedUserId;
  final String reason;

  const ReportUserParams({required this.reason,required this.reportedUserId});
}