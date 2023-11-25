import 'dart:io';
import 'package:eventor/service/firestore_service.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:time_pickerr/time_pickerr.dart';
import 'package:intl/intl.dart';
//import 'package:flutter/services.dart';

class FormEvento extends StatefulWidget {
  const FormEvento({super.key});

  @override
  State<FormEvento> createState() => _FormEventoState();
}

class _FormEventoState extends State<FormEvento> {
  GlobalKey formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final lugarCtrl = TextEditingController();
  final descripcionCtrl = TextEditingController();
  List<DateTime> fecha = [DateTime.now()];
  String? tipoEv;
  PlatformFile? img;
  late String fechaString = DateFormat('yyyy-MM-dd').format(fecha[0]);
  late String horaString = DateFormat('HH:mm').format(fecha[0]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        FirestoreService().eventoAgregar(nombreCtrl.text, lugarCtrl.text,
            descripcionCtrl.text, fecha[0], tipoEv!, 'imagenes/${img!.name}');
        FirestoreService().uploadFile(img!);
        Navigator.pushNamed(context, "/homepage");
      }),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agregar Evento!',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.inversePrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
          padding: const EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Form(
            child: ListView(
              children: [
                TextFormField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: lugarCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Lugar:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: descripcionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Descripcion:',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    IconButton.filled(
                        onPressed: () => _fechapick(context),
                        icon: Icon(MdiIcons.calendarEdit)),
                    Text(
                        'Fecha Evento: ${DateFormat('dd-MM-yyyy').format(fecha[0])}')
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    IconButton.filled(
                        onPressed: () => _horapick(context),
                        icon: Icon(MdiIcons.clockTimeThree)),
                    Text('Hora Evento: ${DateFormat('HH:mm').format(fecha[0])}')
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [const Text('Tipo Evento: '), buildTipoDropdown()],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: _selectFile,
                        child: const Text('Seleccionar Imagen'))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                if (img != null)
                  Expanded(
                      child: Container(
                    color: Colors.pink,
                    child: Image.file(
                      File(img!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ))
              ],
            ),
          )),
    );
  }

  Widget buildTipoDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color:
              Colors.grey, // Puedes ajustar el color del borde según tu diseño
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton<String>(
          value: tipoEv,
          onChanged: (String? tipoSelect) {
            setState(() {
              tipoEv = tipoSelect;
            });
          },
          items: const [
            DropdownMenuItem(
                value: 'Deportivo', child: Text('Evento Deportivo')),
            DropdownMenuItem(value: 'Concierto', child: Text('Concierto')),
            DropdownMenuItem(value: 'Fiesta', child: Text('Fiesta')),
            DropdownMenuItem(
                value: 'Universitario', child: Text('Universitario')),
          ],
        ),
      ),
    );
  }

  Widget buildCustomTimer(BuildContext context) {
    return CustomHourPicker(
      elevation: 2,
      onPositivePressed: (context, time) {
        setState(() {
          int hour = time.hour;
          int minute = time.minute;
          fecha[0] = DateTime(
              fecha[0].year, fecha[0].month, fecha[0].day, hour, minute);
        });
        Navigator.pop(context);
      },
      onNegativePressed: (context) {
        Navigator.pop(context);
      },
    );
  }

  Future _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      img = result.files.first;
    });
  }

  Future<void> _horapick(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildCustomTimer(context);
      },
    );
  }

  Future<void> _fechapick(BuildContext context) async {
    var result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: fecha,
    );

    if (result != null && result != fecha) {
      setState(() {
        fecha[0] = DateTime(
          result[0]!.year,
          result[0]!.month,
          result[0]!.day,
          fecha[0].hour,
          fecha[0].minute,
        );
      });
    }
  }
}
