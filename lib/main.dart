import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_scanner/constants/routes.dart';
import 'package:skill_scanner/views/login_view.dart';
import 'package:skill_scanner/views/register_view.dart';
import 'package:skill_scanner/views/verify_email_view.dart';
import 'package:skill_scanner/views/notes/notes_view.dart';
import 'package:skill_scanner/views/notes/create_update_note_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('[core/duplicate-app]')) {
      debugPrint('Firebase app already initialized');
    } else {
      rethrow;
    }
  }

  runApp(
    // 5️⃣ استفاده از BlocProvider برای تزریق Bloc به سراسر برنامه (بند 5)
    BlocProvider(create: (context) => CounterBloc(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: loginRoute, // ✅ پایداری: مسیر شروع همچنان لاگین است
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
        '/bloc-home': (context) => const HomePage(),
      },
    );
  }
}

// 1️⃣1️⃣ صفحه اصلی جدید (بند 11)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1️⃣9️⃣ کنترلر متن (بند 19)
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Main UI')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 8️⃣ و 2️⃣0️⃣ استفاده از BlocConsumer در بدنه اصلی (بند 8 و 20)
            BlocConsumer<CounterBloc, CounterState>(
              // 6️⃣ بخش Listener: برای کارهای غیر بصری مثل اسنک‌بار (بند 6)
              listener: (context, state) {
                if (state is CounterStateInvalidNumber) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid input: ${state.invalidValue}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              // 7️⃣ بخش Builder: برای ساختن UI بر اساس استیت جدید (بند 7)
              builder: (context, state) {
                return Column(
                  children: [
                    Text(
                      'Counter Value: ${state.value}',
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter a number...',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // 2️⃣0️⃣ بخش دکمه‌ها برای ارسال Event (بند 20)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // ارسال رویداد کاهش
                    context.read<CounterBloc>().add(const DecrementEvent());
                  },
                  child: const Text('- Decrement'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // ارسال رویداد افزایش
                    context.read<CounterBloc>().add(const IncrementEvent());
                  },
                  child: const Text('+ Increment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- 🟦 بخش منطق Bloc (بدون تغییر برای حفظ پایداری) ---

@immutable
abstract class CounterEvent {
  const CounterEvent();
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent();
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent();
}

@immutable
abstract class CounterState {
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;
  const CounterStateInvalidNumber({
    required int previousValue,
    required this.invalidValue,
  }) : super(previousValue);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>(
      (event, emit) => emit(CounterStateValid(state.value + 1)),
    );
    on<DecrementEvent>(
      (event, emit) => emit(CounterStateValid(state.value - 1)),
    );
  }
}
