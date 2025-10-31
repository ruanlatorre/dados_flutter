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
    6: 'https://i.imgur.com/drgfo7s.png&#39',
  };

  // Logica da pontuação: verifica o bolo de chocolate + cobertura para aplicar ao forno
  int _calcularPontuacao(List<int> lancamentos) {
    // percorre toda a lista de lançamentos e soma os valores
    final soma = lancamentos.reduce((a, b) => a + b);
    // [4, 4, 1] => 9 4+4 = 8 + 1 = 9
    final valoresUnicos = lancamentos
        .toSet()
        .length; // Converte a lista em um conjunto para obter valores únicos
    //toSet remove repetidos
    switch (valoresUnicos) {
      case 1:
        // Trinca (todos os valores iguais exemplo: 4,4,4)
        return soma * 3; // Bônus de 6 pontos
      case 2:
        // Dupla (dois valores iguais e um diferente exemplo: 4,4,1)
        return soma * 2; // Bônus de 3 pontos
      default:
        // Todos os valores diferentes exemplo: 4,2,6
        return soma; // Sem bônus
    }
  }

  // Função para lançar os dados e atualizar o estado do jogo
  void _lancarDados() {
    //eu uso o sublinhado _ sginifica que ela é orivada, só pode ser usada dentro dessa clase
    setState(() {
      //tipo o document get element by id do DOM, ele avisa o flutter que algo mudou e ele precisa redesenhar a tela
      // Gera 3 números aleatórios entre 1 e 6 para cada jogador
      _lancamentosJogador1 = List.generate(3, (int index) => _aleatorio.nextInt(6) + 1);
      _lancamentosJogador2 = List.generate(3, (int index) => _aleatorio.nextInt(6) + 1);

      // Calcula as pontuações dos jogadores
      final pontuacaoJogador1 = _calcularPontuacao(_lancamentosJogador1);
      final pontuacaoJogador2 = _calcularPontuacao(_lancamentosJogador2);

      // Determina o resultado do jogo
      if (pontuacaoJogador1 > pontuacaoJogador2) {
        _mensagemResultado =
            '${widget.nomeJogador1} vence com $pontuacaoJogador1 pontos!';
      } else if (pontuacaoJogador2 > pontuacaoJogador1) {
        _mensagemResultado =
            '${widget.nomeJogador2} vence com $pontuacaoJogador2 pontos!';
      } else {
        _mensagemResultado = 'Empate com $pontuacaoJogador1 pontos cada!';
      }
    });
  }

  // declara a função e devolve um widget recebe nome jogador, lançamentos no caso os 3 valores do dado
  Widget _contruirColunaJogador(String nome, List<int> lancamentos) {
    return Expanded(
      //pega todos o espaço disponivel dentro de um row ou column
      child: Column(
        children: [
          Text(
            nome,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // é o justify content do css
            children: lancamentos
                // transforma o numero do dado em uma widget de imagem
                .map(
                  (valor) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      imagensDados[valor]!, //pega a url do mapa usando o valor do dado
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 40);
                      },
                    ),
                  ),
                )
                .toList(), //converte o resultado do map em uma lista de widgets
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jogo de Dados')),
      body: Column(
        children: [
          Row(
            children: [
              // Constrói a coluna do jogador 1
              _contruirColunaJogador(widget.nomeJogador1, _lancamentosJogador1),
              // Constrói a coluna do jogador 2
              _contruirColunaJogador(widget.nomeJogador2, _lancamentosJogador2),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            _mensagemResultado,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: _lancarDados,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: Text('Jogar dados'),
          ) //Empurra o botão para a parte de baixo da tela
        ],
      ),
    );
  }
}