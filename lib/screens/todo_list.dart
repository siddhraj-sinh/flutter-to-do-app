import 'package:flutter/material.dart';
import 'package:my_to_do_app/screens/add_page.dart';
import 'package:my_to_do_app/services/todo_service.dart';
import 'package:my_to_do_app/utils/snackbar_helper.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late Future<List> futureItems;

  @override
  void initState() {
    super.initState();
    futureItems = fetchTodo(); // Initialize the future in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text("Add Todo"),
      ),
      body: FutureBuilder<List>(
        future: futureItems, // Use the future in FutureBuilder
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while the future is being fetched
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Show an error message if something goes wrong
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final items = snapshot.data!;
            return items.isEmpty
                ? Center(
                    child: Text(
                      'No Todo Items',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final item = items[index] as Map;
                      final id = item['_id'] as String;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(item['title']),
                          subtitle: Text(item['description']),
                          trailing: PopupMenuButton(onSelected: (value) {
                            if (value == 'edit') {
                              //Edit item
                              navigateToEditPage(item);
                            } else if (value == 'delete') {
                              //Delete and remove the item
                              deleteById(id);
                            }
                          }, itemBuilder: (context) {
                            return [
                              PopupMenuItem(child: Text('Edit'), value: 'edit'),
                              PopupMenuItem(
                                  child: Text('Delete'), value: 'delete'),
                            ];
                          }),
                        ),
                      );
                    },
                  );
          } else {
            // Handle the case where no data is available
            return const Center(
              child: Text('No items found'),
            );
          }
        },
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddToDoPage());
    await Navigator.push(context, route);
    setState(() {
      futureItems = fetchTodo();
    });
  }

  Future<void> navigateToEditPage(Map item) async {
    final route =
        MaterialPageRoute(builder: (context) => AddToDoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      futureItems = fetchTodo();
    });
  }

  Future<List> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      return response;
    } else {
      showErrorMessage(context, message: "Error occured while fetching todos");
      return [];
    }
  }

  Future<void> deleteById(String id) async {

    var isSuccess = await TodoService.DeleteById(id);
    if (isSuccess) {
      // Refresh the futureItems after deleting the item
      setState(() {
        futureItems = fetchTodo();
      });
    } else {
      showErrorMessage(context, message: "Error occurred while deleting todo");
    }
  }
}
