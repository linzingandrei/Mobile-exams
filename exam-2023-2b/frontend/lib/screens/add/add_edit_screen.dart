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
  late TextFieldDescriptor nameDescriptor;
  late TextFieldDescriptor descriptionDescriptor;
  late TextFieldDescriptor categoryDescriptor;
  late TextFieldDescriptor dateDescriptor;
  late TextFieldDescriptor timeDescriptor;
  late TextFieldDescriptor intensityDescriptor;
  late bool isInEditMode;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    isInEditMode = widget.entityToUpdate != null;
    
    nameDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.name?? "",
      decoration: getDecoration("name")
    );
    descriptionDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.description ?? "",
      decoration: getDecoration("description")
    );
    categoryDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.category ?? "",
      decoration: getDecoration("category")
    );
    dateDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.date ?? "",
      decoration: getDecoration("date")
    );
    timeDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.time.toString() ?? "",
      decoration: getDecoration("time"),
      numericInput: true
    );
    intensityDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
      ..text = widget.entityToUpdate?.intensity ?? "",
      decoration: getDecoration("intensity"),
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
          textFieldFromDescriptor(nameDescriptor),
          textFieldFromDescriptor(descriptionDescriptor),
          textFieldFromDescriptor(categoryDescriptor),
          textFieldFromDescriptor(dateDescriptor),
          textFieldFromDescriptor(timeDescriptor),
          textFieldFromDescriptor(intensityDescriptor)
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
      name: nameDescriptor.controller.text,
      description: descriptionDescriptor.controller.text,
      category: categoryDescriptor.controller.text,
      date: dateDescriptor.controller.text,
      time: timeDescriptor.controller.text.isNotEmpty
        ? int.parse(timeDescriptor.controller.text)
        : 0,
      intensity: intensityDescriptor.controller.text
    );

    if (isInEditMode) {
      subscription = viewModel.updateEntity(myEntity.id!, myEntity.intensity!).listen(listener);
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
    nameDescriptor.controller.dispose();
    descriptionDescriptor.controller.dispose();
    categoryDescriptor.controller.dispose();
    dateDescriptor.controller.dispose();
    timeDescriptor.controller.dispose();
    intensityDescriptor.controller.dispose();
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