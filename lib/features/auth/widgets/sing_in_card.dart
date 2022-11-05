import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remindify/features/auth/bloc/auth_cubit.dart';
import 'package:remindify/features/auth/bloc/auth_state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remindify/util/assets.dart';
import 'package:remindify/views/home_screen.dart';

class SignInCard extends StatefulWidget {
  SignInCard({
    Key? key,
    Widget? this.signUpButton,
  }) : super(key: key);

  Widget? signUpButton;

  @override
  State<SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<SignInCard> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _authCubit.resetFields();
    _authCubit.restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      bloc: _authCubit,
      listener: (blocContext, state) {
        if (state.isSignedIn) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      },
      builder: (bctx, AuthState signInState) {
        return Card(
          elevation: 5,
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
                    child: SizedBox(
                      width: 380,
                      child: TextField(
                        enabled: !signInState.loading,
                        onSubmitted: (_) => _signIn(),
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person_sharp),
                          border: UnderlineInputBorder(),
                          label: Text(
                            'Enter your email',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 380,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: !signInState.loading,
                                  controller: _passwordController,
                                  onSubmitted: (_) => _signIn(),
                                  obscureText: _hidePassword,
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.key_sharp),
                                    suffixIcon: SizedBox(
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () => setState(() =>
                                            _hidePassword = !_hidePassword),
                                        child: Icon(
                                          _hidePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    border: const UnderlineInputBorder(),
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
                    ),
                  ),
                  const Spacer(),
                  if (signInState.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _authCubit.state.errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 252, 93, 79)),
                      ),
                    ),
                  if (signInState.successMessage.isNotEmpty &&
                      signInState.errorMessage.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        _authCubit.state.successMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green.shade200),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      width: 150,
                      child: !signInState.loading
                          ? ElevatedButton(
                              onPressed: _signIn, child: const Text("Sign In"))
                          : const Center(
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator()),
                            ),
                    ),
                  ),
                  widget.signUpButton ?? Container(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _signIn() {
    _authCubit.signInSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }
}
