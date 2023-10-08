import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/home_screen.dart';

class GameScreen extends StatefulWidget {
  String player1;
  String player2;
  GameScreen({required this.player1, required this.player2});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> board;
  late String currentplayer;
  late String Winner;
  late bool GameOver;

  @override
  void initState() {
    super.initState();
    board = List.generate(3, (_) => List.generate(3, (_) => ""));
    currentplayer = "X";
    Winner = "";
    GameOver = false;
  }

// Reset Game
  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.generate(3, (_) => ""));
      currentplayer = "X";
      Winner = "";
      GameOver = false;
    });
  }

  void makeMove(int row, int col) {
    if (board[row][col] != "" || GameOver) {
      return;
    }

    setState(() {
      board[row][col] = currentplayer;

      //check for a Winner
      if (board[row][0] == currentplayer &&
          board[row][1] == currentplayer &&
          board[row][2] == currentplayer) {
        Winner = currentplayer;
        GameOver = true;
      } else if (board[0][col] == currentplayer &&
          board[1][col] == currentplayer &&
          board[2][col] == currentplayer) {
        Winner = currentplayer;
        GameOver = true;
      } else if (board[0][0] == currentplayer &&
          board[1][1] == currentplayer &&
          board[2][2] == currentplayer) {
        Winner = currentplayer;
        GameOver = true;
      } else if (board[0][2] == currentplayer &&
          board[1][1] == currentplayer &&
          board[2][0] == currentplayer) {
        Winner = currentplayer;
        GameOver = true;
      }

      //swicth players
      currentplayer = currentplayer == "X" ? "O" : "X";

      //check for a tie
      if (!board.any((row) => row.any((cell) => cell == ""))) {
        GameOver = true;
        Winner = "it's a tie";
      }
      if (Winner != "") {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          btnOkText: "Play Again",
          title: Winner == "X"
              ? widget.player1 + " won!"
              : Winner == "O"
                  ? widget.player2 + " won!"
                  : "it's a tie",
          btnOkOnPress: () {
            resetGame();
          },
        )..show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff323D5B),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            SizedBox(
              height: 120,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Turn: ",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        currentplayer == "X"
                            ? widget.player1 + " ($currentplayer)"
                            : widget.player2 + " ($currentplayer)",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: currentplayer == "X"
                              ? Color(0xffe25041)
                              : Color(0xff1CBD9E),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff5f6884),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(5),
              child: GridView.builder(
                itemCount: 9,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => makeMove(row, col),
                    child: Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color(0xff0e1e3a),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            color: board[row][col] == "X"
                                ? Color(0xffe25041)
                                : Color(0xff1cbd9e),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: resetGame,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      "Reset Game",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                    widget.player1 = "";
                    widget.player2 = "";
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    child: Text(
                      "Restart Game",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
