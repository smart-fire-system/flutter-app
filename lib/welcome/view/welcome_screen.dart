import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../generated/l10n.dart';
import '../../utils/localization_util.dart';
import '../../repositories/auth_repository.dart';
import '../bloc/bloc.dart';
import '../bloc/event.dart';
import '../bloc/state.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).app_name,
          style: GoogleFonts.cairo(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              LocalizationUtil.showEditLanguageDialog(context);
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => WelcomeBloc(authRepository: authRepository),
        child: BlocBuilder<WelcomeBloc, WelcomeState>(
          builder: (context, state) {
            if (state is WelcomeInitial) {
              EasyLoading.show(status: S.of(context).wait_while_loading);
              context.read<WelcomeBloc>().add(CheckAuthenticationStatus());
              return Container();
            } else if (state is WelcomeLoading) {
              EasyLoading.show(status: S.of(context).wait_while_loading);
              return Container();
            } else if (state is WelcomeAuthenticated) {
              EasyLoading.dismiss();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, '/home');
              });
            } else if (state is WelcomeUnauthenticated) {
              EasyLoading.dismiss();
            }
            return _buildWelcomeScreen(context);
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 50.0, right: 50.0, bottom: 50.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 50.0),
                  child: Text(
                    S.of(context).welcome_message,
                    style: GoogleFonts.cairo(
                        fontSize: 30.0, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 151, 197, 160),
                      minimumSize: const Size(double.infinity, 50),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                    ),
                    child: Text(
                      S.of(context).login,
                      style: GoogleFonts.cairo(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 151, 197, 160),
                      minimumSize: const Size(double.infinity, 50),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.center,
                    ),
                    child: Text(
                      S.of(context).signup,
                      style: GoogleFonts.cairo(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
