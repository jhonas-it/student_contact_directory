import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Student Contact Directory",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFAB76FA),
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0E0E17),
        cardColor: const Color(0xFF191828),
      ),

      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  List<Map<String, String>> contacts = [];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final programController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    programController.dispose();
    super.dispose();
  }

  void changePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void addContact() {
    if (nameController.text.isEmpty) {
      showMessage("Please enter the student's name.");
      return;
    }

    if (emailController.text.isEmpty || !emailController.text.contains("@")) {
      showMessage("Please enter a valid email address.");
      return;
    }

    if (contactController.text.isEmpty ||
        !RegExp(r'^[0-9]+$').hasMatch(contactController.text)) {
      showMessage("Contact number must be numbers only.");
      return;
    }

    if (programController.text.isEmpty) {
      showMessage("Please enter a program.");
      return;
    }

    setState(() {
      contacts.add({
        "name": nameController.text,
        "email": emailController.text,
        "contact": contactController.text,
        "program": programController.text,
      });
    });

    nameController.clear();
    emailController.clear();
    contactController.clear();
    programController.clear();

    showMessage("Contact added successfully!");
    changePage(1);
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
    showMessage("Contact deleted.");
  }

  void confirmDeleteContact(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Contact"),
          content: Text("Delete ${contacts[index]["name"]} from the list?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteContact(index);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void confirmClearAll() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear All Contacts"),
          content: const Text("This will remove all saved contacts. Continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  contacts.clear();
                });
                Navigator.pop(context);
                showMessage("All contacts cleared.");
              },
              child: const Text("Clear All"),
            ),
          ],
        );
      },
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AddContactScreen(
        nameController: nameController,
        emailController: emailController,
        contactController: contactController,
        programController: programController,
        onAddContact: addContact,
      ),
      ContactListScreen(
        contacts: contacts,
        onDelete: confirmDeleteContact,
      ),
      const InformationScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF9658F0),
        title: const Text(
          "Student Contact Directory",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF9658F0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.contacts, size: 34, color: Color(0xFFAB76FA)),
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Student Contact Directory",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "Developed by: Jhonas Caraan",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person_add, color: Color(0xFFAB76FA)),
              title: const Text("Add Contact"),
              onTap: () {
                Navigator.pop(context);
                changePage(0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.contacts, color: Color(0xFFAB76FA)),
              title: const Text("View Contacts"),
              onTap: () {
                Navigator.pop(context);
                changePage(1);
              },
            ),

            ListTile(
              leading: const Icon(Icons.delete_forever, color: Color(0xFFAB76FA)),
              title: const Text("Clear All Contacts"),
              onTap: () {
                Navigator.pop(context);
                confirmClearAll();
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFFAB76FA)),
              title: const Text("About"),
              onTap: () {
                Navigator.pop(context);
                changePage(2);
              },
            ),
          ],
        ),
      ),

      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFFAB76FA),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          changePage(index);
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "Add Contact"),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: "Contact List"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Information"),
        ],
      ),
    );
  }
}

class AddContactScreen extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController contactController;
  final TextEditingController programController;
  final VoidCallback onAddContact;

  const AddContactScreen({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.contactController,
    required this.programController,
    required this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF191828),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFAB76FA),
                  child: Icon(Icons.person_add, color: Colors.white, size: 40),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Add New Contact",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person, color: Color(0xFFAB76FA)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFAB76FA)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Contact Number",
                    prefixIcon: const Icon(Icons.phone, color: Color(0xFFAB76FA)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                TextField(
                  controller: programController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Program",
                    prefixIcon: const Icon(Icons.school, color: Color(0xFFAB76FA)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAddContact,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Contact"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAB76FA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContactListScreen extends StatelessWidget {
  final List<Map<String, String>> contacts;
  final void Function(int index) onDelete;

  const ContactListScreen({
    super.key,
    required this.contacts,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.contacts, size: 60, color: Color(0xFF9E9E9E)),
            SizedBox(height: 12),
            Text(
              "No contacts have been added.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFAB76FA),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              contact["name"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact["email"] ?? ""),
                  Text(contact["contact"] ?? ""),
                  Text(contact["program"] ?? ""),
                ],
              ),
            ),
            isThreeLine: true,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => onDelete(index),
            ),
          ),
        );
      },
    );
  }
}

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF191828),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFAB76FA),
                  child: Icon(Icons.contacts, color: Colors.white, size: 40),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Student Contact Directory",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "A Flutter app for managing student contacts",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFA3A2B0), fontSize: 15),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Chip(
                      backgroundColor: const Color(0xFF392755),
                      avatar: const Icon(
                        Icons.tag,
                        size: 18,
                        color: Color(0xFFAB76FA),
                      ),
                      label: const Text("Version 1.0.0"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About This App",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const ListTile(
                  leading: Icon(Icons.person_add, color: Color(0xFFAB76FA)),
                  title: Text("Add Contact"),
                  subtitle: Text("Save a student's name, email, number, and program"),
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                const ListTile(
                  leading: Icon(Icons.contacts, color: Color(0xFFAB76FA)),
                  title: Text("Contact List"),
                  subtitle: Text("View and delete saved contacts"),
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                const ListTile(
                  leading: Icon(Icons.delete_forever, color: Color(0xFFAB76FA)),
                  title: Text("Clear All"),
                  subtitle: Text("Remove every saved contact at once"),
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Widgets Used",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Chip(
                      avatar: const Icon(
                        Icons.text_fields,
                        color: Colors.deepPurpleAccent,
                        size: 18,
                      ),
                      label: const Text("TextField"),
                      backgroundColor: const Color(0xFF392755),
                    ),

                    Chip(
                      avatar: const Icon(
                        Icons.list,
                        color: Colors.cyan,
                        size: 18,
                      ),
                      label: const Text("ListView.builder"),
                      backgroundColor: const Color(0xFF1E3556),
                    ),

                    Chip(
                      avatar: const Icon(
                        Icons.menu,
                        color: Colors.greenAccent,
                        size: 18,
                      ),
                      label: const Text("Drawer"),
                      backgroundColor: const Color(0xFF14463D),
                    ),

                    Chip(
                      avatar: const Icon(
                        Icons.dashboard,
                        color: Colors.orange,
                        size: 18,
                      ),
                      label: const Text("BottomNavigationBar"),
                      backgroundColor: const Color(0xFF4A3B22),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const ListTile(
              leading: Icon(Icons.person, color: Color(0xFFAB76FA)),
              title: Text("Developer"),
              subtitle: Text("Jhonas Allen F. Caraan, BSIT 3G-G1"),
              isThreeLine: true,
            ),
          ),
        ],
      ),
    );
  }
}