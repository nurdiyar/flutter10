import 'package:flutter/material.dart';
import 'package:dio/dio';
import 'api.dart'; // Импортируйте ваш интерфейс RestClient

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bottom Bar',
      home: BottomBarPage(),
    );
  }
}

class BottomBarPage extends StatefulWidget {
  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Text('Это экран Home'),
    Text('Это экран Search'),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Bottom Bar'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RestClient restClient; // Убедитесь, что у вас есть доступ к RestClient

  _ProfileScreenState() {
    final dio = Dio();
    restClient = RestClient(dio);
  }

  String data = "";

  Future<void> fetchData() async {
    try {
      final response = await restClient.getTodo(); // Используйте метод из вашего интерфейса

      if (response.statusCode == 200) {
        setState(() {
          data = response.body.toString();
        });
      } else {
        setState(() {
          data = "Ошибка запроса";
        });
      }
    } catch (e) {
      setState(() {
        data = "Произошла ошибка: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Результат запроса:'),
            data is String
                ? Text(data)
                : Text('Неверный формат ответа'),
            ElevatedButton(
              onPressed: fetchData,
              child: Text('Запросить данные'),
            ),
          ],
        ),
      ),
    );
  }
}
