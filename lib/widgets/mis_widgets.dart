import 'package:eventor/service/firestore_service.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventoContainer extends StatefulWidget {
  final String nombre;
  final String lugar;
  final String descripcion;
  final String fecha;
  final String hora;
  final String tipo;
  final String imgPath;
  final int likes;

  const EventoContainer({
    Key? key,
    required this.nombre,
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.likes,
    required this.descripcion,
    required this.tipo,
    required this.imgPath,
  }) : super(key: key);

  @override
  State<EventoContainer> createState() => _EventoContainerState();
}

class _EventoContainerState extends State<EventoContainer> {
  bool likeSelected = false;
  bool favSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      decoration: BoxDecoration(
        border: Border.all(
          color: favSelected ? Colors.yellow : Colors.transparent,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(4.0, 4.0),
          ),
          const BoxShadow(
            color: Colors.white70,
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(-4.0, -4.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Titulo: ${widget.nombre}'),
              Text('Lugar: ${widget.lugar}'),
              Text('Fecha: ${widget.fecha}'),
              Text('Hora: ${widget.hora}'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 20,
                child: FilledButton(
                  child: Icon(MdiIcons.informationVariant, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MiDialog(
                          nomEv: widget.nombre,
                          lugarEv: widget.lugar,
                          descEv: widget.descripcion,
                          fechaEv: widget.fecha,
                          horaEv: widget.hora,
                          tipoEv: widget.tipo,
                          imgPathEv: widget.imgPath,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                height: 20,
                child: FilledButton(
                  child: Icon(MdiIcons.star, size: 20),
                  onPressed: () {
                    setState(() {
                      favSelected = !favSelected;
                    });
                  },
                ),
              ),
              IconButton(
                isSelected: likeSelected,
                onPressed: () {
                  setState(() {
                    likeSelected = !likeSelected;
                  });
                },
                icon: Icon(MdiIcons.heartOutline),
                selectedIcon: Icon(MdiIcons.heart),
              ),
              Text(
                '0',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MiDialog extends StatelessWidget {
  const MiDialog({
    super.key,
    required this.nomEv,
    required this.lugarEv,
    required this.descEv,
    required this.fechaEv,
    required this.horaEv,
    required this.tipoEv,
    required this.imgPathEv,
  });

  final String nomEv;
  final String lugarEv;
  final String descEv;
  final String fechaEv;
  final String horaEv;
  final String tipoEv;
  final String imgPathEv;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 231, 239),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(MdiIcons.arrowLeft),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(
                  width: 20,
                  height: 1,
                ),
                Text(nomEv)
              ],
            ),
            const Divider(),
            Column(
              children: [
                Text('Descripcion: $descEv'),
                Text('Lugar: $lugarEv'),
                Text('tipo Evento: $tipoEv'),
                Text('Fecha: $fechaEv y hora: $horaEv'),
                FutureBuilder<String>(
                  future: FirestoreService().getImageUrl(imgPathEv),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Image.network(
                        snapshot.data!,
                        width: 200, // ajusta el tamaño según tus necesidades
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
