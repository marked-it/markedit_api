import 'package:markedit_api/model/user.dart';
import 'package:markedit_api/markedit_api.dart';

class IdentityController extends ResourceController {
  IdentityController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getIdentity() async {
    final q = Query<User>(context)
      ..where((o) => o.id).equalTo(request.authorization.ownerID);

    final u = await q.fetchOne();
    if (u == null) {
      return Response.notFound();
    }

    return Response.ok(u);
  }
}
