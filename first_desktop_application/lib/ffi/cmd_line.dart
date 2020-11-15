// ignore_for_file: avoid_print

import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

import 'utils/ffi_helpers.dart';

// C header typedef:
typedef SystemC = ffi.Void Function(ffi.Pointer<Utf8> command);

// Dart header typedef
typedef SystemDart = void Function(ffi.Pointer<Utf8> command);

// Navigate to lib/ffi
// Run `dart cmd_line.dart`
void main(List<String> args) {
  print(args);
  // TODO(aseem): Read this https://pub.dev/packages/args
  final sysLib = openSystemLibraryMacOS();
  // print(sysLib.handle);

  processCommand(sysLib, Commands.recentLogin);
}

ffi.DynamicLibrary openSystemLibraryMacOS() {
  final systemDyLib = ffi.DynamicLibrary.open(Dylibs.systemDyLib);
  return systemDyLib;
}

void processCommand(ffi.DynamicLibrary sysLib, String command) {
  /// Helper that combines lookup and cast to a Dart function.
  /// Originally lookup
  /// Looks up a symbol in the DynamicLibrary and returns its address in memory. Equivalent of dlsym.

  final sysFunc =
      sysLib.lookupFunction<SystemC, SystemDart>(Dylibs.systemSymbolName);

  // print(sysFunc.runtimeType);

  /// Convert a [String] to a Utf8-encoded null-terminated C string.
  /// Returns a malloc-allocated pointer to the result.
  final cmd = Utf8.toUtf8(command);

  sysFunc(cmd);

  /// Releases memory on the native heap.
  free(cmd);
}
