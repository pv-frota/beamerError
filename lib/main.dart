import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: BeamerDelegate(
        initialPath: '/test',
        locationBuilder: RoutesLocationBuilder(
          routes: {
            '/*': (_, __, ___) => Home(),
          },
        ),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  final GlobalKey<BeamerState> beamKey = GlobalKey<BeamerState>();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Beamer(
        key: widget.beamKey,
        routerDelegate: BeamerDelegate(
            initialPath: '/emissoes',
            locationBuilder: BeamerLocationBuilder(
                beamLocations: [
                  EmissaoLocation(),
                  AtendimentoLocation()
                ]
            )
        ),
      ),
      bottomNavigationBar: _createNavigationBar(),
    );
  }

  Widget _createNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        final currentBeamLocation = widget.beamKey.currentState!.routerDelegate.currentBeamLocation;
        if(currentBeamLocation is EmissaoLocation && index != 0
            || currentBeamLocation is AtendimentoLocation && index != 1) {
          setState(() {
            _currentIndex = index;
          });
          widget.beamKey.currentState!.routerDelegate.beamToNamed(index == 0 ? '/emissoes':'/atendimento');
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.print),
          label: 'Emissões',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Atendimento',
        ),
      ],
    );
  }
}

class EmissaoLocation extends BeamLocation {
  @override
  List<Pattern> get pathPatterns => ['/emissoes'];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    return [
      BeamPage(
        key: const ValueKey('emissoes'),
        title: 'Emissões de Documentos - Ufrapp',
        type: BeamPageType.noTransition,
        child: Container(
          color: Colors.red,
        ),
      )
    ];
  }
}

class AtendimentoLocation extends BeamLocation {
  @override
  List<Pattern> get pathPatterns => ['/atendimento'];

  @override
  List<BeamPage> buildPages(
      BuildContext context, RouteInformationSerializable state) {
    return [
      BeamPage(
        key: const ValueKey('atendimento'),
        title: 'Atendimento ao Aluno',
        type: BeamPageType.noTransition,
        child: Container(
          color: Colors.green,
        ),
      )
    ];
  }
}

