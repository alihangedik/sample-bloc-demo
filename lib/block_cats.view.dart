import 'package:demo_bloc/cats_cubit.dart';
import 'package:demo_bloc/cats_repository.dart';
import 'package:demo_bloc/cats_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocCatsView extends StatefulWidget {
  const BlocCatsView({super.key});

  @override
  State<BlocCatsView> createState() => _BlocCatsViewState();
}

class _BlocCatsViewState extends State<BlocCatsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CatsCubit(SampleCatsRepository()),
      child: buildScaffold(context),
    );
  }

  Scaffold buildScaffold(BuildContext context) => Scaffold(
        // floatingActionButton: buildFABCall(context),
        appBar: AppBar(
          title: Text('hello!'),
        ),
        body: BlocConsumer<CatsCubit, CatsState>(
          listener: (context, state) {
            if (state is CatsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("error : ${state.message}")));
            }
          },
          builder: (context, state) {
            if (state is CatsInitial) {
              return buildInitial(context);
            } else if (state is CatsLoading) {
              return buildLoading();
            } else if (state is CatsCompleted) {
              return buildComplete(state);
            } else {
              return Center(child: buildError(state));
            }
          },
        ),
      );

  Text buildError(CatsState state) {
    final error = state as CatsError;
    return Text(error.message);
  }

  Widget buildComplete(CatsCompleted state) {
    return ListView.builder(
      itemCount: state.response.length,
      itemBuilder: (context, index) => ListTile(
        title: Image.network(
          state.response[index].imageUrl.toString(),
        ),
        subtitle: Text(
          state.response[index].description.toString(),
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  Center buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Center buildInitial(BuildContext context) {
    return Center(child: buildFABCall(context));
  }

  FloatingActionButton buildFABCall(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<CatsCubit>().getCats();
      },
      child: const Icon(Icons.ads_click),
    );
  }
}
