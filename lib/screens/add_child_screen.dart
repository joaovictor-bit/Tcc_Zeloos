import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../utils/validators.dart';
import '../widgets/widgets.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});
  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(), _date = TextEditingController(), _code = TextEditingController();
  DateTime? _birth;

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: DateTime.now().subtract(const Duration(days: 365 * 8)),
        firstDate: DateTime(2005), lastDate: DateTime.now());
    if (d != null) setState(() { _birth = d; _date.text = Validators.fmtDate(d); });
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    // TODO(integração): validar o código de vinculação no backend e exigir consentimento
    // do dispositivo da criança antes de compartilhar a localização.
    AppController.I.addChild(_name.text.trim(), _birth!, _code.text.trim());
    Navigator.pop(context);
    showSnack(context, 'Criança adicionada com sucesso');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: zAppBar('Adicionar criança'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(key: _form, child: Column(children: [
            GestureDetector(
              // TODO(integração): image_picker + upload para storage.
              onTap: () => showSnack(context, 'Seleção de foto será integrada (image_picker).'),
              child: const CircleAvatar(radius: 44, child: Icon(Icons.add_a_photo_outlined, size: 32)),
            ),
            const SizedBox(height: 24),
            ZField(controller: _name, label: 'Nome completo', icon: Icons.person_outline, validator: (v) => Validators.required(v, 'Nome')),
            const SizedBox(height: 14),
            ZField(controller: _date, label: 'Data de nascimento', icon: Icons.cake_outlined, readOnly: true, onTap: _pickDate,
                validator: (v) => Validators.required(v, 'Data de nascimento')),
            const SizedBox(height: 14),
            ZField(controller: _code, label: 'Código de vinculação / ID do dispositivo', icon: Icons.qr_code,
                validator: (v) => (v == null || v.trim().length < 4) ? 'Informe um código válido' : null),
            const SizedBox(height: 24),
            ZButton('Adicionar criança', onPressed: _save),
          ])),
        ),
      );
}
