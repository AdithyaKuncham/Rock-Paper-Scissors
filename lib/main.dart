import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

// Enum to represent the choices
enum Choice { rock, paper, scissors }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock Paper Scissors',
      // Define light and dark themes
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const RockPaperScissorsScreen(),
    );
  }
}

class RockPaperScissorsScreen extends StatefulWidget {
  const RockPaperScissorsScreen({super.key});

  @override
  State<RockPaperScissorsScreen> createState() =>
      _RockPaperScissorsScreenState();
}

class _RockPaperScissorsScreenState extends State<RockPaperScissorsScreen> {
  // --- Game State Variables ---

  /// Tracks the user's and computer's scores.
  Map<String, int> _scores = {'user': 0, 'computer': 0};

  /// The user's last choice. Null if game hasn't started.
  Choice? _userChoice;

  /// The computer's last choice. Null if game hasn't started.
  Choice? _computerChoice;

  /// The result message of the last round.
  String _resultMessage = 'Choose your weapon!';

  // --- Game Logic Methods ---

  /// Handles the user tapping one of the choices.
  void _playGame(Choice userPick) {
    setState(() {
      _userChoice = userPick;
      _computerChoice = _generateComputerChoice();
      _determineWinner();
    });
  }

  /// Generates a random choice for the computer.
  Choice _generateComputerChoice() {
    // Get a random index from 0 to 2
    int randomIndex = Random().nextInt(3);
    // Return the Choice enum value at that index
    return Choice.values[randomIndex];
  }

  /// Compares user and computer choices to determine the winner.
  void _determineWinner() {
    if (_userChoice == _computerChoice) {
      _resultMessage = "It's a Draw!";
      return;
    }

    switch (_userChoice) {
      case Choice.rock:
        if (_computerChoice == Choice.scissors) {
          _resultMessage = "You Win! Rock smashes Scissors.";
          _scores['user'] = _scores['user']! + 1;
        } else {
          _resultMessage = "You Lose! Paper covers Rock.";
          _scores['computer'] = _scores['computer']! + 1;
        }
        break;
      case Choice.paper:
        if (_computerChoice == Choice.rock) {
          _resultMessage = "You Win! Paper covers Rock.";
          _scores['user'] = _scores['user']! + 1;
        } else {
          _resultMessage = "You Lose! Scissors cut Paper.";
          _scores['computer'] = _scores['computer']! + 1;
        }
        break;
      case Choice.scissors:
        if (_computerChoice == Choice.paper) {
          _resultMessage = "You Win! Scissors cut Paper.";
          _scores['user'] = _scores['user']! + 1;
        } else {
          _resultMessage = "You Lose! Rock smashes Scissors.";
          _scores['computer'] = _scores['computer']! + 1;
        }
        break;
      default:
        _resultMessage = 'Choose your weapon!';
    }
  }

  /// Resets the game scores and messages.
  void _resetGame() {
    setState(() {
      _scores = {'user': 0, 'computer': 0};
      _userChoice = null;
      _computerChoice = null;
      _resultMessage = 'Choose your weapon!';
    });
  }

  // --- UI Build Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rock Paper Scissors'),
        actions: [
          // Reset button in the app bar
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: 'Restart Game',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Score Board
              _buildScoreBoard(),
              const SizedBox(height: 30),

              // 2. Choices Display (User vs Computer)
              _buildChoicesDisplay(),
              const SizedBox(height: 30),

              // 3. Result Message
              Text(
                _resultMessage,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 4. Player Controls (Buttons)
              Text("Your Turn:", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              _buildPlayerControls(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the score board widget.
  Widget _buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCounter("Player", _scores['user']!),
        _buildScoreCounter("Computer", _scores['computer']!),
      ],
    );
  }

  /// Builds a single score counter.
  Widget _buildScoreCounter(String label, int score) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 5),
        Text(
          score.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }

  /// Builds the widget showing the user's and computer's choices.
  Widget _buildChoicesDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildChoiceIcon(_userChoice, "You"),
        Text("VS", style: Theme.of(context).textTheme.headlineSmall),
        _buildChoiceIcon(_computerChoice, "Comp"),
      ],
    );
  }

  /// Builds the 3 buttons for the user to make a choice.
  Widget _buildPlayerControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildChoiceButton(Choice.rock),
        _buildChoiceButton(Choice.paper),
        _buildChoiceButton(Choice.scissors),
      ],
    );
  }

  /// Helper to build a single choice button (Rock, Paper, or Scissors).
  Widget _buildChoiceButton(Choice choice) {
    return ElevatedButton(
      onPressed: () => _playGame(choice),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: Icon(_getIconForChoice(choice), size: 32),
    );
  }

  /// Helper to build the display icon for a choice.
  Widget _buildChoiceIcon(Choice? choice, String label) {
    // Use a placeholder if no choice has been made
    IconData icon = (choice == null)
        ? Icons.question_mark_rounded
        : _getIconForChoice(choice);

    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        CircleAvatar(radius: 40, child: Icon(icon, size: 40)),
      ],
    );
  }

  /// Helper to get the correct icon for a given choice.
  IconData _getIconForChoice(Choice choice) {
    switch (choice) {
      case Choice.rock:
        return Icons.filter_hdr_rounded; // Represents a rock/mountain
      case Choice.paper:
        return Icons.back_hand_rounded; // Represents an open hand
      case Choice.scissors:
        return Icons.content_cut_rounded; // Represents scissors
    }
  }
}
