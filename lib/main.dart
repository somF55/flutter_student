import 'package:flutter/material.dart';

void main() {
  runApp(StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // يتم التحقق من صحة اسم المستخدم وكلمة المرور هنا وتسجيل الدخول
                // إذا نجحت عملية تسجيل الدخول ، يتم نقل المستخدم إلى الشاشة الرئيسية
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Student> students = []; // قائمة الطلاب

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Management'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          Student student = students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.grade),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // يتم نقل المستخدم إلى شاشة تعديل بيانات الطالب عند الضغط على الزر
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStudentScreen(student: student),
                      ),
                    ).then((updatedStudent) {
                      // يتم استقبال الطالب المحدث بعد تعديله وتحديث قائمة الطلاب
                      if (updatedStudent != null) {
                        setState(() {
                          students[index] = updatedStudent;
                        });
                      }
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // يتم حذف الطالب عند الضغط على الزر
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmation'),
                         content: Text('Are you sure you want to delete this student?'),
                         actions: [
                           TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),

                          TextButton(
                              onPressed: () {
                              // يتم حذف الطالب وإغلاق الحوار وتحديث قائمة الطلاب
                              setState(() {
                                students.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                          
                         ],
                      ),
                       
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
  
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // يتم نقل المستخدم إلى شاشة إضافة طالب جديد عند الضغط على الزر
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentScreen(),
            ),
          ).then((newStudent) {
            // يتم استقبال الطالب الجديد بعد إضافته وتحديث قائمة الطلاب
            if (newStudent != null) {
              setState(() {
                students.add(newStudent);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(
                labelText: 'Grade',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // يتم إنشاء طالب جديد وإغلاق الشاشة وإرجاعه إلى الشاشة الرئيسية
                Student newStudent = Student(
                  name: _nameController.text,
                  grade: _gradeController.text,
                );
                Navigator.pop(context, newStudent);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditStudentScreen extends StatefulWidget {
  final Student student;

  EditStudentScreen({required this.student});

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  late TextEditingController _nameController;
  late TextEditingController _gradeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _gradeController = TextEditingController(text: widget.student.grade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(
                labelText: 'Grade',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // يتم تحديث بيانات الطالب وإغلاق الشاشة وإرجاعها إلى الشاشة الرئيسية
            
                 Student updatedStudent = Student(
                  name: _nameController.text,
                  grade: _gradeController.text,
                );
                Navigator.pop(context, updatedStudent);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class Student {
  final String name;
  final String grade;

  Student({required this.name, required this.grade});
}