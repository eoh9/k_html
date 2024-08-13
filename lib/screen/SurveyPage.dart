import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'ChatPage.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<int> _selectedServices = [];

  final List<ServiceOption> _serviceOptions = const [
    ServiceOption(icon: 'assets/icons/hearing.png', label: '청각 서비스'),
    ServiceOption(icon: 'assets/icons/visual.png', label: '시각 서비스'),
    ServiceOption(icon: 'assets/icons/wheelchair.png', label: '휠체어 서비스'),
    ServiceOption(icon: 'assets/icons/elder.png', label: '고령자 서비스'),
    ServiceOption(icon: 'assets/icons/child.png', label: '영유아 서비스'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.teal.shade100, Colors.teal.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildServiceSelection(),
                const SizedBox(height: 15),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '더 좋은 서비스를 제공하기 위해\n간단한 설문을 진행하겠습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '필요한 서비스를 선택해 주세요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _serviceOptions
                    .sublist(0, 3)
                    .map((option) => _buildServiceOption(option))
                    .toList(),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  ..._serviceOptions
                      .sublist(3)
                      .map((option) =>
                      Expanded(child: _buildServiceOption(option)))
                      .toList(),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOption(ServiceOption option) {
    bool isSelected =
    _selectedServices.contains(_serviceOptions.indexOf(option));
    return GestureDetector(
      onTap: () {
        setState(() {
          int index = _serviceOptions.indexOf(option);
          if (isSelected) {
            _selectedServices.remove(index);
          } else {
            _selectedServices.add(index);
          }
        });
      },
      child: Semantics(
        selected: isSelected,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : const Color(0xFF4CFAD0),
                border: Border.all(
                  color: const Color(0xFF4CFAD0),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                option.icon,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              option.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.teal : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_selectedServices.isNotEmpty) {
              _saveSelectedServices();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatbotScreen()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('적어도 하나의 서비스를 선택해 주세요.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            minimumSize: const Size(90, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text(
            '완료 >',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _saveSelectedServices() async {
    final box = await Hive.openBox('selectedServicesBox');
    await box.put('selectedServices', _selectedServices);
    await box.close();
  }
}

class ServiceOption {
  final String icon;
  final String label;

  const ServiceOption({required this.icon, required this.label});
}