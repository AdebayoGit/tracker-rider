import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  const CommentDialog({Key? key}) : super(key: key);

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  bool _loading = false;

  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              child: Image.asset('./assets/images/trucks.jpg'),
              //height: 200,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: TextFormField(
                controller: _username,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    label: Text('Username'),
                    hintText: 'TruckMan',
                    prefixIcon: Icon(Icons.person)),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              child: !_loading
                  ? ElevatedButton(
                onPressed: () {
                  //signIn();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  maximumSize: Size(_size.width * 0.8, 50),
                  primary: Colors.grey,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
