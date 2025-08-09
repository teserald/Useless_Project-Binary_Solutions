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

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

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
      home: BinaryReaderPage(
        onThemeToggle: toggleTheme,
        isDarkMode: isDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BinaryReaderPage extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const BinaryReaderPage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Binary Flow'),
        actions: [
          ThemeToggleButton(
            isDarkMode: isDarkMode,
            onThemeToggle: onThemeToggle,
          ),
        ],
      ),
      body: FilePickerSection(
        isDarkMode: isDarkMode,
        onThemeToggle: onThemeToggle,
      ),
    );
  }
}

class FilePickerSection extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const FilePickerSection({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<FilePickerSection> createState() => _FilePickerSectionState();
}

class _FilePickerSectionState extends State<FilePickerSection> {
  File? _pickedFile;
  String? _pickedFileName;
  double speakingRate = 1.0; // Default 1 word/bit per second

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      if (mounted) {
        setState(() {
          _pickedFile = File(result.files.single.path!);
          _pickedFileName = result.files.single.name;
        });
      }
    }
  }

  void analyzeFile() {
    if (_pickedFile != null && _pickedFileName != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FileProcessingScreen(
            file: _pickedFile!,
            fileName: _pickedFileName!,
            isDarkMode: widget.isDarkMode,
            onThemeToggle: widget.onThemeToggle,
            speakingRate: speakingRate,  // pass the rate here
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Pick a File",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          if (_pickedFileName != null) ...[
            const SizedBox(height: 12),
            Text(
              _pickedFileName!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
          if (_pickedFile != null) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: analyzeFile,
              icon: const Icon(Icons.analytics),
              label: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Analyze",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Slider with min, max, and "Normal" label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Slider(
                    min: 0.25,
                    max: 10.65,
                    divisions: 100,
                    value: speakingRate,
                    label: speakingRate.toStringAsFixed(2),
                    onChanged: (value) {
                      setState(() {
                        speakingRate = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("0.25"),
                      const Text("Normal"),
                      const Text("10.65"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class FileProcessingScreen extends StatefulWidget {
  final File file;
  final String fileName;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final double speakingRate; // new param

  const FileProcessingScreen({
    super.key,
    required this.file,
    required this.fileName,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.speakingRate,
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

    Future.microtask(() async {
      final delaySeconds = Random().nextInt(3) + 2; // 2–4 seconds
      await Future.delayed(Duration(seconds: delaySeconds));
      if (!mounted) return;

      int sizeInBytes = await widget.file.length();
      final totalBits = sizeInBytes * 8;

      // Adjust totalSeconds by speakingRate: 1 bit per second at default
      // So totalSeconds = totalBits / speakingRate
      final totalSeconds = (totalBits / widget.speakingRate).round();

      final durationText = formatDuration(totalSeconds);
      final finish = DateTime.now().add(Duration(seconds: totalSeconds));
      final finishDate =
          "${finish.day.toString().padLeft(2, '0')}-${finish.month.toString().padLeft(2, '0')}-${finish.year} "
          "${finish.hour.toString().padLeft(2, '0')}:${finish.minute.toString().padLeft(2, '0')}";

      if (mounted) {
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
      }
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
      appBar: AppBar(
        title: const Text('Binary Flow'),
        actions: [
          ThemeToggleButton(
            isDarkMode: widget.isDarkMode,
            onThemeToggle: widget.onThemeToggle,
          ),
        ],
      ),
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
        title: const Text('Binary Flow'),
        actions: [
          ThemeToggleButton(
            isDarkMode: isDarkMode,
            onThemeToggle: onThemeToggle,
          ),
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

class ThemeToggleButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const ThemeToggleButton({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onThemeToggle,
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white : Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
