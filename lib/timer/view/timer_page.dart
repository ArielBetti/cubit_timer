import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cubit_timer/ticker.dart';
import 'package:cubit_timer/timer/timer.dart';

class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerInitial) ...[
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.lightGreenAccent,
                onPressed: () => context
                    .read<TimerBloc>()
                    .add(TimerStarted(duration: state.duration)),
                child: const Icon(Icons.play_arrow),
              ),
            ],
            if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.lightGreenAccent,
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerPaused()),
                child: const Icon(Icons.pause),
              ),
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.lightGreenAccent,
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerReset()),
                child: const Icon(Icons.replay),
              ),
            ],
            if (state is TimerRunPause) ...[
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.lightGreenAccent,
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerResumed()),
                child: const Icon(Icons.play_arrow),
              ),
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.lightGreenAccent,
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerReset()),
                child: const Icon(Icons.replay),
              ),
            ],
            if (state is TimerRunComplete) ...[
              FloatingActionButton(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.lightGreenAccent,
                onPressed: () =>
                    context.read<TimerBloc>().add(const TimerReset()),
                child: const Icon(Icons.replay),
              ),
            ]
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.indigo.shade900,
            Colors.indigo.shade600,
          ],
        ),
      ),
    );
  }
}

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              Actions(),
            ],
          ),
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return (
        Center(
        child: Column(
      children: [
        const Text.rich(
          TextSpan(
            text: 'Pomodoro',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Monospace',
            ),
          ),
        ),
        Text.rich(
          TextSpan(text: '$minutesStr:$secondsStr'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.lightGreenAccent,
            fontSize: 100,
            fontFamily: 'Monospace',
          ),
        )
      ],
    )));
  }
}
