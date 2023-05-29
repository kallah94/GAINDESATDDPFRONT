
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/services/admin/partner_services.dart';

import '../../../services/helper.dart';

class PartnerScreen extends StatefulWidget {
  const PartnerScreen({super.key});

  @override
  State createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {

  final GlobalKey<FormState> _key = GlobalKey();
  bool _showForm = false;
  Partner? newPartner = Partner.empty();
  late final Future<List<ReducePartner>> futurePartners;

  void _toggleFromShown() {
    setState(() {
      _showForm = !_showForm;
    });
  }

  @override
  void initState() {
    super.initState();
    futurePartners = PartnerService().fetchPartners();
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
              'Partner Management',
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
                      left: 0,
                      right: 0
                    ),
                    child: FloatingActionButton.extended(
                      heroTag: 'AddPartner',
                      backgroundColor: Colors.teal,
                      tooltip: 'Add New Partner',
                      elevation: 10,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.tealAccent,
                      ),
                      onPressed: _toggleFromShown,
                      label: const Text(
                        'Add Partner',
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
                child: FutureBuilder<List<ReducePartner>> (
                  future: futurePartners,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular((5))
                            ),
                            color: Colors.teal,
                            semanticContainer: true,
                            shadowColor: Colors.tealAccent,
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          top: 0,
                                          right: 0,
                                          left: 0
                                        ),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: AssetImage('assets/images/welcome_image.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ListTile(
                                          title: Stack(
                                            alignment: Alignment.topLeft,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  top: 0,
                                                  right: 90
                                                ),
                                                child: Text(
                                                    'Code: ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 21)
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 0,
                                                  left: 67
                                                ),
                                                child: Text(
                                                    snapshot.data![index].code!,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 21)
                                                ),
                                              )
                                            ],
                                          ),
                                          subtitle: Text(
                                            snapshot.data![index].name!,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 19)
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          title: const Icon(
                                              Icons.person_pin,
                                            color: Colors.tealAccent,
                                            size: 32,
                                            grade: 40,
                                          ),
                                          subtitle: Text(
                                            snapshot.data![index].userCount.toString(),
                                            style: const TextStyle(
                                              color: Colors.white
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 75,
                                          left: 0,
                                          right: 34
                                        ),
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
                                          top: 75,
                                          left: 34
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
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 600,
                          childAspectRatio: 3/1,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                        ),
                      );
                    } else {
                      return  Container();
                    }
                  },
                ),
              ),
              Card(
                elevation: 12,
                color: Colors.teal,
                shadowColor: Colors.blue,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              top: 40,
                              right: 16,
                              left: 16,
                              bottom: 12
                            ),
                            child: Text(
                              'Create New Partner',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 14,
                              right: 24,
                              left: 24
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              validator: null,
                              onSaved: (String? val) {
                                newPartner?.code = val!;
                              },
                              style: const TextStyle(
                                fontSize: 18.0
                              ),
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.tealAccent,
                              decoration: getInputDecoration(
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: Colors.tealAccent,
                                ),
                                hint: 'Code of the partner',
                                hintStyle: const TextStyle(
                                  color: Colors.white
                                ),
                                darkMode: isDarkMode(context),
                                errorColor: Theme.of(context).colorScheme.error
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 27,
                              right: 24,
                              left: 24
                            ),
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textInputAction: TextInputAction.next,
                              validator: validateUsername,
                              onSaved: (String? val) {
                                newPartner!.name = val!;
                              },
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white
                              ),
                              keyboardType: TextInputType.name,
                              cursorColor: const Color.fromRGBO(0, 132, 121, 100),
                              decoration: getInputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.tealAccent,
                                    size: 24,
                                  ),
                                  hint: 'Partner name',
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
                                    Icons.delete,
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
                : const Text(''),
              )
            ],
          ),
        ),
      ),
    );
  }
}