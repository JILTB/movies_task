import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movies_task/di.dart';
import 'package:movies_task/models/view_models/account_screen_view_model.dart';
import 'package:movies_task/widgets/button.dart';
import 'package:rxdart/rxdart.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountScreenViewModelType _viewModel = DI.resolve();
  final _subscription = CompositeSubscription();

  @override
  void initState() {
    _subscription.add(
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
    _subscription.add(
      _viewModel.output.signOutOrCreateUserSuccess.listen((_) {
        if (mounted) context.go('/login_screen');
      }),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Screen')),
      body: StreamBuilder<User>(
        stream: _viewModel.output.user,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Center(
                child: Column(
                  children: [
                    Text(snapshot.data!.email ?? ''),
                    SizedBox(height: 16),
                    Text(snapshot.data!.uid),
                    SizedBox(height: 16),
                    SquareIconTextButton(
                      buttonColor: Colors.red,
                      icon: Symbols.logout,
                      onPressed: _viewModel.input.signOut,
                      label: 'sign out',
                    ),
                  ],
                ),
              )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
