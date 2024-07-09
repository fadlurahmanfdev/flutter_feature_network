import 'package:example/data/dto/response/base_bebas_response.dart';
import 'package:example/data/dto/response/base_response.dart';
import 'package:example/data/dto/response/guest_token/guest_token_response.dart';
import 'package:flutter_feature_network/flutter_feature_network.dart';
import 'package:uuid/uuid.dart';

abstract class RepositoryDatasource {
  Future<BaseResponse<GuestTokenResponse>> generateGuestToken();
}

class RepositoryDatasourceImpl extends RepositoryDatasource {
  Dio sslDio;

  RepositoryDatasourceImpl({required this.sslDio});

  @override
  Future<BaseResponse<GuestTokenResponse>> generateGuestToken() async {
    try {
      final res = await sslDio.post(
        'https://api.bankmas.my.id/identity-service/guest/session/create',
        data: {
          'guestId': const Uuid().v4(),
        },
      );
      final dataMap = res.data as Map<String, dynamic>? ?? {};
      return BaseBebasResponse<GuestTokenResponse>.fromJson(
          dataMap, (json) => GuestTokenResponse.fromJson(json as Map<String, dynamic>? ?? {}));
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
