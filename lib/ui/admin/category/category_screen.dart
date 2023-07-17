import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaindesat_ddp_client/models/category_model.dart';
import 'package:gaindesat_ddp_client/services/admin/category_services.dart';
import 'package:gaindesat_ddp_client/ui/admin/category/category_bloc.dart';
import 'package:gaindesat_ddp_client/ui/loading_cubit.dart';

import '../../../services/helper.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  AutovalidateMode _validate = AutovalidateMode.disabled;
  final GlobalKey<FormState> _key = GlobalKey();
  String? code, catName, deleteCategoryUUID;
  bool _showForm = false;
  late final Future<List<ReduceCategory>> futureCategories;
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
    return BlocProvider<CategoryBloc>(
      create: (context) => CategoryBloc(),
      child: Builder(builder: (context) {
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
          body: MultiBlocListener(
            listeners: [
              BlocListener<CategoryBloc, CategoryManagementState>(
                  listener: (context, state) async {
                    await context.read<LoadingCubit>().hideLoading();
                    if ((state.categoryState == CategoryState.addSuccess)
                    || (state.categoryState == CategoryState.deleteSuccess)
                    || (state.categoryState == CategoryState.updateSuccess)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const CategoryScreen()));
                      showSnackBarSuccess(context, state.message!);
                    } else if ((state.categoryState == CategoryState.addError)
                    || (state.categoryState == CategoryState.deleteError)
                    || (state.categoryState == CategoryState.updateError)) {
                      if (!mounted) return;
                      Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => const CategoryScreen()));
                      showSnackBar(context, state.message!);
                    }
                  }
              ),
              BlocListener<CategoryBloc, CategoryManagementState>(
                  listener: (context, state) async {
                    if (state.categoryState == CategoryState.deleteInit) {
                      await context.read<LoadingCubit>().showLoading(context, "Deleting Category of user. Please wait !!", false);
                      if (!mounted) return;
                      context.read<CategoryBloc>().add(
                        CategoryDeleteEvent(categoryUUID: deleteCategoryUUID!)
                      );
                    }
                  }
              ),
              BlocListener<CategoryBloc, CategoryManagementState>(
                listener: (context, state) async {
                  if (state.categoryState == CategoryState.validCategoryFields) {
                    await context.read<LoadingCubit>().showLoading(context, "Adding category. Please Wait !!", false);
                    if (!mounted) return;
                    context.read<CategoryBloc>().add(
                      CategoryAddEvent(category: CategoryModel(code: code!, catName: catName!))
                    );
                  }
                }
              )
            ],
            child: Padding(
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
                            left: 0,
                            right: 0
                          ),
                          child: FloatingActionButton.extended(
                            heroTag: "AddCategory",
                              backgroundColor: Colors.teal,
                              tooltip: "Add new Category",
                              elevation: 10,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.tealAccent,
                              ),
                              onPressed: _toggleFormShow,
                              label: const Text(
                                "Add Category",
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
                                   child: Stack(
                                     alignment: Alignment.topLeft,
                                     children: [
                                       Padding(
                                         padding: EdgeInsets.zero,
                                         child:Row(
                                           mainAxisSize: MainAxisSize.min,
                                           mainAxisAlignment: MainAxisAlignment.start,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             const Padding(
                                               padding: EdgeInsets.only(
                                                   top: 15,
                                                   left: 7,
                                                   right: 7
                                               ),
                                               child: Icon(
                                                 Icons.public_outlined,
                                                 size: 32,
                                                 color: Colors.tealAccent,
                                               ),
                                             ),
                                             Padding(
                                               padding: const EdgeInsets.only(
                                                   top: 17,
                                                   left: 7,
                                                   right: 7
                                               ),
                                               child: Text(
                                                 'Ref: ${snapshot.data![index].code}',
                                                 style: const TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.w300,
                                                     fontSize: 21
                                                 ),
                                               ),
                                             ),
                                             Padding(
                                               padding: const EdgeInsets.only(
                                                   top: 17,
                                                   left: 27,
                                                   right: 7
                                               ),
                                               child: Text(
                                                 'Name: ${snapshot.data![index].catName}',
                                                 style: const TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.w300,
                                                     fontSize: 21
                                                 ),
                                               ),
                                             )
                                           ],
                                         ),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(
                                           top: 70
                                         ),
                                         child: Row(
                                           mainAxisSize: MainAxisSize.min,
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.end,
                                           children: [
                                             Padding(
                                               padding: const EdgeInsets.only(
                                                 left: 10
                                               ),
                                               child: FloatingActionButton(
                                                 heroTag: null,
                                                 backgroundColor: Colors.teal,
                                                 mini: false,
                                                 child: const Icon(
                                                   Icons.update,
                                                   color: Colors.tealAccent,
                                                 ),
                                                 onPressed: () {},
                                               ),
                                             ),
                                             Padding(
                                               padding: const EdgeInsets.only(
                                                 left: 10,
                                               ),
                                               child: FloatingActionButton(
                                                 heroTag: null,
                                                 backgroundColor: Colors.red.shade900,
                                                 mini: false,
                                                 child: const Icon(
                                                   Icons.delete,
                                                   color: Colors.tealAccent,
                                                 ),
                                                 onPressed: () => {
                                                   deleteCategoryUUID = snapshot.data![index].uuid,
                                                   showAlertDialog(context)
                                                 },
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ],
                                   ),
                                  ),
                                );
                              },
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 600,
                                childAspectRatio: 3/1,
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
                    BlocBuilder<CategoryBloc, CategoryManagementState>(
                      buildWhen: (old, current) =>
                      current.categoryState is CategoryManagementState && old != current,
                      builder: (context, state) {
                        if (state.categoryState == CategoryState.failureFillCategoryFields) {
                          _validate = AutovalidateMode.onUserInteraction;
                        }
                        return Card(
                          elevation: 12,
                          color: Colors.teal,
                          child: _showForm ?
                          SizedBox(
                            width: MediaQuery.of(context).size.width /2.5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 46
                              ),
                              child: Form(
                                key: _key,
                                autovalidateMode: _validate,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.zero,
                                      child: Text(
                                        'Create new Category',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold
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
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          code = val!;
                                        },
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white
                                        ),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key_rounded,
                                            color: Colors.tealAccent,
                                          ),
                                          hint: "Code for the new category",
                                          hintStyle: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          darkMode: isDarkMode(context),
                                          errorColor: Theme.of(context).colorScheme.error
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 27,
                                        right: 24,
                                        left: 24
                                      ),
                                      child: TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        textInputAction: TextInputAction.done,
                                        validator: validateCommonField,
                                        onSaved: (String? val) {
                                          catName = val!;
                                        },
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white
                                        ),
                                        onFieldSubmitted: (catName) => context.read<CategoryBloc>()
                                        .add(ValidateCategoryFieldsEvent(_key)),
                                        keyboardType: TextInputType.name,
                                        cursorColor: Colors.tealAccent,
                                        decoration: getInputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.key_rounded,
                                            color: Colors.tealAccent,
                                          ),
                                          hint: 'Category Name',
                                          hintStyle: const TextStyle(
                                            color: Colors.white
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
                                            onPressed: () => context
                                                .read<CategoryBloc>()
                                                .add(ValidateCategoryFieldsEvent(_key)),
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
                                              tooltip: "Cancel",
                                              elevation: 10,
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.tealAccent,
                                              ),
                                              onPressed: () => {
                                                _key.currentState?.reset(),
                                                _toggleFormShow()
                                              },
                                              label: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.white
                                                ),
                                              ),
                                            )

                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ) : const Text('')
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget deleteButton = FloatingActionButton.extended(
    onPressed: () =>
    {context.read<CategoryBloc>()
        .add(CategoryDeleteInitEvent()),
      Navigator.of(context).pop()
    },
    icon: const Icon(
      Icons.done_all_outlined,
      color: Colors.tealAccent,
    ),
    label: const Text(
      'Delete',
      style: TextStyle(
          color: Colors.tealAccent
      ),
    ),
    backgroundColor: Colors.teal,
  );

  Widget cancelButton = FloatingActionButton.extended(
    onPressed: () => Navigator.of(context).pop(),
    icon: const Icon(
      Icons.clear,
      color: Colors.tealAccent,
    ),
    label: const Text(
      'Cancel',
      style: TextStyle(
          color: Colors.tealAccent
      ),
    ),
    backgroundColor: Colors.red.shade900,
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.teal,
    alignment: Alignment.center,
    title: const Text('Confirmation Dialog'),
    titleTextStyle: const TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: 23
    ),
    content: const Text(
      "Delete Category ?",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.w300
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      deleteButton,
      cancelButton
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    }
  );
}