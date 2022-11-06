import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remindify/features/sign_up/bloc/sign_up_cubit.dart';
import 'package:remindify/features/sign_up/bloc/sign_up_state.dart';
import 'package:remindify/util/assets.dart';
import 'package:remindify/views/home_screen.dart';

class SignUpCard extends StatefulWidget {
  SignUpCard({
    Key? key,
    this.signInButton,
  }) : super(key: key);

  Widget? signInButton;

  @override
  State<SignUpCard> createState() => _SignUpCardState();
}

class _SignUpCardState extends State<SignUpCard> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late final SignUpCubit _signUpCubit;

  @override
  void initState() {
    super.initState();
    _signUpCubit = BlocProvider.of<SignUpCubit>(context);
    _signUpCubit.setInitialState();

    _emailController.addListener(() {
      setState(() => {});
    });
    _passwordController.addListener(() {
      setState(() => {});
    });
    _confirmPasswordController.addListener(() {
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      bloc: _signUpCubit,
      listener: (blocContext, state) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      },
      listenWhen: (previous, current) =>
          previous.loading && !current.loading && current.errorMessage.isEmpty,
      builder: (bctx, SignUpState signUpState) {
        return Card(
          elevation: kIsWeb ? 5 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: SizedBox(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 45, left: 45, right: 45, bottom: 15),
                      child: SvgPicture.asset(AssetUri.appIconSvg, height: 80),
                    ),
                  ),
                  Center(
                    child: Text(
                      "Never forget your tasks ever again!",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w200),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: _emailField(signUpState),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: _passwordField(signUpState),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: _confirmPasswordField(signUpState),
                  ),
                  const Spacer(),
                  if (signUpState.errorMessage.isNotEmpty) _errorMessage(),
                  if (signUpState.successMessage.isNotEmpty &&
                      signUpState.errorMessage.isEmpty)
                    _successMessage(),
                  _submitButton(signUpState),
                  widget.signInButton ?? Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _submitButton(SignUpState signUpState) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        width: 150,
        child: !signUpState.loading
            ? ElevatedButton(
                onPressed: _isConfirmPasswordOk ? _signUp : null,
                child: const Text("Sign Up"))
            : const Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()),
              ),
      ),
    );
  }

  Padding _successMessage() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        _signUpCubit.state.successMessage,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green.shade200),
      ),
    );
  }

  Padding _errorMessage() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        _signUpCubit.state.errorMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Color.fromARGB(255, 252, 93, 79)),
      ),
    );
  }

  SizedBox _emailField(SignUpState signUpState) {
    return SizedBox(
      width: 380,
      child: TextField(
        enabled: !signUpState.loading,
        controller: _emailController,
        decoration: const InputDecoration(
          icon: Icon(Icons.person_sharp),
          border: UnderlineInputBorder(),
          label: Text(
            'Enter your email',
          ),
        ),
      ),
    );
  }

  Column _passwordField(SignUpState signUpState) {
    return Column(
      children: [
        SizedBox(
          width: 380,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: !signUpState.loading,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.key_sharp),
                    border: UnderlineInputBorder(),
                    label: Text(
                      'Enter your password',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _confirmPasswordField(SignUpState signUpState) {
    return Column(
      children: [
        SizedBox(
          width: 380,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  enabled: !signUpState.loading,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.key_sharp),
                    errorText: !_isConfirmPasswordOk &&
                            _passwordController.text.isNotEmpty
                        ? "Password does not match"
                        : null,
                    border: const UnderlineInputBorder(),
                    label: Text(
                      'Confirm your password',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool get _isConfirmPasswordOk =>
      _passwordController.text == _confirmPasswordController.text &&
      _passwordController.text.isNotEmpty;

  void _signUp() {
    if (_isConfirmPasswordOk) {
      _signUpCubit.signUpWithEmailAndPasswordSubmit(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }
}
