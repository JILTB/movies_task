import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movies_task/di.dart';
import 'package:movies_task/models/view_models/login_screen_view_model.dart';
import 'package:movies_task/widgets/button.dart';
import 'package:rxdart/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginScreenViewModelType _viewModel = DI.resolve();
  final _subscription = CompositeSubscription();

  @override
  void initState() {
    _subscription
      ..add(
        _viewModel.output.signInOrCreateUserSuccess.listen((_) {
          if (mounted) context.go('/list');
        }),
      )
      ..add(
        _viewModel.output.errors.listen((error) {
          if (error != null) {
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)));
            }
          }
        }),
      );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 250, left: 16, right: 16),
        child: Center(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(label: Text('Email')),
                onChanged: _viewModel.input.setEmail,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(label: Text('Password')),
                onChanged: _viewModel.input.setPassword,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareIconTextButton(
                    onPressed: _viewModel.input.createAccount,
                    icon: Symbols.person_add,
                    label: 'create account',
                    buttonColor: Colors.red,
                  ),
                  SizedBox(width: 16),
                  SquareIconTextButton(
                    onPressed: _viewModel.input.signIn,
                    icon: Symbols.login,
                    label: 'sign in',
                    buttonColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
