import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventor/screens/admin/widgetadmin.dart';
import 'package:eventor/service/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/formpage");
        },
        child: Icon(MdiIcons.plus),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Admin Eventor!',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.inversePrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          color: Theme.of(context).colorScheme.tertiaryContainer,
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
                      return EventoContainerAdmin(
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
