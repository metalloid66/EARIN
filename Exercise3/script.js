let orgBoard;
const huPlayer = "O";
const aiPlayer = "X";
const winCombos = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [6, 4, 2],
];

const cells = document.querySelectorAll(".cell");
startGame();

function startGame() {
  document.querySelector(".endgame").style.display = "none";
  orgBoard = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  for (let i = 0; i < cells.length; i++) {
    cells[i].innerText = "";
    cells[i].style.removeProperty("background-color");
    cells[i].addEventListener("click", turnClick, false);
  }
}

function turnClick(square) {
  if (typeof orgBoard[square.target.id] == "number") {
    turn(square.target.id, huPlayer);
    if (!checkWin(orgBoard, huPlayer) && !checkTie()) {
      turn(bestSpot(), aiPlayer);
    }
  }
}

function turn(squareId, player) {
  orgBoard[squareId] = player;
  document.getElementById(squareId).innerText = player;
  let gameWon = checkWin(orgBoard, player);
  if (gameWon) {
    gameOver(gameWon);
  }
}

function checkWin(board, player) {
  let gameWon = null;
  let plays = board.reduce(
    (a, element, index) => (element === player ? a.concat(index) : a),
    []
  );

  for (let [index, win] of winCombos.entries()) {
    // if every element of plays === every element of
    // one of the winning conditions, then the game is won
    if (win.every((elem) => plays.indexOf(elem) > -1)) {
      gameWon = { index: index, player: player };
      break;
    }
  }
  return gameWon;
}

function gameOver(gameWon) {
  for (let index of winCombos[gameWon.index]) {
    document.getElementById(index).style.backgroundColor =
      gameWon.player == huPlayer ? "blue" : "red";
  }
  for (var i = 0; i < cells.length; i++) {
    cells[i].removeEventListener("click", turnClick, false);
  }

  declareWinner(gameWon.player == huPlayer ? "You win!" : "A.I wins!");
}

function declareWinner(who) {
  document.querySelector(".endgame").style.display = "block";
  document.querySelector(".endgame .text").innerText = who;
}

function emptySquares() {
  // if the square still still contains a 'number' instead if an 'X' or 'O'
  // then it is indeed empty.
  return orgBoard.filter((s) => typeof s == "number");
}

function bestSpot() {
  return minimax(orgBoard, -Infinity, Infinity, aiPlayer).index;
}

function checkTie() {
  if (emptySquares().length === 0) {
    for (let i = 0; i < cells.length; i++) {
      cells[i].style.backgroundColor = "green";
      cells[i].removeEventListener("click", turnClick, false);
    }
    declareWinner("Tie game");
    return true;
  }
  return false;
}

function minimax(newBoard, alpha, beta, player) {
  var availSpots = emptySquares();
  // Check for terminal state
  if (checkWin(newBoard, player)) {
    return { score: -10 };
  } else if (checkWin(newBoard, aiPlayer)) {
    return { score: 10 };
  } else if (availSpots.length === 0) {
    return { score: 0 };
  }

  let moves = [];
  for (let i = 0; i < availSpots.length; i++) {
    let move = {};
    move.index = newBoard[availSpots[i]];
    newBoard[availSpots[i]] = player;

    if (player == aiPlayer) {
      let result = minimax(newBoard, alpha, beta, huPlayer);
      move.score = result.score;
    } else {
      let result = minimax(newBoard, alpha, beta, aiPlayer);
      move.score = result.score;
    }
    newBoard[availSpots[i]] = move.index;

    moves.push(move);
  }

  let bestMove, bestScore;

  if (player === aiPlayer) {
    // Choose move with highest score when A.I is playing
    bestScore = -Infinity;
    for (let i = 0; i < moves.length; i++) {
      if (moves[i].score > bestScore) {
        bestScore = moves[i].score;
        bestMove = i;
        alpha = Math.max(bestScore, alpha);
        if (beta <= alpha) {
          break;
        }
      }
    }
    // const max = Math.max(...moves.map((el) => el.score));
    // bestMove = moves.findIndex(max);
  } else {
    // Choose move with the lowest score when Human is playing
    bestScore = Infinity;
    for (let i = 0; i < moves.length; i++) {
      if (moves[i].score < bestScore) {
        bestScore = moves[i].score;
        bestMove = i;
        beta = Math.min(bestScore, beta);
        if (beta <= alpha) {
          break;
        }
      }
    }
  }
  // const mini = Math.min(...moves.map((el) => el.score), -Infinity);
  // bestMove = moves.findIndex(mini);

  return moves[bestMove];
}
