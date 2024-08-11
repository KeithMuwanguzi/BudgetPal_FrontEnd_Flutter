import 'package:budgetpal/util/appendpoints.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:budgetpal/models/export.dart';

part 'endpoint.g.dart';

@RestApi(baseUrl: AppEndPoints.baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(AppEndPoints.loginEndPoint)
  Future<CustomUser> loginUser(@Body() Map<String, dynamic> loginData);

  @POST(AppEndPoints.registerEndPoint)
  Future<CustomUser> registerUser(@Body() Map<String, dynamic> userData);

  @GET(AppEndPoints.getUsersEndPoint)
  Future<List<CustomUser>> getUsers();

  @GET(AppEndPoints.getIncomeList)
  Future<List<Income>> getIncomeList();

  @POST(AppEndPoints.addIncome)
  Future<Income> addIncome(@Body() Map<String, dynamic> incomeData);

  @GET(AppEndPoints.getExpenseList)
  Future<List<Expense>> getExpenseList();

  @POST(AppEndPoints.addExpense)
  Future<Expense> addExpense(@Body() Map<String, dynamic> expenseData);

  @GET(AppEndPoints.getIncomeAnalytics)
  Future getIncomeAnalytics();
}
