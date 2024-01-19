// Project: Cubit Example
// Author: Daniel Krentzlin
// Project begin: 05.10.2023
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright: Walnut IT 2023
// ID: 20231005095140
// 05.10.2023 09:51
import 'dart:async';

import 'package:bloc_example/features/dashboard/presentation/bloc/bulb_events.dart';
import 'package:bloc_example/features/dashboard/presentation/bloc/bulb_state.dart';
import 'package:bloc_example/global_event_bus/global_event.dart';
import 'package:bloc_example/global_event_bus/global_event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A Bloc class for managing the state and events related to a Bulb feature.
/// It extends [Bloc] from the bloc package and uses [BulbEvent] as the event type and [BulbState] as the state type.
class BulbBloc extends Bloc<BulbEvent, BulbState> {
  /// Constructs a [BulbBloc].
  ///
  /// Takes [initialState] to set the initial state of the bloc and
  /// a required [globalEventBus] to listen to global events.
  BulbBloc(
    super.initialState, {
    required this.globalEventBus,
  }) {
    on<BulbInitialization>((event, emit) {
      initialize();
      emit(BulbState.initialized(
        data: _stateData,
      ));
    });

    on<SwitchBulbOn>((event, emit) {
      emit(const BulbState.loading());

      switchBulbOn();

      emit(BulbState.loaded(
        data: _stateData,
      ));
    });

    on<SwitchBulbOff>((event, emit) {
      emit(const BulbState.loading());

      switchBulbOff();

      emit(BulbState.loaded(
        data: _stateData,
      ));
    });
  }

  /// A reference to the [GlobalEventBus] used for subscribing to global events.
  GlobalEventBus globalEventBus;

  /// Private field for storing state data.
  BulbStateData? _stateData;

  /// Private field indicating whether the bulb is on or off.
  bool _bulbIsOn = false;

  /// A stream subscription for listening to global events.
  StreamSubscription? _globalEventBusStreamSubscription;

  /// Public getter to know if the bulb is currently on.
  bool get bulbIsOn => _bulbIsOn;

  /// Initializes the bloc by setting up listeners and updating state data.
  void initialize() {
    _listenToGlobalEventBus();
    _updateStateData();
  }

  /// Method to switch the bulb on.
  void switchBulbOn() {
    _bulbIsOn = true;
    _updateStateData();
  }

  /// Method to switch the bulb off.
  void switchBulbOff() {
    _bulbIsOn = false;
    _updateStateData();
  }

  /// Private method to update the state data based on the current state of the bulb.
  void _updateStateData() {
    _stateData = BulbStateData(bulbIsOn: _bulbIsOn);
  }

  /// Sets up a listener on the global event bus for bulb state updates.
  void _listenToGlobalEventBus() {
    _globalEventBusStreamSubscription = globalEventBus.eventBus
        .where((event) => event == GlobalEvent.updateBulbState)
        .listen((event) {
      if (_bulbIsOn) {
        add(SwitchBulbOff());
      } else {
        add(SwitchBulbOn());
      }
    });
  }

  @override
  Future<void> close() async {
    await _globalEventBusStreamSubscription?.cancel();
    return super.close();
  }
}
