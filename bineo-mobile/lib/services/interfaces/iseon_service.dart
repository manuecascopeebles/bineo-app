abstract class ISeonService {
  Future<bool> validate(String applicationId);
  Future<bool> validateEmailAndPhone(String email, String phone);
  String get transactionId;
}
