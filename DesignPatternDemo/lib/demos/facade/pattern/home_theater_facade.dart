///
/// home_theater_facade.dart
/// HomeTheaterFacade
///
/// Created by Adam Chen on 2025/12/16
/// Copyright © 2025 Abb company. All rights reserved
///
import '../model/subsystem.dart';

class HomeTheaterFacade {
  // subsystem
  final Amplifier amp;
  final Projector projector;
  final TheaterLights lights;
  final StreamingPlayer player;

  // logs
  final List<String> logs = [];

  // constructor
  HomeTheaterFacade({required this.amp,
    required this.projector,
    required this.lights,
    required this.player});

  // see movie
  void movieNight(String title) {
    _log('--- Movie Night: "$title" ---');
    lights.dim(20);
    _log(lights.status());

    projector.on();
    projector.setMode('Cinema');
    _log(projector.status());

    amp.on();
    amp.setVolume(45);
    amp.setInput('HDMI-1');
    _log(amp.status());

    player.on();
    player.play(title);
    _log(player.status());
  }

  // play game
  void gamingMode({String title = 'Console'}) {
    _log('--- Gaming Mode ---');
    lights.dim(60);
    _log(lights.status());

    projector.on();
    projector.setMode('Game');
    _log(projector.status());

    amp.on();
    amp.setVolume(55);
    amp.setInput('HDMI-2');
    _log(amp.status());

    player.on();
    player.play(title);
    _log(player.status());

  }

  // hear music
  void musicMode({String playlist = 'My Favorites'}) {
    _log('--- Music Mode ---');
    lights.dim(40);
    _log(lights.status());

    projector.off();
    _log(projector.status());

    amp.on();
    amp.setInput('BT-Audio');
    amp.setVolume(35);
    _log(amp.status());

    player.on();
    player.play(playlist);
    _log(player.status());
  }

  // shutdown all
  void shutdownAll() {
    _log('--- Shutdown ---');
    player.off();
    _log(player.status());

    amp.off();
    _log(amp.status());

    projector.off();
    _log(projector.status());

    lights.off();
    _log(lights.status());
  }

  void pause() {
    player.pause();
    _log('Pause → ${player.status()}');
  }

  void resume() {
    player.resume();
    _log('Resume → ${player.status()}');
  }

  String overallStatus() =>
      '${lights.status()} | ${projector.status()} | ${amp.status()} | ${player.status()}';

  void clearLogs() => logs.clear();

  // --- helper ---
  void _log(String s) => logs.add(s);



}