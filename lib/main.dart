
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Ilova
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Register App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7FC),
      ),
      home: const LoginPage(),
    );
  }
}

// Foydalanuvchi modeli
class UserAccount {
  final String name;
  final String email;
  final String password;

  UserAccount({
    required this.name,
    required this.email,
    required this.password,
  });
}

// Ro'yxatdan o'tgan foydalanuvchilar
class AuthService {
  static final List<UserAccount> users = [];

  static bool register(
    String name,
    String email,
    String password,
  ) {
    bool exists = users.any(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );

    if (exists) return false;

    users.add(
      UserAccount(
        name: name,
        email: email,
        password: password,
      ),
    );

    return true;
  }

  static UserAccount? login(String email, String password) {
    for (var user in users) {
      if (user.email.toLowerCase() == email.toLowerCase() &&
          user.password == password) {
        return user;
      }
    }

    return null;
  }
}

// LOGIN SAHIFASI
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  void login() {
    if (!formKey.currentState!.validate()) return;

    final user = AuthService.login(
      emailController.text.trim(),
      passwordController.text,
    );

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email yoki parol noto‘g‘ri!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_person,
                    size: 85,
                    color: Colors.blue,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Xush kelibsiz!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Hisobingizga kirish uchun ma’lumotlarni kiriting',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 35),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'example@gmail.com',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email kiriting';
                      }

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value.trim())) {
                        return 'Email noto‘g‘ri';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // PAROL
                  TextFormField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: 'Parol',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Parol kiriting';
                      }

                      if (value.length < 6) {
                        return 'Parol kamida 6 ta belgidan iborat bo‘lsin';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  // KIRISH TUGMASI
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'KIRISH',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // RO'YXATDAN O'TISHGA O'TISH
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Hisobingiz yo‘qmi?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text('Ro‘yxatdan o‘tish'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// RO'YXATDAN O'TISH SAHIFASI
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void register() {
    if (!formKey.currentState!.validate()) return;

    final success = AuthService.register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ro‘yxatdan muvaffaqiyatli o‘tdingiz!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu email oldin ro‘yxatdan o‘tgan!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ro‘yxatdan o‘tish'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Colors.blue,
                ),

                const SizedBox(height: 15),

                const Text(
                  'Yangi hisob yaratish',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // ISM
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Ism va familiya',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ismingizni kiriting';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // EMAIL
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email kiriting';
                    }

                    if (!RegExp(
                      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                    ).hasMatch(value.trim())) {
                      return 'Email noto‘g‘ri';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PAROL
                TextFormField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    labelText: 'Parol',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Parol kiriting';
                    }

                    if (value.length < 6) {
                      return 'Kamida 6 ta belgi kiriting';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // PAROLNI TASDIQLASH
                TextFormField(
                  controller: confirmController,
                  obscureText: hideConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Parolni tasdiqlang',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          hideConfirmPassword = !hideConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Parolni qayta kiriting';
                    }

                    if (value != passwordController.text) {
                      return 'Parollar mos kelmadi';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // RO'YXATDAN O'TISH TUGMASI
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'RO‘YXATDAN O‘TISH',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hisobim bor. Kirish'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ASOSIY SAHIFA
class HomePage extends StatelessWidget {
  final UserAccount user;

  const HomePage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bosh sahifa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Chiqish',
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 110,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              const Text(
                'Muvaffaqiyatli kirdingiz!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Xush kelibsiz, ${user.name}!',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Email: ${user.email}',
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Tizimdan chiqish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
