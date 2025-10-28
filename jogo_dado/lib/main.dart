// Importa a Biblioteca para trabralhar com numeros aleatorios (para o dado)
import 'dart:math';
// importa a Biblioteca principal do Flutter
import 'package:flutter/material.dart';

// 1. Estrutura Base do APP
// A função Principal que inicia o app

void main() => runApp(const AplicativoJogodeDados());

// Raiz (base) do app Definir o tema e o fluxo inical
class AplicativoJogodeDados extends StatelessWidget {
  const AplicativoJogodeDados({super.key});

  @override
  Widget build(BuildContext context) {
    // Fazer um return do materialApp, que da o visual ao projeto
    return MaterialApp(
      title: 'Jogo de Dados', //Titulo que aparece no gerenciador de tarefas
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaConfiguracaoJogadores(),
      themeMode: ThemeMode.dark,
    );
  }
}

// 2. Tela de configuração de jogadores
// Primeira tela do app, coletar nome dos jogadores
class TelaConfiguracaoJogadores extends StatefulWidget {
  const TelaConfiguracaoJogadores({super.key});
  @override
  //Cria o Objeto de estado que vai gerencia o formulado do jogador
  State<TelaConfiguracaoJogadores> createState() =>
      _EstadoTelaConfiguracaoJogadores();
}

