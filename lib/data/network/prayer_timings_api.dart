import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../responses/prayer_timings/prayer_timings_response.dart';
import '../../app/utils/constants.dart';

part 'prayer_timings_api.g.dart';

/// Prayer timings API client
@RestApi(baseUrl: Constants.baseUrl)
abstract class PrayerTimingsServiceClient {
  factory PrayerTimingsServiceClient(Dio dio, {String? baseUrl}) =
      _PrayerTimingsServiceClient;

  @GET(Constants.prayerTimingPath)
  Future<PrayerTimingsResponse> getPrayerTimings(
    @Path("date") String date,
    @Query("city") String city,
    @Query("country") String country,
    @Query("method") int method,
  );
}
