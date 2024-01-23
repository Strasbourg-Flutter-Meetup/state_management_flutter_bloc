// Project: state_management_flutter_bloc
// Author: Daniel Krentzlin
// Dev Environment: Android Studio
// Platform: Windows 11
// Copyright:  2024
// ID: 20240119083814
// 19.01.2024 08:38
/// A sealed class representing the different events that can be processed
/// by [BulbBloc].
///
/// This class serves as a base for all events related to the Bulb functionality.
/// Being a sealed class, it allows for type-safe use of these events
/// in the bloc's event handling.
abstract class BulbEvent {}

/// Event representing the initialization of the Bulb.
///
/// This event is typically dispatched when the Bulb functionality is
/// being set up or started. It can be used to perform any initial
/// setup required for the Bulb.
class BulbInitialize extends BulbEvent {}

/// Event to switch the Bulb on.
///
/// Dispatch this event when the Bulb needs to be turned on.
/// This will trigger the bloc to handle the necessary logic
/// to change the state of the Bulb to an 'on' state.
class SwitchBulbOn extends BulbEvent {}

/// Event to switch the Bulb off.
///
/// Dispatch this event to turn the Bulb off.
/// The bloc will respond to this event by executing logic
/// required to change the state of the Bulb to an 'off' state.
class SwitchBulbOff extends BulbEvent {}

/// Event to subscribe to the global event bus.
class SubscribeToGlobalEventBus extends BulbEvent {}
