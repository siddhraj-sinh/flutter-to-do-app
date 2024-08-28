import 'package:flutter/material.dart';
import 'package:my_to_do_app/utils/snackbar_helper.dart';
import 'package:my_to_do_app/services/todo_service.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;

  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEdit ? Text("Edit Todo") : Text("Add Todo"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Title'),
              controller: titleController,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Description'),
              minLines: 5,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              controller: descriptionController,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                child: isEdit ? Text('Update') : Text('Submit')),
          )
        ],
      ),
    );
  }

  Future<void> submitData() async {

    final isSuccess = await TodoService.CreateToDo(body);
    // show success or fail message based on status
    if (isSuccess) {
      showSuccessMessage(context, message: "Successfully created todo");
      //reset form
      titleController.text = '';
      descriptionController.text = '';

      Navigator.pop(context);
    } else {
      showErrorMessage(context, message: "Error occurred while creating todo");
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];

    final isSuccess = await TodoService.UpdateById(id, body);

    // show success or fail message based on status
    if (isSuccess) {
      showSuccessMessage(context, message: "Successfully updated todo");
      Navigator.pop(context);
    } else {
      showErrorMessage(context, message: "Error occurred while updating todo");
    }
  }

  Map get body{
    //Get the data
    final title = titleController.text;
    final description = descriptionController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
