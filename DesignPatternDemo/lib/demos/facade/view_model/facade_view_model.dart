///
/// facade_view_model.dart
/// FacadeViewModel
///
/// Created by Adam Chen on 2025/12/16
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:flutter/material.dart';

import '../model/subsystem.dart';
import '../pattern/home_theater_facade.dart';

enum SceneKind {movie, game, music}

class FacadeViewModel extends ChangeNotifier {
  // facade
  final HomeTheaterFacade facade;

  SceneKind selectedScene = SceneKind.movie;
  String movieTitle = 'Interstellar';
  String gameTitle = 'Console';
  String playlistName = 'My Favorites';

  final List<String> logs = [];
  String? _lastToast;


  FacadeViewModel()
      : facade = HomeTheaterFacade(
    amp: Amplifier(),
    projector: Projector(),
    lights: TheaterLights(),
    player: StreamingPlayer(),
  );

  String overallStatus() => facade.overallStatus();

  String? takeLastToast() {
    final m = _lastToast;
    _lastToast = null;
    return m;
  }


  void selectScene(SceneKind kind) {
    if (selectedScene == kind) return;
    selectedScene = kind;
    _log('選取：${_label(kind)}');
    notifyListeners();
  }

  void setMovieTitle(String title) {
    movieTitle = title;
    _log('設定電影名稱：$title');
    notifyListeners();
  }

  void setGameTitle(String title) {
    gameTitle = title;
    _log('設定遊戲名稱：$title');
    notifyListeners();
  }


  void setPlaylistName(String name) {
    playlistName = name;
    _log('設定音樂名稱：$name');
    notifyListeners();
  }
  
  // --- action ----
  void start() {
    switch (selectedScene) {
      case SceneKind.movie:
        facade.movieNight(movieTitle);
        _lastToast = 'Start ${_label(selectedScene)}: $movieTitle';
        break;
      case SceneKind.game:
        facade.gamingMode(title: gameTitle);
        _lastToast = 'Start ${_label(selectedScene)}: $gameTitle';
        break;
      case SceneKind.music:
        facade.musicMode(playlist: playlistName);
        _lastToast = 'Start ${_label(selectedScene)}: $playlistName';
        break;
    }
    _drainFacadeLogs();
    notifyListeners();
  }

  void pause() {
    facade.pause();
    _drainFacadeLogs();
    _lastToast = 'Paused';
    notifyListeners();
  }

  void resume() {
    facade.resume();
    _drainFacadeLogs();
    _lastToast = 'Resumed';
    notifyListeners();
  }

  void shutdown() {
    facade.shutdownAll();
    _drainFacadeLogs();
    _lastToast = 'Shutdown';
    notifyListeners();
  }
  void clearLogs() {
    logs.clear();
    facade.clearLogs();
    _lastToast = 'Log cleared!!!';
    notifyListeners();
  }

  // --- helper ---
  String _label(SceneKind kind) {
    return switch (kind) {
      SceneKind.movie => '電影',
      SceneKind.game => '遊戲',
      SceneKind.music => '音樂'
    };
  }

  void _log(String s) => logs.add(s);

  void _drainFacadeLogs() {
    // drain facade logs
    logs.addAll(facade.logs);   // batch
    //facade.logs.forEach(_log); // every
    facade.clearLogs();
  }


}


