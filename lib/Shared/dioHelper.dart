import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    print('dioHelper Initialized');
    dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api/',
          receiveDataWhenStatusError: true,
        ));
  }

  static Future<Response> postData({
    Map<String, dynamic> ?data
  }) async
  {
    dio.options.headers =
    {
      'Content-Type': 'application/json',
      'Authorization': 'key = AAAAYL4veJ8:APA91bFpOeMWlzsVu108TM4TdaOlcDJg4oO6JUb-r67X4Qgse_xKrf-6olMg93sIU1QyOYS9Xat5hem7HAZPxUnoip2MPxruz0OdrxsCXCILHPrXfB1Rx7dwdcLGDHnkmHkwW208Pe2d'
    };
    return await dio.post(
        'https://fcm.googleapis.com/fcm/send',
      data: data,
    );
  }
}