class _EstadoTelaConfiguracaoJogadores
    extends State<TelaConfiguracaoJogadores> {
  // Chave global para indentificar e validar o Widget
  // Final é uma palavra chave do dart para cria ua variavel que só recebe valor uma vez
  // form state é o estado do formulario, é a parte que sabe gigitado e consegue validar os campos
  final _chaveFormulario = GlobalKey<FormState>();
  // Controladores para capturar o texto digitado nos campos
  final TextEditingController _controladorJogador1 = TextEditingController();
  final TextEditingController _controladorJogador2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuração dos Jogadores')),
      body: Padding(
        padding: const EdgeInsets.all(16.0), //Espaçamento interno
        child: Form(
          key: _chaveFormulario, //Associando a chave global key ao formulario
          child: Column(
            children: [
              // Campo de texto para o jogador 1
              TextFormField(
                controller:
                    _controladorJogador1, //Associando o controlador ao campo
                decoration: const InputDecoration(
                  labelText: 'Nome do Jogador 1',
                ),
                validator: (valor) => valor!.isEmpty
                    ? 'Por favor, insira o nome do Jogador 1'
                    : null, //Validação do campo condição ? valor se verdadeiro : valor se falso
              ),
              const SizedBox(height: 16.0), //Espaçamento entre os campos
              // Campo de texto para o jogador 2
              TextFormField(
                controller:
                    _controladorJogador2, //Associando o controlador ao campo
                decoration: const InputDecoration(
                  labelText: 'Nome do Jogador 2',
                ),
                validator: (valor) => valor!.isEmpty
                    ? 'Por favor, insira o nome do Jogador 2'
                    : null, //Validação do campo condição ? valor se verdadeiro : valor se falso
              ),
              const Spacer(), //Ocupa o espaço vertical disponível empurrando botão para baixo
              // Botão para iniciar o jogo
              ElevatedButton(
                onPressed: () {
                  // checa se o formulário é válido
                  if (_chaveFormulario.currentState!.validate()) {
                    // Se o formulário for válido, navega para a tela do jogo
                    Navigator.push(
                      context,
                      // caminho para a tela do jogo
                      MaterialPageRoute(
                        // Construtor da tela do jogo, passando os nomes dos jogadores
                        builder: (context) => TelaJogoDados(
                          nomeJogador1: _controladorJogador1.text,
                          nomeJogador2: _controladorJogador2.text,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ), // Botão ocupa toda a largura disponível
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ), // Espaçamento interno do botão
                ),
                child: const Text('Iniciar Jogo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Eu vou receber os nomes como propriedades

// 3. Tela do Jogo de Dados
// Tela onde o jogo de dados realmente acontece
class TelaJogoDados extends StatefulWidget {
  // Variaveis finais que armazenam os nomes recebidos da tela anterior
  final String nomeJogador1;
  final String nomeJogador2;
  // Construtor que recebe os nomes dos jogadores
  // é o corpo de um robô
  const TelaJogoDados({
    super.key,
    // O required indica que esses parametros são obrigatorios
    required this.nomeJogador1,
    required this.nomeJogador2,
  });
  @override
  // Cria o Objeto de estado que vai gerencia a tela do jogo, quando essa tala for criada o flutter chama esse metodo para controlar e guardar o estado dela
  // essa parte é o cérebro do robô que guarda as informações
  // o create state é o botão de ligar o cérebro ao corpo como uma medula espinhal
  State<TelaJogoDados> createState() => _EstadoTelaJogoDados();
}

class _EstadoTelaJogoDados extends State<TelaJogoDados> {
  final Random _aleatorio = Random(); //Gerador de numeros aleatorios
  // Lista dos 3 valores de cada jogador
  List<int> _lancamentosJogador1 = [
    1,
    1,
    1,
  ]; //Valores iniciais dos dados jogador 1
  List<int> _lancamentosJogador2 = [
    1,
    1,
    1,
  ]; //Valores iniciais dos dados jogador 2
  String _mensagemResultado = ''; //Mensagem que mostra o resultado do jogo

  // Mapear as associações do numero dado referente ao link
  final Map<int, String> imagensDados = {
    1: 'https://i.imgur.com/1xqPfjc.png&#39',
    2: 'https://i.imgur.com/5ClIegB.png&#39',
    3: 'https://i.imgur.com/hjqY13x.png&#39',
    4: 'https://i.imgur.com/CfJnQt0.png&#39',
    5: 'https://i.imgur.com/6oWpSbf.png&#39',
    6: 'https://i.imgur.com/drgfo7s.png&#39S',
  };
  //Lógica da pontuacao: verifica combinações para aplicar os multiplicadores
  int _calcularPontuacao(List<int> lancamentos) {
    //Percorre toda a lista e soma tudo
    final soma = lancamentos.reduce((a, b) => a + b);
    //[4,4,1] > 4 + 4 + 1 = 9
    final valoresUnicos = lancamentos.toSet().length;
    //toSet remove repetidos
    if (valoresUnicos == 1) { //Ex: [5, 5, 5] Tres iguais = 3x a soma
      return soma * 3;
    } else if (valoresUnicos == 2) { //Ex: [4, 4, 1] 2 iguais = 2x a soma
      return soma * 2;
    } else {//Ex: [1, 3, 6] todos diferentes = soma pura
      return soma;
    }
  }
  //Chamada pelo botao para lancar os dados
  void _lancarDados() { //Se  eu uso o sublinhado _ significa que ela é privada, só pode ser usada dentro da classe
    setState(() {
      //Comando crucial para forçar a atualizacao da tela.
      _lancamentosJogador1 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);
      _lancamentosJogador2 = List.generate(3, (_) => _aleatorio.nextInt(6) + 1);
      
      final pontuacao1 = _calcularPontuacao(_lancamentosJogador1);
      final pontuacao2 = _calcularPontuacao(_lancamentosJogador2);

      if (pontuacao1 > pontuacao2) {
        _mensagemResultado = '${widget.nomeJogador1} venceu! ($pontuacao1 x $pontuacao2)';
      } else if (pontuacao2 > pontuacao1) {
        _mensagemResultado = '${widget.nomeJogador2} venceu! ($pontuacao2 x $pontuacao1)';
      } else {
        _mensagemResultado = 'Empate, jogue novamente!';
      }
    });
  }


  //Declara a funcao que devolve um widget: recebe nome jogador, lancamentos: os 3 valores do dado.
  Widget _construirColunaJogador(String nome, List<int> lancamentos) {
    return Expanded( //Pega todo o espaço disponivel dentro de uma linha ou column
      child: Column(
        children: [
          Text(nome, style: const TextStyle(fontStyle: 18, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //Justify-content: center
            children: [
              lancamentos.map((valor) => {
                //Map transforma o numero do dado em um widget de imagem
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.network(
                    imagensDados[valor]!, //Pega a url do mapa usando o valor do dado
                    width: 50,
                    height: 50,
                    errorBuilder: (context, erro, StackTrace) => const Icon(Icons.error, size: 40),
                  ),
                );
              }),
            ],
          ),
        ],
      )
    );
  }
}
