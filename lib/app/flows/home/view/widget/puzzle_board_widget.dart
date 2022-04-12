//Flutter
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Bloc
import 'package:puzzle_hack/core/bloc/theme/theme_bloc.dart';
import 'package:puzzle_hack/core/bloc/theme/theme_state.dart';

import 'package:puzzle_hack/core/bloc/puzzle/puzzle_bloc.dart';
import 'package:puzzle_hack/core/bloc/puzzle/puzzle_state.dart';

import 'package:puzzle_hack/core/bloc/timer/timer_bloc.dart';
import 'package:puzzle_hack/core/bloc/timer/timer_event.dart';


import 'package:puzzle_hack/core/data/models/tile/tile.dart';

import 'package:puzzle_hack/core/components/puzzle/puzzle_keyboard_handler.dart';


class PuzzleBoardWidget extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ThemeBloc,ThemeState>(
      builder: (BuildContext context, ThemeState tState){
        return BlocBuilder<PuzzleBloc, PuzzleState>(
          builder: (BuildContext context,PuzzleState pState) {
            if(pState.puzzle.getDimension() == 0){
              return const CircularProgressIndicator();
            }else{
              return PuzzleKeyboardHandler(
                child: BlocListener<PuzzleBloc, PuzzleState>(
                  listener: (BuildContext context,PuzzleState state) {
                    if (tState.theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
                      context.read<TimerBloc>().add(const TimerStopped());
                    }
                  },
                  child: tState.theme.layoutDelegate.boardBuilder(
                    pState.puzzle.getDimension(),
                    pState.puzzle.tiles.map(
                      (tile) => _PuzzleTile(
                        key: Key('puzzle_tile_${tile.value.toString()}'),
                        tile: tile,
                      ),
                    ).toList(),
                  ),
                ),
              );
            }
          },
        );    
      },
    );
  }
}


class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}
