

import 'package:flutter/material.dart';
import 'package:gaindesat_ddp_client/models/category_model.dart';
import 'package:gaindesat_ddp_client/services/admin/category_services.dart';

import '../../../services/helper.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final GlobalKey<FormState> _key = GlobalKey();
  bool _showForm = false;

  late final Future<List<ReduceCategory>> futureCategories;
  late final ReduceCategory category = ReduceCategory.empty();
  void _toggleFormShow() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryService().fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Category Management',
              style: TextStyle(
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(
          color: isDarkMode(context)
              ? Colors.tealAccent
              : Colors.tealAccent
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 1,
                        right: 29
                    ),
                    child: FloatingActionButton.extended(
                      heroTag: 'AddCategory',
                      backgroundColor: Colors.teal,
                      tooltip: 'Add New Category',
                      elevation: 10,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.tealAccent,
                      ),
                      onPressed: _toggleFormShow,
                      label: const Text(
                        'Add Category',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12
                  ),
                child: FutureBuilder<List<ReduceCategory>>(
                  future: futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            elevation: 12,
                            color: Colors.teal,
                            shadowColor: Colors.tealAccent,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 27,
                                  left: 0
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 0,
                                        left:0,
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                top: 0,
                                                left: 17,
                                                right: 17
                                            ),
                                            child: Icon(
                                              Icons.public_outlined,
                                              size: 32,
                                              color: Colors.tealAccent,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Ref: ${snapshot.data![index].code}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 21
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Name: ${snapshot.data![index].catName}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 21
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.zero,
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor: Colors.teal,
                                              mini: false,
                                              child: const Icon(
                                                Icons.update,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed: () {  },

                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 10,
                                              right: 10
                                            ),
                                            child: FloatingActionButton(
                                              heroTag: null,
                                              backgroundColor: Colors.red.shade900,
                                              mini: false,
                                              child: const Icon(
                                                Icons.delete,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed: () {  },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 500,
                          childAspectRatio: 4/1,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Card(
                elevation: 12,
                color: Colors.teal,
                child: _showForm
                ? SizedBox(
                  width: MediaQuery.of(context).size.width /2.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 40
                    ),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 0,
                              left: 0,
                              right: 0
                            ),
                            child: Text(
                              'Create new Category',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w300
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 34,
                                right: 24,
                                left: 24
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              validator: null,
                              onSaved: (String? val) {
                                category.code = val!;
                              },
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white
                              ),
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.tealAccent,
                              decoration: getInputDecoration(
                                  hint: 'Ref',
                                  hintStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300
                                  ),
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).colorScheme.error
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 34,
                                right: 24,
                                left: 24
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              validator: null,
                              onSaved: (String? val) {
                                category.catName = val!;
                              },
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white
                              ),
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.tealAccent,
                              decoration: getInputDecoration(
                                  hint: 'Nom category',
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300
                                  ),
                                  darkMode: isDarkMode(context),
                                  errorColor: Theme.of(context).colorScheme.error
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 27,
                                    right: 23,
                                    left: 0,
                                    bottom: 0
                                ),
                                child: FloatingActionButton.extended(
                                  heroTag: null,
                                  backgroundColor: Colors.teal,
                                  tooltip: 'Submit',
                                  elevation: 10,
                                  icon: const Icon(
                                    Icons.create,
                                    color: Colors.tealAccent,
                                  ),
                                  onPressed: () => {},
                                  label: const Text(
                                    'Submit',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0,
                                    right: 0,
                                    left: 23,
                                    bottom: 0
                                ),
                                child: FloatingActionButton.extended(
                                  heroTag: null,
                                  backgroundColor: Colors.red.shade900,
                                  tooltip: 'Cancel',
                                  elevation: 10,
                                  icon: const Icon(
                                    Icons.remove_circle,
                                    color: Colors.tealAccent,
                                  ),
                                  onPressed: () => {},
                                  label: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
                    : Container()
              )
            ],
          ),
        )
      ),
    );
  }
}