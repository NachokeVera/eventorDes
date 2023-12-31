import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:eventor/widgets/mis_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('EVENTOR!',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.surfaceTint)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/loginpage");
              },
              icon: const Icon(Icons.power_settings_new))
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: StreamBuilder(
              stream: FirestoreService().eventos(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.data == null) {
                  return const Center(
                    child: Text('No hay Eventos'),
                  );
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var evento = snapshot.data!.docs[index];
                      var fechaHoraTimestamp = evento['fecha'] as Timestamp;
                      var t = fechaHoraTimestamp.toDate();
                      String eventId = evento.id;
                      return EventoContainer(
                        id: eventId,
                        nombre: evento['nombre'],
                        lugar: evento['lugar'],
                        fechaHora: t,
                        likes: evento['likes'],
                        descripcion: evento['descripcion'],
                        tipo: evento['tipo'],
                        imgPath: evento['imgPath'],
                      );
                    },
                  );
                }
              })),
    );
  }
}
