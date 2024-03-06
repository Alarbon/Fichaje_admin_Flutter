import 'package:fichaje_admin/models/worker_model.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WorkerSearchDelegate extends SearchDelegate {
  @override
  String? get searchFieldLabel => 'Buscar Trabajador por DNI concreto' ;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(FontAwesomeIcons.trash),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      // ignore: deprecated_member_use
      icon: const Icon(FontAwesomeIcons.close),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        FontAwesomeIcons.userNinja,
        size: 100,
        color: Colors.white60,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context, listen: false);

    signingWorkersProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: signingWorkersProvider.suggestionStream,
      builder: (_, AsyncSnapshot<Worker> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }
        final worker = snapshot.data;
        return _WorkerItem(worker: worker!);
        
      },
    );
  }
}

class _WorkerItem extends StatelessWidget {
  final Worker worker;
  const _WorkerItem({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context);
    return ListTile(
    
      title: Text(worker.name + ' ' + worker.lastName),
      subtitle: Text(worker.dni.toString()),
      onTap: () async => {
       signingWorkersProvider.prepareSelectedWorker(worker),

        context.push('/worker_details')
      
      },
    
    );
  }
}
