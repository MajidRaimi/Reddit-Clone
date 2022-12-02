import 'package:fpdart/fpdart.dart';
import 'package:redit_tutorial/core/failure.dart';

// T stands for generic
typedef FutureEither<T> = Future<Either<Failure, T>>;

// returning void 
typedef FutureVoid = FutureEither<void>; 
