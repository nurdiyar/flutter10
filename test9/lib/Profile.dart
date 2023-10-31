import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/http.dart';

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

// Создайте интерфейс API с использованием Retrofit
@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/todos/1")
  Future<Map<String, dynamic>> getTodo();
}

// Этот класс автоматически сгенерируется Retrofit
@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/todos/1")
  Future<Map<String, dynamic>> getTodo();
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  RestClient restClient;

  _ProfileScreenState() {
    final dio = Dio(); // Создайте экземпляр Dio
    restClient = RestClient(dio);
  }

  dynamic data;

  Future<void> fetchData() async {
    try {
      final response = await restClient.getTodo(); // Используйте Retrofit для выполнения запроса

      if (response != null) {
        setState(() {
          data = response;
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
                : data is Map<String, dynamic>
                    ? Text(data.toString())
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
