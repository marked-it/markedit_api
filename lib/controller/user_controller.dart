import 'package:markedit_api/markedit_api.dart';

/// This [ResourceController] handles the endpoint to preform CRUD operations
/// on [User]s. It is only accessible after logging in with OAuth2.0
class UserController extends ResourceController {
  UserController(this.context, this.authServer);
  final ManagedContext context;
  final AuthServer authServer;

  /// Returns a JSON formatted list of all [User]s in the database.
  @Operation.get()
  Future<Response> getAllUsers() async {
    return Response.ok(await Query<User>(context).fetch());
  }

  /// Returns the [User] from the database specified by the [id].
  @Operation.get('id')
  Future<Response> getUser(@Bind.path('id') int id) async {
    // Get the user specified from the database
    final _user = await (Query<User>(context)
      ..where((user) => user.id).equalTo(id)
    ).fetchOne();

    // Return an error if the user was not located in the database
    if (_user == null) {
      return Response.notFound();
    }

    // Return the user specified
    return Response.ok(_user);
  }

  /// Update the [User] with the specified [id]. All values from the [User] object are
  /// valid except the password and id fields.
  @Operation('PATCH', 'id')
  Future<Response> updateUser(@Bind.path('id') int id, @Bind.body(ignore: ["id", "password"]) User user) async {
    if (request.authorization.ownerID != id) {
      Response.unauthorized();
    }

    // Update the user in the DB using the values provided
    final _user = await (Query<User>(context)
      ..values = user
      ..where((user) => user.id).equalTo(id)
    ).updateOne();

    // Return an error if the user being updated was not located in the database
    if (_user == null) {
      return Response.notFound();
    }

    // Return the updated user
    return Response.ok(_user);
  }

  /// Deletes the [User] with the specified [id] from the database.
  @Operation.delete('id')
  Future<Response> deleteUser(@Bind.path('id') int id) async {
    if (request.authorization.ownerID != id) {
      return Response.unauthorized();
    }

    // Delete and de-authorize all login tokens for this user
    await authServer.revokeAllGrantsForResourceOwner(id);

    // Delete the user from the DB, this will delete any resources created by them
    await (Query<User>(context)
      ..where((user) => user.id).equalTo(id)
    ).delete();

    // Return an empty success code showing the user was deleted
    return Response.ok(null);
  }

  @override
  Map<String, APIResponse> documentOperationResponses(APIDocumentContext context, Operation operation) {
    final Map<String, APIResponse> _response = {};
    var _userSchema = context.schema.getObjectWithType(User);

    context.defer(() {
      _userSchema = context.document.components.resolve(_userSchema);
      _userSchema.properties.remove("tokens");
      _userSchema.properties.remove("passwordResetTokens");
    });

    if (operation.pathVariables.isEmpty && operation.method == "GET") {
      _response['200'] = APIResponse.schema("Users Fetched Successfully", APISchemaObject.array(ofSchema: _userSchema));
    } else if (operation.pathVariables.isNotEmpty && operation.method == "GET") {
      _response['200'] = APIResponse.schema("User Fetched Successfully", _userSchema);
    } else if (operation.pathVariables.isNotEmpty && operation.method == "PATCH") {
      _response['200'] = APIResponse.schema("User Updated Successfully", _userSchema);
    }

    return _response;
  }
}