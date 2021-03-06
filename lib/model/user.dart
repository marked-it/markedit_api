import 'package:markedit_api/markedit_api.dart';

class User extends ManagedObject<_User> implements _User, ManagedAuthResourceOwner<_User> {
  @Serialize(input: true, output: false)
  String password;
}

class _User extends ResourceOwnerTableDefinition {
  @Column()
  String firstName;

  @Column()
  String lastName;

  @Column(unique: true)
  String email;

  ManagedSet<PasswordResetToken> passwordResetTokens;
}