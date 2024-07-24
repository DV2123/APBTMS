import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatelessWidget
{
  ContactUs({super.key});

  TextEditingController issueController = TextEditingController();

  void _onReport(BuildContext context)
  {
    issueController.clear();
    FocusManager.instance.primaryFocus!.unfocus();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Issue Reported Successfully")));
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            TextField(
              decoration: const InputDecoration(label: Text("Report Issue")),
              maxLength: 50,
              controller: issueController,
            ),
            const SizedBox(height: 30,),
            Row(
              children: [
                const SizedBox(width: 109,),
                ElevatedButton(onPressed: (){_onReport(context);}, child: const Text("Report"))
              ],
            ),
            const SizedBox(height: 100,),
             Row(
              children: [
                const SizedBox(width: 10,),
                const Icon(Icons.phone_enabled_rounded),
                const SizedBox(width: 20,),
                InkWell(
                    onTap: () async {
                      Uri phoneno = Uri.parse('tel:+911234567891');
                      if (await launchUrl(phoneno)) {}else{}
                    },
                    child: const Text("+91 1234567891", style: TextStyle(fontWeight: FontWeight.bold),)),
              ],
            ),
            const SizedBox(height: 10),
             Row(
              children: [
                const SizedBox(width: 10,),
                const Icon(Icons.mail_outline_rounded),
                const SizedBox(width: 20,),
                InkWell(
                    onTap: () async{
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'BusManagement@gmail.com',
                      );
                      await launchUrl(emailLaunchUri);
                    },
                    child: const Text("BusManagement@gmail.com",style: TextStyle(fontWeight: FontWeight.bold))),
              ],
            )
          ],
        ),
      ),
    );
  }

}

