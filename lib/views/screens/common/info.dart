// import 'package:template/controllers/user_controller.dart';
import 'package:template/views/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:template/views/base/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  final String title;
  final String data;
  final void Function()? confirmation;
  const Info({
    super.key,
    required this.title,
    required this.data,
    this.confirmation,
  });

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  // final user = Get.find<UserController>();

  // @override
  // void initState() {
  //   super.initState();
  //   user.getSettingsInfo(widget.data).then((val) {
  //     if (val != "success") {
  //       customSnackbar("error_occurred".tr, val);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child:
                // user.isLoading.value
                //     ? const CustomLoading()
                //     :
                Padding(
                  padding: EdgeInsets.only(
                    bottom: widget.confirmation != null ? 80 : 0,
                  ),
                  child: Html(
                    data:
                        // cleanHtml(user.settingsInfo[widget.data]) ??
                        "<p style=\"color: red; text-align: center;\">No Data has been uploaded</p>",
                    style: {
                      // "p": Style(
                      //   fontSize: FontSize(16),
                      //   lineHeight: LineHeight(1.5),
                      //   color: Colors.white,
                      // ),
                      "strong": Style(
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize(16),
                        color: Colors.white,
                      ),
                      "em": Style(
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                      "li": Style(fontSize: FontSize(16), color: Colors.white),
                      "ul": Style(padding: HtmlPaddings(left: HtmlPadding(20))),
                      "ol": Style(padding: HtmlPaddings(left: HtmlPadding(20))),
                      "a": Style(
                        color: Colors.blueAccent,
                        textDecoration: TextDecoration.underline,
                      ),
                    },
                    onLinkTap: (url, attributes, element) {
                      if (url != null) {
                        launchUrl(Uri.parse(url));
                      }
                    },
                  ),
                ),
          ),
          if (widget.confirmation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomButton(
                onTap: () {
                  widget.confirmation!();
                },
                text: "Confirm",
              ),
            ),
        ],
      ),
    );
  }

  /// Cleans HTML from React Quill and other sources
  String? cleanHtml(String? rawHtml) {
    if (rawHtml == null || rawHtml.trim().isEmpty) return null;

    final unescape = HtmlUnescape();

    // Remove leading/trailing whitespace and fix smart quotes
    String cleaned = rawHtml
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('’', "'")
        .replaceAll('\u2028', '') // line separator
        .replaceAll('\u00A0', ' ') // non-breaking space
        .replaceAll('\r', '');

    // Remove any leading closing tags that break flutter_html
    cleaned = cleaned.replaceAll(RegExp(r'^<\/p>|^<\/div>'), '');

    // Remove scripts for safety
    cleaned = cleaned.replaceAll(
      RegExp(r'<script[^>]*>.*?<\/script>', dotAll: true),
      '',
    );

    return unescape.convert(cleaned.trim());
  }
}
