import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/model/my_entity.dart';
import 'package:frontend/repo/repo.dart';
import 'package:frontend/screens/add/add_edit_view_model.dart';
import 'package:frontend/utils.dart';

class AddEditScreen extends StatefulWidget {
  final MyEntity? entityToUpdate;
  final String? username;

  const AddEditScreen({Key? key, this.entityToUpdate, this.username}) : super(key: key);

  @override
  State<AddEditScreen> createState() => AddEditScreenState();
}

class AddEditScreenState extends State<AddEditScreen> {
  final AddEditViewModel viewModel = AddEditViewModel(Repo());
  late TextFieldDescriptor dateDescriptor;
  late TextFieldDescriptor titleDescriptor;
  late TextFieldDescriptor ingredientsDescriptor;
  late TextFieldDescriptor categoryDescriptor;
  late TextFieldDescriptor ratingDescriptor;
  late bool isInEditMode;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    isInEditMode = widget.entityToUpdate != null;
    
    dateDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.date ?? "",
      decoration: getDecoration("date")
    );
    titleDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.title ?? "",
      decoration: getDecoration("title")
    );
    ingredientsDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.ingredients ?? "",
      decoration: getDecoration("ingredients")
    );
    categoryDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.category ?? "",
      decoration: getDecoration("category")
    );
    ratingDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.rating.toString() ?? "",
      decoration: getDecoration("rating"),
      numericInput: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body
    );
  }

  Widget get body => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          textFieldFromDescriptor(dateDescriptor),
          textFieldFromDescriptor(titleDescriptor),
          textFieldFromDescriptor(ingredientsDescriptor),
          textFieldFromDescriptor(categoryDescriptor),
          textFieldFromDescriptor(ratingDescriptor)
        ],
      ),
    ),
  );

  AppBar get appBar => AppBar(
    foregroundColor: Colors.black54,
    title: Text(
      isInEditMode ? "EDIT" : "ADD",
      style: const TextStyle(fontSize: 30, color: Colors.black54),
    ),
    actions: [
      IconButton(
        onPressed: onDonePressed,
        icon: const Icon(
          Icons.check,
          color: Colors.black54,
        ),
      )
    ],
  );

  VoidCallback get onDonePressed => () {
    listener(response) {
      if (response == "ok") {
        Navigator.of(context).pop();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.displayError(context, response.toString());
        });
      }
    }

    var myEntity = MyEntity(
      id: isInEditMode ? widget.entityToUpdate!.id : null,
      date: dateDescriptor.controller.text,
      title: titleDescriptor.controller.text,
      ingredients: ingredientsDescriptor.controller.text,
      category: categoryDescriptor.controller.text,
      rating: ratingDescriptor.controller.text.isNotEmpty
        ? double.parse(ratingDescriptor.controller.text)
        : 0.0
    );

    if (isInEditMode) {
      subscription = viewModel.updateEntity(myEntity).listen(listener);
    } else {
      subscription = viewModel.addEntity(myEntity).listen(listener);
    }
  };

  Widget textFieldFromDescriptor(TextFieldDescriptor descriptor) => TextField(
    decoration: descriptor.decoration,
    controller: descriptor.controller,
    keyboardType: 
      descriptor.numericInput ? TextInputType.number : TextInputType.text,
    style: const TextStyle(color: Colors.white),
  );

  InputDecoration getDecoration(String title) => InputDecoration(
    labelText: title,
    labelStyle: const TextStyle(color: Colors.grey),
  );
  
  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    dateDescriptor.controller.dispose();
    titleDescriptor.controller.dispose();
    ingredientsDescriptor.controller.dispose();
    categoryDescriptor.controller.dispose();
    ratingDescriptor.controller.dispose();
  }
}

class TextFieldDescriptor {
  final TextEditingController controller;
  final InputDecoration decoration;
  final bool numericInput;

  TextFieldDescriptor({
    required this.controller,
    required this.decoration,
    this.numericInput = false
  });
}