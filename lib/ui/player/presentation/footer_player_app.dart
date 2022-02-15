// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:podcast_app/ui/app/bloc/app_bloc.dart';
import 'package:podcast_app/ui/detail/models/episodes_model.dart';
import 'package:podcast_app/ui/shared/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FooterPlayerApp extends StatefulWidget {
  const FooterPlayerApp({
    Key? key,
    required this.episode,
    required this.appBloc,
  }) : super(key: key);

  final EpisodesModel episode;
  final AppBloc appBloc;

  @override
  State<FooterPlayerApp> createState() => _FooterPlayerAppState();
}

class _FooterPlayerAppState extends State<FooterPlayerApp> {
  int duration = 1;
  int position = 0;

  double percentage = 0.0;

  @override
  void initState() {
    super.initState();
    widget.appBloc.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event.inSeconds;
      });
    });
    widget.appBloc.audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event.inSeconds;
      });
    });
    // percentage = (position) / duration;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      width: screenWidth,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        width: double.infinity,
        child: Card(
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.episode.image,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.episode.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        color: kSecondaryColor,
                        backgroundColor: Colors.grey.shade200,
                        value: (position) / duration,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<AppBloc, AppState>(
                  builder: (context, state) {
                    final isPaused = state.episodeStatus == EpisodeStatus.pause;
                    return IconButton(
                      onPressed: () {
                        context.read<AppBloc>().add(
                              AppEpisodePaused(
                                isPaused: !isPaused,
                              ),
                            );
                      },
                      icon: Icon(
                        isPaused ? Iconsax.play : Iconsax.pause,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
