import 'package:budgetpal/util/appendpoints.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'endpoint.g.dart';

@RestApi(baseUrl: AppEndPoints.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(AppEndPoints.loginEndPoint)
  Future<dynamic> signIn({@Body() required Map<String, String> body});

  @GET(AppEndPoints.getUsersEndPoint)
  Future<dynamic> getUsers();

  @GET(AppEndPoints.getIncomeList)
  Future<dynamic> getIncomeList();

  @GET(AppEndPoints.getIncomeAnalytics)
  Future<dynamic> getIncomeAnalytics();

  @GET(AppEndPoints.getExpenseList)
  Future<dynamic> getExpensesList();

  @POST(AppEndPoints.registerEndPoint)
  Future<dynamic> signUp({@Body() required Map<String, String> body});

  @POST(AppEndPoints.addIncome)
  Future<dynamic> addIncome({@Body() required Map<String, String> body});

  @POST(AppEndPoints.addExpense)
  Future<dynamic> addExpense({@Body() required Map<String, String> body});

  @POST(AppEndPoints.logoutEndPoint)
  Future<dynamic> signOut();
}
