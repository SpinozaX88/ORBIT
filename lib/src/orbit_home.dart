import 'package:flutter/material.dart';
import 'orbit_state.dart';
import 'services/local_speech_service.dart';

class OrbitHome extends StatefulWidget {
  const OrbitHome({super.key});

  @override
  State<OrbitHome> createState() => _OrbitHomeState();
}

class _OrbitHomeState extends State<OrbitHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  final OrbitState _state = OrbitState();
  final LocalSpeechService _speech = LocalSpeechService();

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
      lowerBound: .97,
      upperBound: 1.025,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    _speech.dispose();
    super.dispose();
  }

  Future<void> _toggleSession() async {
    if (_state.isListening) {
      final finalText = await _speech.stop();
      if (!mounted) return;
      setState(() {
        if (finalText.isNotEmpty) _state.transcript = finalText;
        _state.isListening = false;
        _state.status = 'Écoute terminée · traitement local';
      });
      return;
    }

    setState(() {
      _state.isLoading = true;
      _state.status = 'Chargement du moteur vocal…';
    });

    try {
      await _speech.load();
      await _speech.listen(
        onText: (text) {
          if (!mounted) return;
          setState(() {
            _state.transcript = text;
            _state.status = 'Reconnaissance vocale locale';
          });
        },
        onError: (error) {
          if (!mounted) return;
          setState(() {
            _state.status = 'Erreur audio : $error';
            _state.isListening = false;
          });
        },
      );
      if (!mounted) return;
      setState(() {
        _state.isLoading = false;
        _state.isListening = true;
        _state.status = 'Je t’écoute · traitement sur le téléphone';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state.isLoading = false;
        _state.isListening = false;
        _state.status = 'Moteur indisponible : $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _state.isListening
        ? const Color(0xFF58D6FF)
        : const Color(0xFF438DB7);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('ORBIT',
            style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 3)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Center(
              child: Row(children: [
                Icon(Icons.shield_outlined,
                    color: Color(0xFF65D6A7), size: 17),
                SizedBox(width: 5),
                Text('LOCAL', style: TextStyle(
                    color: Color(0xFF65D6A7),
                    fontSize: 11, letterSpacing: 1.2)),
              ]),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text('INTERPRÈTE PERSONNEL',
                  style: TextStyle(color: Color(0xFF8291A5),
                      fontSize: 11, letterSpacing: 2)),
              const Spacer(),
              ScaleTransition(
                scale: _pulse,
                child: GestureDetector(
                  onTap: _state.isLoading ? null : _toggleSession,
                  child: Container(
                    width: 154,
                    height: 154,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        accent.withOpacity(.42),
                        accent.withOpacity(.12),
                        Colors.transparent,
                      ]),
                      boxShadow: [
                        BoxShadow(color: accent.withOpacity(.20),
                            blurRadius: 36, spreadRadius: 5),
                      ],
                      border: Border.all(
                          color: accent.withOpacity(.55), width: 1.2),
                    ),
                    child: _state.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(54),
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(_state.isListening
                            ? Icons.graphic_eq : Icons.blur_on,
                            color: const Color(0xFFD8F5FF), size: 62),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              Text(_state.isListening ? 'Écoute…' : 'Prêt à traduire',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(_state.status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color(0xFF8493A8), fontSize: 12)),
              const Spacer(),
              Row(children: [
                Expanded(child: _languageTile('VOTRE LANGUE', '🇫🇷  Français')),
                const SizedBox(width: 10),
                Expanded(child: _languageTile('INTERLOCUTEUR', '✨  Automatique')),
              ]),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 112, maxHeight: 180),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF121B29),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF253449)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('TRANSCRIPTION RECONNUE',
                          style: TextStyle(color: Color(0xFF65D6A7),
                              fontSize: 10, letterSpacing: 1.3)),
                      const SizedBox(height: 9),
                      Text(
                        _state.transcript.isEmpty
                            ? 'Les paroles reconnues apparaîtront ici.'
                            : _state.transcript,
                        style: const TextStyle(
                            color: Color(0xFFB8C5D5), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: _state.isLoading ? null : _toggleSession,
                  icon: Icon(_state.isListening ? Icons.stop : Icons.mic),
                  label: Text(_state.isListening ? 'ARRÊTER' :
                      _state.isLoading ? 'CHARGEMENT…' : 'PARLER'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF183B52),
                    foregroundColor: const Color(0xFFE7F8FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Audio traité localement · aucun historique',
                  style: TextStyle(
                      color: Color(0xFF65758A), fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageTile(String label, String value) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFF121B29),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFF253449)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(
          color: Color(0xFF8291A5), fontSize: 9, letterSpacing: 1.1)),
      const SizedBox(height: 7),
      Text(value, style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  );
}
