import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JogoVelha extends StatefulWidget {
  const JogoVelha({super.key});

  @override
  State<JogoVelha> createState() => _JogoVelhaState();
}

class _JogoVelhaState extends State<JogoVelha> {
  static const String PLAYER_1 = "X";
  static const String PLAYER_2 = "O";

  late String jogando;
  late bool fimDeJogo;
  late List<String> ocupado;

  @override
  void initState() {
    iniciarJogo();
    super.initState();
  }

  void iniciarJogo() {
    jogando = PLAYER_1;
    fimDeJogo = false;
    ocupado = ["", "", "", "", "", "", "", "", ""];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headerText(),
              _gridDoJogo(),
              _reiniciarJogo(),
            ],
          ),
        )
    );
  }

  Widget _headerText() {
    return Column(
      children: [
        const Text ('Jogo da velha', style: TextStyle(
          color: Colors.deepPurple,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),),
        Text("$jogando está jogando ", style: TextStyle(
          color: Colors.purple,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),),
      ],
    );
  }

  Widget _gridDoJogo() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: 9,
          itemBuilder: (context, int index) {
            return _grid(index);
          }),
    );
  }
  Widget _grid(int index){
    return InkWell(
      onTap: (){
        if(fimDeJogo || ocupado[index].isNotEmpty){
          return;
        }
        setState(() {
          ocupado[index] = jogando;
          mudarVez();
          checarVitoria();
          checarEmpate();
          //função para a Ia fazer a jogada
          //retornar a posição no index
        });

      },
      child: Container(
        color: Colors.blue,
        margin: const EdgeInsets.all(8),
        child: Center(
          child : Text(
          ocupado[index],
          style: const TextStyle(fontSize: 50),
        ),
    ),
    ),
    );
  }
  _reiniciarJogo(){
    return ElevatedButton(onPressed: (){
      setState(() {
        iniciarJogo();
      });
    }
        , child: Text('Jogar de novo'));
  }
  mudarVez(){
    if (jogando == PLAYER_1){
      jogando = PLAYER_2;
    }else{
      jogando = PLAYER_1;
    }
  }
  checarVitoria(){
    List<List<int>> listaDeVitoria = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (var vitoriaPosicao in listaDeVitoria){
      String posicaoJogador0 = ocupado[vitoriaPosicao[0]];
      String posicaoJogador1 = ocupado[vitoriaPosicao[1]];
      String posicaoJogador2 = ocupado[vitoriaPosicao[2]];

      if(posicaoJogador0.isNotEmpty){
        if(posicaoJogador0 == posicaoJogador1 && posicaoJogador0 == posicaoJogador2){
          showMensagemDeFimDeJogo("Player $posicaoJogador0 ganhou" );
          fimDeJogo = true;
          return;
        }
      }
    }
  }
  checarEmpate(){
    if(fimDeJogo){
      return;
    }
    bool draw = true;
    for(var espacoOcupado in ocupado){
      if(espacoOcupado.isEmpty){
        draw = false;
      }
    }
    if(draw){
      showMensagemDeFimDeJogo("Empate");
      fimDeJogo = true;
    }
  }
  showMensagemDeFimDeJogo(String mensagem){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
          content: Text(
              "Fim de jogo \n $mensagem",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
          )),
    );
  }
}
