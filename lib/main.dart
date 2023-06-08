import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageWidget(),
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: FormWidget(),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({
    super.key,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

const String LOGGER_NAME = 'form_app';

enum Investiment { CDBs, FIIs, companyShares, BDRs }

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _raController = TextEditingController();

  static bool isNullOrEmpty(String? value) => value == null || value.isEmpty;

  String? nameValidator(String? value) {
    if (isNullOrEmpty(value)) {
      return 'Nome deve ser informado';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (isNullOrEmpty(value)) {
      return 'E-mail deve ser informado';
    
    } else if (value != null && !value.contains('@gmail.com')) {
        return 'E-mail deve conter "@gmail.com"';
    }
    return null;
  }

  String? raValidator(String? value) {
    const String patttern = r'^\d{10}$';
    RegExp regex = RegExp(patttern);

    if (isNullOrEmpty(value)) {
      return 'RA deve ser informado';
    } else if (value != null) {
      if (value.length != 10 || !regex.hasMatch(value)) {
        return 'RA deve ser informado no formato AASCCCNNND';
      }
    }
    return null;
  }

  void _resetTextFields() {
    _nameController.text = '';
    _emailController.text = '';
    _raController.text = '';
  }

  static const List<String> _areas = <String>[
    'Dev Front-end',
    'Dev Back-end',
    'Ciência de dados',
    'DevOps'
    'Banco de Dados',
    'Infraestrutura e Redes',
    'Agile',
    'UX & UI Design',
    'Atendimento ao cliente',
    'Gerência de projetos',
  ];

  String _selectedArea = _areas[0];

  void _resetArea() {
    _selectedArea = _areas[0];
  }

  static const List<String> _segments = <String>[
    'Agroindustria',
    'Construção Civil',
    'Educação',
    'Manufatura',
  ];

  final List<bool> _selectedSegments = <bool>[false, false, false, false];

  List<String> _getSelectedSegments() {
    List<String> selectedSegments = [];

    _selectedSegments.asMap().forEach((index, value) => {
      if (_selectedSegments[index]) {
        selectedSegments.add(_segments[index])
      }
    });

    return selectedSegments;
  }

  void _resetSegments() {
    _selectedSegments.asMap().forEach((index, value) => _selectedSegments[index] = false);
  }

  bool _isHomeOffice = false;
  bool _isFaceToFace = false;
  bool _isHibrid = false;

  void _selectedHomeOffice(bool value) {
    _isHomeOffice = value;
    _isFaceToFace = false;
    _isHibrid = false;
  }

  void _selectedFaceToFace(bool value) {
    _isFaceToFace = value;
    _isHomeOffice = false;
    _isHibrid = false;
  }

  void _selectedHibrid(bool value) {
    _isHibrid = value;
    _isHomeOffice = false;
    _isFaceToFace = false;
  }

  String _defineWorkModel() {
    if (_isHomeOffice) {
      return 'Home Office';
    }
    else if (_isFaceToFace) {
      return 'Presencial';
    }
    else if (_isHibrid) {
      return 'Híbrido';
    }
    return '';
  }

  void _resetWorkModels() {
    _isHomeOffice = false;
    _isFaceToFace = false;
    _isHibrid = false;
  }

  bool _isPGBLPlan = false;
  bool _isVGBLPlan = false;
  bool _isRetroactive = false;
  bool _isProgressive = false;

  void _selectedPGBLPlan(bool value) {
    _isPGBLPlan = value;
    _isVGBLPlan = false;
  }

  void _selectedVGBLPlan(bool value) {
    _isVGBLPlan = value;
    _isPGBLPlan = false;
  }

  void _selectedRetroactivePlan(bool value) {
    _isRetroactive = value;
    _isProgressive = false;
  }

  void _selectedProgressivePlan(bool value) {
    _isProgressive = value;
    _isRetroactive = false;
  }

  String _definePlan() {
    String plan = '';
    String tax = '';

    if ((_isPGBLPlan == false && _isVGBLPlan == false) || (_isRetroactive == false && _isProgressive == false)) {
      return '';
    }

    if (_isPGBLPlan) {
      plan = 'PGBL';
    } else {
      plan = 'VGBL';
    }
      
    if (_isRetroactive) {
      tax = 'Retroativo';
    } else {
      tax = 'Progressivo';
    }
    
    return '$plan $tax';
  }

  void _resetPlanConfig() {
    _isPGBLPlan = false;
    _isVGBLPlan = false;
    _isRetroactive = false; 
    _isProgressive = false;
  }

  Investiment? _investiment = Investiment.CDBs;

  bool validateFields() {
    if (_selectedSegments.contains(true) && _defineWorkModel() != '' && _definePlan().trim() != '') {
      return true;
    }
    return false;
  }

  Map<String, dynamic> _getFormData() {
    Map<String, dynamic> formData = {};

    formData['name'] = _nameController.text;
    formData['email'] = _emailController.text;
    formData['ra'] = _raController.text;
    
    formData['area'] = _selectedArea;
    formData['segments'] = _getSelectedSegments();

    formData['plan'] = _definePlan();
    formData['workModel'] = _defineWorkModel();
    formData['investiment'] = _investiment.toString();

    return formData;
  }

  void showSnackBarMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.startToEnd,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Confirmar',
          textColor: Colors.blue,
          onPressed: () {
            dev.log('snackBar.action',
                name: LOGGER_NAME);
          },
        ),
        content: Row(
          children: [
            const Icon(
              Icons.info,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(message),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Preencha os campos a seguir',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              TextFormField(
                controller: _nameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                maxLength: 80,
                validator: nameValidator,
              ),

              TextFormField(
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                maxLength: 40,
                validator: emailValidator,
              ),

              TextFormField(
                controller: _raController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  hintText: 'RA',
                  border: OutlineInputBorder(),
                ),
                maxLength: 10,
                validator: raValidator,
              ),

              const Text(
                'Selecione sua área de interesse',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              DropdownButtonFormField(
                value: _selectedArea,
                items: _areas.map((String area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.code),
                        const SizedBox(width: 10,),
                        Text(area)
                      ],
                    ) 
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedArea = value ?? '');
                },
              ),

              const SizedBox(
                  height: 20.0,
              ),

              const Text(
                'Selecione um segmento para atuar:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    _selectedSegments[index] = !_selectedSegments[index];
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.blue[700],
                selectedColor: Colors.white,
                fillColor: Colors.blue[200],
                color: Colors.blue[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedSegments,
                children: _segments
                .map((String periodo) {
                  return Padding(padding: const EdgeInsets.all(12),
                    child: Text(periodo),
                  );
                }).toList(),
              ),

              const Text(
                'Selecione o modelo de trabalho:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              CheckboxListTile(
                value: _isHomeOffice,
                title: const Text('Home Office'),
                subtitle: const Text(
                    '5 dias por semana a distância'),
                secondary: const Icon(Icons.work),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedHomeOffice(value!);
                  });
                },
              ),

              CheckboxListTile(
                value: _isFaceToFace,
                title: const Text('Presencial'),
                subtitle: const Text(
                    '5 dias por semana na empresa'),
                secondary: const Icon(Icons.work),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedFaceToFace(value!);
                  });
                },
              ),

              CheckboxListTile(
                value: _isHibrid,
                title: const Text('Híbrido'),
                subtitle: const Text(
                    '3 dias por semana na empresa e 2 em home office'),
                secondary: const Icon(Icons.work),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedHibrid(value!);
                  });
                },
              ),

              const Text(
                'Selecione o tipo de previdência privada:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              SwitchListTile(
                value: _isPGBLPlan,
                title: const Text('PGBL'),
                subtitle: const Text(
                    'Plano Gerador de Benefício Livre'),
                secondary: const Icon(Icons.timer_sharp),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    _selectedPGBLPlan(value);
                  });
                },
              ),

              SwitchListTile(
                value: _isVGBLPlan,
                title: const Text('VGBL'),
                subtitle: const Text(
                    'Vida Gerador de Benefício Livre'),
                secondary: const Icon(Icons.timer_sharp),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    _selectedVGBLPlan(value);
                  });
                },
              ),

              const Text(
                'Selecione a tributação da previdência privada:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              SwitchListTile(
                value: _isRetroactive,
                title: const Text('Regressiva'),
                subtitle: const Text(
                    'Valor tributado de IR reduzindo com os anos'),
                secondary: const Icon(Icons.timeline_outlined),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    _selectedRetroactivePlan(value);
                  });
                },
              ),

              SwitchListTile(
                value: _isProgressive,
                title: const Text('Progressiva'),
                subtitle: const Text(
                    'Valor tributado de IR referente a 15% do valor total, porém possibilita dedução do IR pago ao longo dos anos'),
                secondary: const Icon(Icons.timeline_outlined),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blue,
                onChanged: (bool value) {
                  setState(() {
                    _selectedProgressivePlan(value);
                  });
                },
              ),

              const Text(
                'Selecione qual será o foco de investimentos do plano:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),

              RadioListTile<Investiment>(
                value: Investiment.CDBs,
                groupValue: _investiment,
                title: const Text('Renda Fixa (CDBs)'),
                secondary: const Icon(Icons.credit_card),
                onChanged: (Investiment? value) {
                  setState(() {
                    _investiment = value;
                  });
                },
              ),

              RadioListTile<Investiment>(
                value: Investiment.FIIs,
                groupValue: _investiment,
                title: const Text('Fundos Imobiliários (FIIs)'),
                secondary: const Icon(Icons.credit_card),
                onChanged: (Investiment? value) {
                  setState(() {
                    _investiment = value;
                  });
                },
              ),

              RadioListTile<Investiment>(
                value: Investiment.companyShares,
                groupValue: _investiment,
                title: const Text('Ações de empresas nacionais'),
                secondary: const Icon(Icons.credit_card),
                onChanged: (Investiment? value) {
                  setState(() {
                    _investiment = value;
                  });
                },
              ),

              RadioListTile<Investiment>(
                value: Investiment.BDRs,
                groupValue: _investiment,
                title: const Text('Ações de empresas estrangeiras (BDRs)'),
                secondary: const Icon(Icons.credit_card),
                onChanged: (Investiment? value) {
                  setState(() {
                    _investiment = value;
                  });
                },
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 30),
                        backgroundColor: Colors.blue),
                      onPressed: () {
                        dev.log('button.confirm', name: LOGGER_NAME);

                        if (_formKey.currentState!.validate() && validateFields()) {
                          var formData = _getFormData();

                          print(formData);

                          showSnackBarMessage(context, 'Dados em processamento...', Colors.black);
                        } else {
                          showSnackBarMessage(context, 'Os campos devem ser preenchidos corretamente', Colors.red);
                        }
                      },
                      child: const Text('Confirmar'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 30),
                        backgroundColor: Colors.black54),
                      onPressed: () {
                        dev.log('button.reset', name: LOGGER_NAME);

                        _formKey.currentState!.reset();

                        setState(() {
                          _resetTextFields();
                          _resetArea();
                          _resetSegments();
                          _resetPlanConfig();
                          _resetWorkModels();
                          _investiment = Investiment.CDBs;
                        });
                      },
                      child: const Text('Limpar'),
                    ),
                  ],
                ),
              ),
            ]
              .map((widget) => Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: widget,
              ))
              .toList(),
          ),
        )
      ),
    );
  }
}