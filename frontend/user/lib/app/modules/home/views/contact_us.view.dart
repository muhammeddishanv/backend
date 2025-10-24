import 'package:ed_tech/app/core/utils/extensions/input_decorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/*

  This is the contact us view for the user.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Saabith k
  date : 2025-08-15
*/

class ContactUsView extends GetResponsiveView {
  ContactUsView({super.key}) : super(alwaysUseBuilder: false);

  final String phon = '9876543210';
  final String email = 'company.name.info@gmail.com';

  @override
  Widget? phone() {
    return Scaffold(
      primary: false,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Get.theme.primaryColor,
        foregroundColor: Get.theme.colorScheme.onPrimary,
        centerTitle: true,
        title: Text('Contact Us'),
      ),
      body: _Content(phone: phon, email: email),
    );
  }

  @override
  Widget? tablet() => super.tablet();
  @override
  Widget? desktop() => super.desktop();
}

class _Content extends StatelessWidget {
  const _Content({required this.phone, required this.email});

  final String phone;
  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6),
          Text(
            'Get In Touch',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'If you have any inquiries get in touch with us\nWe\'ll be happy to help you',
            style: TextStyle(fontSize: 14, height: 1.3, color: theme.hintColor),
          ),
          SizedBox(height: 6),
          _LabeledStaticField(
            label: 'Phone',
            value: phone,
            icon: Icons.phone_outlined,
          ),

          _LabeledStaticField(
            label: 'Email',
            value: email,
            icon: Icons.mail_outline,
          ),
          SizedBox(height: 6),

          Text(
            'Social Media',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Follow us on',
            style: TextStyle(fontSize: 14, color: theme.hintColor),
          ),

          Row(
            spacing: 10,
            children: [
              FaIcon(
                FontAwesomeIcons.instagram,
                color: theme.primaryColor,
                size: 20,
              ),
              FaIcon(
                FontAwesomeIcons.facebook,
                color: theme.primaryColor,
                size: 20,
              ),
              FaIcon(
                FontAwesomeIcons.xTwitter,
                color: theme.primaryColor,
                size: 20,
              ),
            ],
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _LabeledStaticField extends StatelessWidget {
  const _LabeledStaticField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    final controller = TextEditingController(text: value);

    return AbsorbPointer(
      absorbing: true,
      child: TextField(
        enabled: false,
        controller: controller,
        decoration: inputDecoration(label, hint: value).copyWith(
          prefixIcon: Icon(icon),
          filled: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
        ),
      ),
    );
  }
}
