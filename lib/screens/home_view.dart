import 'package:fichaje_admin/models/worker_model.dart';
import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:fichaje_admin/search/search_delegate.dart';
import 'package:fichaje_admin/widgets/worker_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingProvider = Provider.of<SettingsProvider>(context);
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context);

    final List<Worker>? workers = signingWorkersProvider.workers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: WorkerSearchDelegate(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () {
              settingProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: workers == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : workers.isEmpty
              ? Center(
                  child:
                      // ignore: deprecated_member_use
                      Opacity(
                    opacity: 0.2,
                    child: Text(
                      'No hay trabajadores',
                      style: TextStyle(fontSize: size.width < 600 ? 20 : 30),
                      textAlign: TextAlign.center,
                      // ignore: deprecated_member_use
                      textScaleFactor: 1.5,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Trabajadores',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: size.width < 700 ? 2 : 4,
                          childAspectRatio: size.width / (size.height / 1),
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                        itemCount: workers.length,
                        itemBuilder: (context, index) {
                          return WorkerCard(worker: workers[index]);
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
