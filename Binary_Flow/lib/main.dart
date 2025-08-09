import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BinaryReaderApp());
}

class BinaryReaderApp extends StatefulWidget {
  const BinaryReaderApp({super.key});

  @override
  State<BinaryReaderApp> createState() => _BinaryReaderAppState();
}

class _BinaryReaderAppState extends State<BinaryReaderApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: SplashScreen(
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Startup splash screen
class SplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const SplashScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late String randomStatement;

  final List<String> statements = [
    "Crunching bits at light speed...",
    "Teaching electrons to dance...",
    "Counting to infinity… twice.",
    "Whispering to the binary gods...",
    "Making 1s and 0s feel special...",
    "Polishing your data streams...",
    "Inventing a new byte flavor...",
    "Brewing digital coffee...",
    "Convincing bits to behave...",
    "Sharpening the logic blades..."
  ];

  @override
  void initState() {
    super.initState();
    randomStatement = statements[Random().nextInt(statements.length)];
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BinaryReaderPage(
            onThemeToggle: widget.onThemeToggle,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.memory, size: 80),
            const SizedBox(height: 20),
            Text(
              randomStatement,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// Fake calculation loading screen
class FileProcessingScreen extends StatefulWidget {
  final File file;
  final String fileName;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const FileProcessingScreen({
    super.key,
    required this.file,
    required this.fileName,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<FileProcessingScreen> createState() => _FileProcessingScreenState();
}

class _FileProcessingScreenState extends State<FileProcessingScreen> {
  late String randomStatement;

  final List<String> calcStatements = [
    "Calculating with the binary gods...",
    "Translating zeroes into ones...",
    "Performing digital gymnastics...",
    "Summoning algorithmic magic...",
    "Measuring the speed of thought...",
    "Decoding ancient machine wisdom...",
    "Balancing bits on a wire...",
    "Aligning quantum byte particles...",
    "Negotiating with AI diplomats...",
    "Polishing your data's halo..."
  ];

  @override
  void initState() {
    super.initState();
    randomStatement = calcStatements[Random().nextInt(calcStatements.length)];

    final delaySeconds = Random().nextInt(3) + 2; // 2–4 seconds
    Future.delayed(Duration(seconds: delaySeconds), () async {
      int sizeInBytes = await widget.file.length();
      final totalBits = sizeInBytes * 8;
      final totalSeconds = totalBits;

      final durationText = formatDuration(totalSeconds);
      final finish = DateTime.now().add(Duration(seconds: totalSeconds));
      final finishDate =
          "${finish.day.toString().padLeft(2, '0')}-${finish.month.toString().padLeft(2, '0')}-${finish.year} "
          "${finish.hour.toString().padLeft(2, '0')}:${finish.minute.toString().padLeft(2, '0')}";

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            fileName: widget.fileName,
            fileSize: '${sizeInBytes.toString()} bytes',
            durationText: durationText,
            finishDate: finishDate,
            onThemeToggle: widget.onThemeToggle,
            isDarkMode: widget.isDarkMode,
          ),
        ),
      );
    });
  }

  String formatDuration(int totalSeconds) {
    int years = totalSeconds ~/ (365 * 24 * 3600);
    totalSeconds %= (365 * 24 * 3600);
    int months = totalSeconds ~/ (30 * 24 * 3600);
    totalSeconds %= (30 * 24 * 3600);
    int days = totalSeconds ~/ (24 * 3600);
    totalSeconds %= (24 * 3600);
    int hours = totalSeconds ~/ 3600;
    totalSeconds %= 3600;
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;

    return "${years}y ${months}m ${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              randomStatement,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

// Main file picking screen
class BinaryReaderPage extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const BinaryReaderPage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  void pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FileProcessingScreen(
            file: file,
            fileName: result.files.single.name,
            isDarkMode: isDarkMode,
            onThemeToggle: onThemeToggle,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binary Reading Time'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
          )
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => pickFile(context),
          icon: const Icon(Icons.upload_file),
          label: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Pick a File",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

// Results screen after fake loading
class ResultScreen extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final String durationText;
  final String finishDate;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const ResultScreen({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.durationText,
    required this.finishDate,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binary Reading Time'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: onThemeToggle,
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("File Name: $fileName"),
              Text("File Size: $fileSize"),
              const SizedBox(height: 20),
              Text(
                "Duration Needed: $durationText",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text("Finish Date: $finishDate"),
            ],
          ),
        ),
      ),
    );
  }
}
