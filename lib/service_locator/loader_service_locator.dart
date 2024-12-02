import 'package:get_it/get_it.dart';
import 'package:meka/features/loader/presentation/blocs/loader_cubit.dart';

class LoaderServiceLocator{
  static Future<void> execute({required GetIt sl})async{
    sl.registerLazySingleton(()=>LoaderBloc());
  }
}