import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'subscription_page.dart';
import 'app_bottom_nav.dart';
import 'home_page.dart';
import 'media_tab_page.dart';

class AppUser {
  final String username;
  final String email;
  final String mobile;
  final String password;
  final String gender;

  AppUser({
    required this.username,
    required this.email,
    required this.mobile,
    required this.password,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'mobile': mobile,
    'password': password,
    'gender': gender,
  };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    username: json['username'],
    email: json['email'],
    mobile: json['mobile'],
    password: json['password'],
    gender: json['gender'],
  );
}

class UserSession {
  static bool isLoggedIn = false;
  static String currentUserName = '';
  static String currentUserEmail = '';
  static List<AppUser> registeredUsers = [];

  static Future<void> saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userListString = registeredUsers.map((u) => jsonEncode(u.toJson())).toList();
    await prefs.setStringList('saved_users', userListString);
  }

  static Future<void> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? userListString = prefs.getStringList('saved_users');
    if (userListString != null) {
      registeredUsers = userListString.map((str) => AppUser.fromJson(jsonDecode(str))).toList();
    }
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoginMode = false;
  bool obscurePassword = true;
  String selectedGender = 'مرد';
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    UserSession.loadUsers().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // رنگ‌های پویا بر اساس تم
    final Color scaffoldBg = isDark ? const Color(0xFF0D1117) : Colors.white;
    final Color cardBg = isDark ? const Color(0xFF161D26) : Colors.grey[100]!;
    final Color primaryGreen = isDark ? const Color(0xFF00E676) : const Color(0xFF00A859);
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white54 : Colors.black54;
    final Color borderColor = isDark ? Colors.white12 : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          UserSession.isLoggedIn ? 'حساب کاربری' : (isLoginMode ? 'ورود به حساب' : 'ثبت نام'),
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: UserSession.isLoggedIn
              ? _buildUserDashboard(isDark, cardBg, primaryGreen, textColor, subTextColor, borderColor)
              : _buildAuthForm(isDark, cardBg, primaryGreen, textColor, subTextColor, borderColor),
        ),
      ),

      bottomNavigationBar: AppBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index != 3) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreenWithIndex(initialIndex: index),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildUserDashboard(bool isDark, Color cardBg, Color primaryGreen, Color textColor, Color subTextColor, Color borderColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('۰ %', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('اشتراک ندارید!', style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 60,child: VerticalDivider(thickness: 1,width: 1,),),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ساعت', style: TextStyle(color: subTextColor, fontSize: 11)),
                      const SizedBox(width: 8),
                      Text('روز', style: TextStyle(color: subTextColor, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('۰۰ :۰۰', style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('زمان باقی مانده اکانت شما', style: TextStyle(color: subTextColor, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  SubscriptionPage(isDark: isDark)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.workspace_premium, color: primaryGreen, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'خرید اشتراک',
                  style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, color: subTextColor, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildActionTile(
          title: 'نام کاربری',
          subtitle: UserSession.currentUserName,
          icon: Icons.person_outline_rounded,
          iconColor: primaryGreen,
          cardBg: cardBg,
          textColor: textColor,
          subTextColor: subTextColor,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'ایمیل',
          subtitle: UserSession.currentUserEmail,
          icon: Icons.email_outlined,
          iconColor: primaryGreen,
          cardBg: cardBg,
          textColor: textColor,
          subTextColor: subTextColor,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'خروج از حساب',
          subtitle: 'خروج از حساب کاربری فعلی',
          icon: Icons.logout_rounded,
          iconColor: primaryGreen,
          cardBg: cardBg,
          textColor: textColor,
          subTextColor: subTextColor,
          onTap: () {
            setState(() {
              UserSession.isLoggedIn = false;
              UserSession.currentUserName = '';
              UserSession.currentUserEmail = '';
              _usernameController.clear();
              _emailController.clear();
              _mobileController.clear();
              _passwordController.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12)),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: subTextColor.withValues(alpha: 0.5), size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthForm(bool isDark, Color cardBg, Color primaryGreen, Color textColor, Color subTextColor, Color borderColor) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { isLoginMode = false; errorMessage = null; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isLoginMode ? primaryGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ثبت نام',
                        style: TextStyle(
                          color: !isLoginMode ? (isDark ? Colors.black : Colors.white) : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() { isLoginMode = true; errorMessage = null; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isLoginMode ? primaryGreen : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ورود',
                        style: TextStyle(
                          color: isLoginMode ? (isDark ? Colors.black : Colors.white) : textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent),
              ),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
          ],

          _buildCustomTextField(
            controller: _usernameController,
            label: 'نام کاربری',
            hint: 'نام کاربری را وارد کنید',
            icon: Icons.person_outline_rounded,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
            primaryGreen: primaryGreen,
            borderColor: borderColor,
            validator: (val) => val!.isEmpty ? 'لطفاً نام کاربری را وارد کنید' : null,
          ),
          const SizedBox(height: 16),

          if (!isLoginMode) ...[
            _buildCustomTextField(
              controller: _emailController,
              label: 'آدرس ایمیل',
              hint: 'آدرس ایمیل خود را وارد کنید',
              icon: Icons.email_outlined,
              cardBg: cardBg,
              textColor: textColor,
              subTextColor: subTextColor,
              primaryGreen: primaryGreen,
              borderColor: borderColor,
              validator: (val) {
                if (val == null || val.isEmpty) return 'لطفاً ایمیل خود را وارد کنید';
                if (!val.endsWith('@gmail.com') || val.length <= 10) return 'ایمیل باید شامل @gmail.com باشد';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildCustomTextField(
              controller: _mobileController,
              label: 'شماره موبایل',
              hint: 'شماره موبایل را وارد کنید',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              cardBg: cardBg,
              textColor: textColor,
              subTextColor: subTextColor,
              primaryGreen: primaryGreen,
              borderColor: borderColor,
              validator: (val) {
                if (val == null || val.isEmpty) return 'لطفاً شماره موبایل را وارد کنید';
                if (!RegExp(r'^09[0-9]{9}$').hasMatch(val)) return 'شماره موبایل باید ۱۱ رقم و با 09 شروع شود';
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          _buildCustomTextField(
            controller: _passwordController,
            label: 'رمز عبور',
            hint: 'رمز عبور را وارد کنید',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            cardBg: cardBg,
            textColor: textColor,
            subTextColor: subTextColor,
            primaryGreen: primaryGreen,
            borderColor: borderColor,
            validator: (val) => val!.length < 6 ? 'رمز عبور حداقل باید ۶ رقم باشد' : null,
          ),
          const SizedBox(height: 16),

          if (!isLoginMode) ...[
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedGender = 'زن'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedGender == 'زن' ? primaryGreen : borderColor,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'زن',
                        style: TextStyle(
                          color: selectedGender == 'زن' ? primaryGreen : textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedGender = 'مرد'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selectedGender == 'مرد' ? primaryGreen : borderColor,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'مرد',
                        style: TextStyle(
                          color: selectedGender == 'مرد' ? primaryGreen : textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final username = _usernameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  setState(() {
                    errorMessage = null;

                    if (isLoginMode) {
                      final existingUser = UserSession.registeredUsers.where((u) => u.username == username);

                      if (existingUser.isEmpty) {
                        errorMessage = 'این کاربر وجود ندارد! لطفاً ابتدا ثبت‌نام کنید.';
                      } else if (existingUser.first.password != password) {
                        errorMessage = 'رمز عبور اشتباه است!';
                      } else {
                        UserSession.isLoggedIn = true;
                        UserSession.currentUserName = username;
                        UserSession.currentUserEmail = existingUser.first.email;
                      }
                    } else {
                      bool userExists = UserSession.registeredUsers.any((u) =>
                      u.username.toLowerCase() == username.toLowerCase() ||
                          u.email.toLowerCase() == email.toLowerCase()
                      );

                      if (userExists) {
                        errorMessage = 'این کاربر یا اطلاعات تکراری وجود دارد!';
                      } else {
                        UserSession.registeredUsers.add(AppUser(
                          username: username,
                          email: email,
                          mobile: _mobileController.text.trim(),
                          password: password,
                          gender: selectedGender,
                        ));

                        UserSession.saveUsers();

                        UserSession.isLoggedIn = true;
                        UserSession.currentUserName = username;
                        UserSession.currentUserEmail = email;
                      }
                    }
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_rounded, color: isDark ? Colors.black : Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    isLoginMode ? 'ورود به حساب' : 'ثبت نام',
                    style: TextStyle(color: isDark ? Colors.black : Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required Color cardBg,
    required Color textColor,
    required Color subTextColor,
    required Color primaryGreen,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 6),
          child: Text(
            label,
            style: TextStyle(color: subTextColor, fontSize: 12),
          ),
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword && obscurePassword,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: subTextColor.withValues(alpha: 0.6), fontSize: 13),
            filled: true,
            fillColor: cardBg,
            prefixIcon: isPassword
                ? IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: subTextColor,
                size: 20,
              ),
              onPressed: () => setState(() => obscurePassword = !obscurePassword),
            )
                : null,
            suffixIcon: Icon(icon, color: subTextColor, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: primaryGreen),
            ),


          ),
          validator: validator,
        ),
      ],
    );
  }
}


class MainScreenWithIndex extends StatefulWidget {
  final int initialIndex;
  const MainScreenWithIndex({super.key, required this.initialIndex});

  @override
  State<MainScreenWithIndex> createState() => _MainScreenWithIndexState();
}

class _MainScreenWithIndexState extends State<MainScreenWithIndex> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomePage(),
    const MediaTabPage(key: ValueKey('series_tab'), isSeries: true, title: 'سریال‌ها'),
    const MediaTabPage(key: ValueKey('movies_tab'), isSeries: false, title: 'فیلم‌ها'),
    const AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1017) : Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}