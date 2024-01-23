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
  BulbBloc({
    required this.globalEventBus,
  }) : super(const BulbState.initial()) {
    on<BulbInitialize>(_onBulbInitialize);
    on<SubscribeToGlobalEventBus>(_onSubscribeToGlobalEventBus);
    on<SwitchBulbOn>(_onSwitchBulbOn);
    on<SwitchBulbOff>(_onSwitchBulbOff);
  }

  /// A reference to the [GlobalEventBus] used for subscribing to global events.
  GlobalEventBus globalEventBus;

  Future<void> _changeBulbState(Emitter<BulbState> emit, bool bulbIsOn) async {
    emit(const BulbState.loading());

    // Do some async work
    // await Future.delayed(const Duration(seconds: 1));

    emit(
      BulbState.loaded(
        data: BulbStateData(bulbIsOn: bulbIsOn),
      ),
    );
  }

  FutureOr<void> _onBulbInitialize(
    BulbInitialize event,
    Emitter<BulbState> emit,
  ) async {
    add(SubscribeToGlobalEventBus());
    emit(
      const BulbState.initialized(
        data: BulbStateData(bulbIsOn: BulbStateData.bulbDefaultValue),
      ),
    );
  }

  FutureOr<void> _onSubscribeToGlobalEventBus(
    SubscribeToGlobalEventBus event,
    Emitter<BulbState> emit,
  ) async {
    await emit.onEach(
      globalEventBus.eventBus
          .where((event) => event == GlobalEvent.updateBulbState),
      onData: (_) {
        if (state.bulbIsOn) {
          add(SwitchBulbOff());
        } else {
          add(SwitchBulbOn());
        }
      },
      onError: (error, stackTrace) {
        // ignore: avoid_print
        print(error);
        emit(const BulbState.error());
      },
    );
  }

  FutureOr<void> _onSwitchBulbOff(
    SwitchBulbOff event,
    Emitter<BulbState> emit,
  ) async {
    await _changeBulbState(emit, false);
  }

  FutureOr<void> _onSwitchBulbOn(
    SwitchBulbOn event,
    Emitter<BulbState> emit,
  ) async {
    await _changeBulbState(emit, true);
  }
}
