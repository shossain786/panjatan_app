import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panjatan_app/bloc/bloc/sawal_bloc.dart';
import 'package:panjatan_app/bloc/bloc/sawal_event.dart';
import 'package:panjatan_app/bloc/bloc/sawal_state.dart';
import 'package:panjatan_app/widgets/app_background.dart';
import '../widgets/animated_card.dart';

class IrshadatAliScreen extends StatelessWidget {
  const IrshadatAliScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SawalBloc>().add(FetchSawals());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Irshadat E ALI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {
              context.read<SawalBloc>().add(SyncSawals()); // Trigger sync event
            },
          ),
        ],
      ),
      body: Container(
        decoration: myScreenBG(),
        child: BlocBuilder<SawalBloc, SawalState>(
          builder: (context, state) {
            if (state is SawalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SawalLoaded) {
              if (state.sawals.isEmpty) {
                return const Center(
                  child: Text('No data available. Please sync to fetch data.'),
                );
              }
              return ListView.builder(
                itemCount: state.sawals.length,
                itemBuilder: (context, index) {
                  final sawal = state.sawals[index];
                  return AnimatedCard(
                    cardNumber: index + 1,
                    content: sawal.content,
                    category: sawal.category,
                    date: sawal.date,
                  );
                },
              );
            } else if (state is SawalError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<SawalBloc>()
                            .add(FetchSawals()); // Retry fetch
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
