import 'package:flutter/material.dart';
import 'package:love14/models/poem.dart';

class PoemController with ChangeNotifier {
  final List<Poem> _poems = [
    Poem(
      id: '3',
      title: 'En Cada Latido',
      content:
          'En cada latido de mi corazón, te nombro en silencio,\ntu amor recorre mis venas como un fuego eterno y sereno.\n\nNo hay noche que no sueñe contigo, ni amanecer sin pensarte,\neres el faro de mi vida, el motivo por el cual respiro y ardo al amarte.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '4',
      title: 'Tiempo Contigo',
      content:
          'El tiempo se detiene cuando estás cerca, y el mundo cobra sentido,\ntus ojos son refugio y tus palabras, mi más preciado abrigo.\n\nCada segundo a tu lado es un regalo divino,\nun suspiro que se convierte en eternidad cuando sonríes conmigo.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '5',
      title: 'Luz de Mi Vida',
      content:
          'Llegaste como luz a una vida en sombras, y con tu amor, florecí,\ncada gesto tuyo es poesía que mi alma escribe por ti.\n\nTe amo más allá de la razón y de lo escrito en el cielo,\ntu amor es mi anhelo, mi verdad, mi más hermoso destello.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '6',
      title: 'Contigo Siempre',
      content:
          'Contigo aprendí que amar no es miedo, es paz y vuelo libre,\nque dos almas pueden unirse en un latido y jamás dividirse.\n\nEres mi refugio, mi hogar sin paredes, mi infinito sin final,\nte juro que te amaré hasta en lo eterno, hasta en lo irreal.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '7',
      title: 'Mirarte',
      content:
          'Mirarte es como ver el cielo reflejado en la tierra,\nuna mezcla de calma y tormenta que mi alma encierra.\n\nEres arte en movimiento, canción sin melodía,\npero al mismo tiempo, eres todo lo que da sentido a mi vida.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '8',
      title: 'Solo Tú',
      content:
          'He conocido la vida en tantas formas, pero ninguna como tú,\ntu amor es el único idioma que mi corazón entiende sin tabú.\n\nSolo tú haces que mi mundo gire con sentido y claridad,\nsolo tú me das razones para amar con sinceridad.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '9',
      title: 'Tu Nombre',
      content:
          'Tu nombre es el poema más hermoso que he aprendido a pronunciar,\ncada letra vibra en mí como un secreto que no deja de brillar.\n\nCuando te pienso, el universo se alinea con mi verdad,\neres mi principio, mi destino, mi única realidad.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '10',
      title: 'Eres Todo',
      content:
          'Eres el amanecer que rompe mi oscuridad,\nel latido que me salva en medio de la tempestad.\n\nNo hay palabra que te abarque, ni verso que te encierre,\ntu amor me transforma, me eleva, me mueve y me pertenece.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '11',
      title: 'Beso Infinito',
      content:
          'Daría mil vidas por un solo beso tuyo,\npues en él encuentro paz, deseo y orgullo.\n\nTu boca es promesa y mi anhelo más fiel,\ncada beso tuyo es un viaje hacia el edén de mi piel.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
    Poem(
      id: '12',
      title: 'Tú Me Enseñaste',
      content:
          'Tú me enseñaste que el amor no se busca, se encuentra,\nque el alma puede sentirse completa cuando se entrega.\n\nMe diste alas, raíz y razón de existir,\nte amo con cada parte de mí, y así será hasta el fin.',
      author: 'Anónimo',
      isFavorite: false,
      date: DateTime.now(),
    ),
  ];

  List<Poem> get poems => _poems;
  List<Poem> get favoritePoems =>
      _poems.where((poem) => poem.isFavorite).toList();

  void toggleFavorite(String poemId) {
    final index = _poems.indexWhere((poem) => poem.id == poemId);
    if (index != -1) {
      _poems[index].isFavorite = !_poems[index].isFavorite;
      notifyListeners();
    }
  }

  void addPoem(Poem poem) {
    _poems.add(poem);
    notifyListeners();
  }
}
