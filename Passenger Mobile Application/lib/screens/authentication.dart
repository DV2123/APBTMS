import 'package:bus_karo/screens/home.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget
{
  void Function({required bool change}) changeUserAuthenticationStatus;
  AuthenticationScreen({super.key, required this.changeUserAuthenticationStatus});


  @override
  State<AuthenticationScreen> createState() {
    return _AuthenticationScreenState();
  }

}

class _AuthenticationScreenState extends State<AuthenticationScreen>
{

  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();

  void _loginUser()
  {
    FocusManager.instance.primaryFocus?.unfocus();
    if(_formKey.currentState!.validate())
      {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Successful!")));
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen(),));
        widget.changeUserAuthenticationStatus(change: true);
      }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    bottom: 5
                    , left: 15, right: 20, top: 30),
                width: 500,
                child: Image.asset("lib/assets/images/bus.png"),
              ),
              Container(
                padding: const EdgeInsets.only(right: 14, left: 14, bottom: 14, top: 0),
                child: Card(
                  elevation: 7,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 17,right: 17, top: 7, bottom: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(_isLogin) TextFormField(                                                                // form fields for login
                                decoration: const InputDecoration(label: Text("Registered Email"), icon: Icon(Icons.mail_outline_rounded)),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (newValue) {

                                },
                                validator: (value) {
                                  if(value == null || value.toString().trim().isEmpty || !(value.toString().contains("@")) || value.toString().length<8 || !(value.toString().contains(".")))
                                    {
                                      return "Invalid Email Address";
                                    }
                                    return null;
                                },
                              ),
                              const SizedBox(height: 5,),
                              if(_isLogin) TextFormField(
                                decoration: const InputDecoration(label: Text("Password"),icon: Icon(Icons.password_rounded)),
                                obscureText: true,
                                keyboardType: TextInputType.visiblePassword,
                                onSaved: (newValue) {

                                },
                                validator: (value) {
                                  if(value == null || value.toString().isEmpty || value.toString().trim().length<6)
                                  {
                                    return "Password must be 6 character long";
                                  }
                                  return null;
                                },

                              ),
                              if(!_isLogin) TextFormField(
                                  decoration: const InputDecoration(label: Text("Full Name"),icon: Icon(Icons.account_box_rounded)),
                                  keyboardType: TextInputType.name,
                                  onSaved: (newValue) {

                                  },
                                  validator: (value) {
                                    if(value == null || value.toString().isEmpty || !value.toString().trim().contains(" "))
                                    {
                                      return "Please enter valid full name";
                                    }
                                    return null;
                                  }
                              ),                                                              // form fields for signup
                              if(!_isLogin) TextFormField(
                                  decoration: const InputDecoration(label: Text("Contact Number"), prefix: Text("+91 "), icon: Icon(Icons.phone_enabled_rounded)),
                                  keyboardType: TextInputType.number,
                                  onSaved: (newValue) {

                                  },
                                  validator: (value) {
                                    if(value == null || value.toString().isEmpty || value.toString().trim().length<10)
                                    {
                                      return "Please enter valid contact number";
                                    }
                                    return null;
                                  }
                              ),
                              if(!_isLogin) TextFormField(
                                  decoration: const InputDecoration(label: Text("Age"),icon: Icon(Icons.numbers_rounded)),
                                  keyboardType: TextInputType.number,
                                  onSaved: (newValue) {

                                  },
                                  validator: (value) {
                                    if(value == null || value.toString().isEmpty || int.parse(value) <= 0 || int.parse(value) >=100)
                                    {
                                      return "Please enter valid Age";
                                    }
                                    return null;
                                  }
                              ),
                              if(!_isLogin) TextFormField(                                                                // form fields for login
                                decoration: const InputDecoration(label: Text("Email"),icon: Icon(Icons.mail_outline_rounded)),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (newValue) {

                                },
                                validator: (value) {
                                  if(value == null || value.toString().trim().isEmpty || !(value.toString().contains("@")) || value.toString().length<8 || !(value.toString().contains(".")))
                                  {
                                    return "Invalid Email Address";
                                  }
                                  return null;
                                },
                              ),
                              if(!_isLogin) TextFormField(
                                decoration: const InputDecoration(label: Text("Password"),icon: Icon(Icons.password_rounded)),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                onSaved: (newValue) {

                                },
                                validator: (value) {
                                  if(value == null || value.toString().isEmpty || value.toString().trim().length<6)
                                  {
                                    return "Password must be 6 character long";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30,),
                              ElevatedButton(
                                  onPressed: _isLogin ? _loginUser : (){
                                    if(_formKey.currentState!.validate())
                                      {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        ScaffoldMessenger.of(context).clearSnackBars();
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup Successful, Login to continue.")));
                                        setState(() {
                                          _isLogin = true;
                                        });
                                      }
                                  },
                                  child: Text(_isLogin ? "Login":"Signup", style: TextStyle(color: Colors.blueAccent.shade400,))
                              ),
                              TextButton(
                                  onPressed: (){
                                    setState(() {
                                      _formKey.currentState!.reset();
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin ? "Create Account":"Already Have Account"),
                              )
                            ],
                          ),
                        ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      )

    );
  }
}