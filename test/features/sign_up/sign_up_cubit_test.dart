import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:remindify/entities/remindify_user.dart';
import 'package:remindify/features/sign_up/bloc/sign_up_cubit.dart';
import 'package:remindify/features/sign_up/bloc/sign_up_state.dart';
import 'package:remindify/interfaces/services/auth_service.dart';
import 'package:remindify/util/usecase_result.dart';

import '../../dependency_injector.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  const String validEmail = "facuarancet97@gmail.com";
  const String validPassword = "somepass";
  final RemindifyUser validRemindifyUser =
      RemindifyUser(id: "somevalidid", email: validEmail);

  final AuthService authService = MockAuthService();

  setUpDependencyInjector(authService: authService);

  group("Sign up tests", () {
    blocTest<SignUpCubit, SignUpState>(
      "Init state values",
      build: () => SignUpCubit(),
      verify: (cubit) {
        expect(cubit.state.errorMessage, '');
        expect(cubit.state.loading, false);
        expect(cubit.state.successMessage, '');
      },
    );

    blocTest<SignUpCubit, SignUpState>(
      "Set initial state",
      build: () => SignUpCubit(),
      act: (cubit) => cubit.setInitialState(),
      expect: () => [SignUpState.initial],
    );

    blocTest<SignUpCubit, SignUpState>(
      "Sign up with valid email and password",
      build: () => SignUpCubit(),
      setUp: () {
        when(
          () => authService.signUpWithEmailAndPassword(
            email: validEmail,
            password: validPassword,
          ),
        ).thenAnswer(
          (_) async => Result.success(data: validRemindifyUser),
        );
      },
      act: (cubit) {
        cubit.signUpWithEmailAndPasswordSubmit(validEmail, validPassword);
      },
      expect: () => [
        SignUpState.initial.toLoading(),
        SignUpState.initial.toSuccess(),
      ],
      verify: (cubit) {
        verify(
          () => authService.signUpWithEmailAndPassword(
            email: validEmail,
            password: validPassword,
          ),
        ).called(1);
      },
    );

    blocTest<SignUpCubit, SignUpState>(
      "Sign up with valid email and password twice",
      build: () => SignUpCubit(),
      setUp: () {
        final List<Result<RemindifyUser>> inOrderResults = [
          Result.success(data: validRemindifyUser),
          Result.error(message: "User already exists"),
        ];
        when(
          () => authService.signUpWithEmailAndPassword(
            email: validEmail,
            password: validPassword,
          ),
        ).thenAnswer(
          (_) async => inOrderResults.removeAt(0),
        );
      },
      act: (cubit) async {
        await cubit.signUpWithEmailAndPasswordSubmit(validEmail, validPassword);
        await cubit.signUpWithEmailAndPasswordSubmit(validEmail, validPassword);
      },
      expect: () => [
        SignUpState.initial.toLoading(),
        SignUpState.initial.toSuccess(),
        SignUpState.initial.toLoading(),
        SignUpState.initial.toError(error: "User already exists"),
      ],
      verify: (cubit) {
        verify(
          () => authService.signUpWithEmailAndPassword(
            email: validEmail,
            password: validPassword,
          ),
        ).called(2);
      },
    );
  });
}
