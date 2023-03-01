import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lecture_1/text_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecture 1'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldWidget(
                controller: _idController,
                keyboardType: TextInputType.number,
                hintText: 'ID',
                validation: 'Please enter your id',
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                controller: _nameController,
                hintText: 'Name',
                validation: 'Please enter your name',
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                controller: _ageController,
                keyboardType: TextInputType.number,
                hintText: 'Age',
                validation: 'Please enter your age',
              ),
              const SizedBox(height: 40),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      onPressed: performData,
                    ),
            ],
          ).paddingSymmetric(horizontal: 15),
        ),
      ),
    );
  }

  void performData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        saveData();
      });
    }
  }

  Future<void> saveData() async {
    FocusNode().requestFocus();
    isLoading = true;
    await FirebaseFirestore.instance.collection('users').add(
      {
        'id': _idController.text.trim().toString(),
        'name': _nameController.text.trim().toString(),
        'age': _ageController.text.trim().toString(),
      },
    ).then((value) {
      setState(() {
        isLoading = false;
        _idController.clear();
        _nameController.clear();
        _ageController.clear();
      });
      Get.snackbar(
        'Successfully',
        'Successfully added',
        backgroundColor: Colors.green,
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      );
    });
  }
}
