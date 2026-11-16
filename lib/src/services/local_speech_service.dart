import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_cpp_flutter_plus/whisper_cpp_flutter_plus.dart';

/// Local speech recognition only. No HTTP calls are made by this service.
/// The multilingual model is copied from the APK assets to private app storage.
class LocalSpeechService {
  static const String modelAsset = 'assets/models/ggml-tiny.bin';
  static const String modelFile = 'ggml-tiny.bin';

  WhisperEngine? _engine;
  dynamic _task;
  StreamSubscription<dynamic>? _updates;

  Future<void> load({
    void Function(double progress)? onProgress,
  }) async {
    if (_engine != null) return;

    final support = await getApplicationSupportDirectory();
    final modelsDir = Directory('${support.path}/models');
    if (!await modelsDir.exists()) {
      await modelsDir.create(recursive: true);
    }
    final model = File('${modelsDir.path}/$modelFile');

    if (!await model.exists() || await model.length() < 1000000) {
      final data = await rootBundle.load(modelAsset);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await model.writeAsBytes(bytes, flush: true);
    }

    if (!await model.exists() || await model.length() < 1000000) {
      throw StateError(
        'Modèle vocal absent ou invalide. Recompile ORBIT après scripts/prepare_models.ps1.',
      );
    }

    _engine = await WhisperEngine.load(
      model.path,
      config: const WhisperConfig(backend: WhisperBackend.cpu),
    );
    onProgress?.call(1);
  }

  Future<void> listen({
    required void Function(String partialText) onText,
    required void Function(Object error) onError,
  }) async {
    final engine = _engine;
    if (engine == null) {
      throw StateError('Le moteur vocal n’est pas chargé.');
    }
    await stop();
    _task = await engine.transcribeMicrophone(
      options: const TranscribeOptions(language: 'auto')
          .withPerformanceMode(WhisperPerformanceMode.efficient),
    );
    _updates = _task!.updates.listen(
      (update) => onText(update.text),
      onError: onError,
    );
  }

  Future<String> stop() async {
    await _updates?.cancel();
    _updates = null;
    final task = _task;
    _task = null;
    if (task == null) return '';
    final result = await task.stop();
    return result.confirmedText;
  }

  Future<void> dispose() async {
    await stop();
    await _engine?.dispose();
    _engine = null;
  }
}
