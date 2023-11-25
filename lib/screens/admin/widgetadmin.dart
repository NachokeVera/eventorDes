import 'package:eventor/service/firestore_service.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EventoContainerAdmin extends StatefulWidget {
  final String id;
  final String nombre;
  final String lugar;
  final String descripcion;
  final DateTime fechaHora;
  final String tipo;
  final String imgPath;
  final int likes;

  const EventoContainerAdmin({
    Key? key,
    required this.nombre,
    required this.lugar,
    required this.fechaHora,
    required this.likes,
    required this.descripcion,
    required this.tipo,
    required this.imgPath,
    required this.id,
  }) : super(key: key);

  @override
  State<EventoContainerAdmin> createState() => _EventoContainerAdminState();
}

class _EventoContainerAdminState extends State<EventoContainerAdmin> {
  bool likeSelected = false;
  Color amarillo = const Color.fromARGB(255, 255, 255, 200);
  Color gris = const Color.fromARGB(255, 206, 206, 206);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 155,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _colorEstado(widget.fechaHora),
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
              Text(
                  'Fecha: ${DateFormat('dd-MM-yyyy').format(widget.fechaHora)}'),
              Text('Hora: ${DateFormat('HH:mm').format(widget.fechaHora)}'),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 20,
                  child: FilledButton(
                    child: Icon(MdiIcons.trashCan, size: 20),
                    onPressed: () async {
                      await FirestoreService().eliminarEvento(widget.id);
                    },
                  )),
              const SizedBox(
                height: 3,
              ),
              SizedBox(
                  height: 20,
                  child: FilledButton(
                    child: Icon(MdiIcons.pen, size: 20),
                    onPressed: () {},
                  )),
              const SizedBox(
                height: 3,
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
                          fechaEv:
                              DateFormat('yyyy-MM-dd').format(widget.fechaHora),
                          horaEv: DateFormat('HH:mm').format(widget.fechaHora),
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
              IconButton(
                isSelected: likeSelected,
                onPressed: () {
                  setState(() {
                    if (!likeSelected) {
                      int likes = widget.likes + 1;
                      FirestoreService().actualizarLikes(widget.id, likes);
                    } else {
                      int likes = widget.likes - 1;
                      if (likes >= 0) {
                        FirestoreService().actualizarLikes(widget.id, likes);
                      }
                    }
                    likeSelected = !likeSelected;
                  });
                },
                icon: Icon(MdiIcons.heartOutline),
                selectedIcon: Icon(MdiIcons.heart),
              ),
              Text(
                widget.likes.toString(),
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

  Color _colorEstado(DateTime fechaHora) {
    DateTime diaHoy = DateTime.now();
    int diferenciaEnDias = fechaHora.difference(diaHoy).inDays;
    if (diferenciaEnDias > 3) {
      return Colors.pink.shade100;
    } else if (diferenciaEnDias >= 0) {
      return amarillo;
    } else {
      return gris;
    }
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
                        width: 200,
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
