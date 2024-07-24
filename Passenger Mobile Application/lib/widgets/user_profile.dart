import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget
{
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() {
    return _UserProfileState();
  }

}


class _UserProfileState extends State<UserProfile>
{

  final _formKey = GlobalKey<FormState>();
  String _nameInitialValue = "Nishit Chaudhary";
  String _contactNumberInitialValue = "1212121212";
  String _ageInitialValue = "19";
  String _emailInitialValue = "Nishit@gmail.com";


  void _saveUserProfileChanges()
  {
    FocusManager.instance.primaryFocus?.unfocus();
    if(_formKey.currentState!.validate())
      {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Changes successfully saved")));
      }
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10,),
                TextFormField(
                    decoration: const InputDecoration(label: Text("Full Name"),icon: Icon(Icons.account_box_rounded)),
                    keyboardType: TextInputType.name,
                    initialValue: _nameInitialValue,
                    onSaved: (newValue) {
                      _nameInitialValue = newValue!;
                    },
                    validator: (value) {
                      if(value == null || value.toString().isEmpty || !value.toString().trim().contains(" "))
                      {
                        return "Please enter valid full name";
                      }
                      return null;
                    }
                ),                                                              // form fields for signup
                TextFormField(
                    decoration: const InputDecoration(label: Text("Contact Number"), prefix: Text("+91 "), icon: Icon(Icons.phone_enabled_rounded)),
                    keyboardType: TextInputType.number,
                    initialValue: _contactNumberInitialValue,
                    onSaved: (newValue) {
                      _contactNumberInitialValue = newValue!;
                    },
                    validator: (value) {
                      if(value == null || value.toString().isEmpty || value.toString().trim().length<10)
                      {
                        return "Please enter valid contact number";
                      }
                      return null;
                    }
                ),
                TextFormField(
                    decoration: const InputDecoration(label: Text("Age"),icon: Icon(Icons.numbers_rounded)),
                    initialValue: _ageInitialValue,
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) {
                      _ageInitialValue = newValue!;
                    },
                    validator: (value) {
                      if(value == null || value.toString().isEmpty || int.parse(value) <= 0 || int.parse(value) >=100)
                      {
                        return "Please enter valid Age";
                      }
                      return null;
                    }
                ),
                TextFormField(                                                                // form fields for login
                  decoration: const InputDecoration(label: Text("Email"),icon: Icon(Icons.mail_outline_rounded)),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: _emailInitialValue,
                  onSaved: (newValue) {
                    _emailInitialValue = newValue!;
                  },
                  validator: (value) {
                    if(value == null || value.toString().trim().isEmpty || !(value.toString().contains("@")) || value.toString().length<8 || !(value.toString().contains(".")))
                    {
                      return "Invalid Email Address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _saveUserProfileChanges,
                        child: const Text("Save Changes",style: TextStyle(color: Colors.black),))
                  ],
                ),
              ],
            ),
          ),
        ),

    );
  }
}