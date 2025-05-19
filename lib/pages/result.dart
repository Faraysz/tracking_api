import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;
  const Result({super.key, required this.place});

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  Future<Map<String, dynamic>> getdatafromAPI() async {
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&APPID=a79c60f626a4baab0cb0aed4d2828da0&units=metric",
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Gagal mengambil data dari API");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hasil Tracking Cuaca",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: getdatafromAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                  child: Text("Data tidak ada."));
            }

            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: NetworkImage('https://flagsapi.com/${data["sys"]["country"]}/flat/64.png')),

                    Text(
                      "Suhu: ${data["main"]["feels_like"]} °C",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kecepatan Angin: ${data["wind"]["speed"]} m/s',
                      style: const TextStyle(fontSize: 20),
                    ),
                    //rImage(image: NetworkImage('https://flagsapi.com/${data["sys"]["country"]}/flat/64.png'))
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Tempat tidak ditemukan"));
            }
          },
        ),
      ),
    );
  }
}
