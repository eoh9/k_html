import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<int> _selectedServices = [];  // 여러 선택을 관리하는 리스트

  final List<ServiceOption> _serviceOptions = [
    ServiceOption(icon: 'assets/icons/hearing.png', label: '청각 서비스'),
    ServiceOption(icon: 'assets/icons/sign_language.png', label: '시각 서비스'),
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center, // 세로 축에서 가운데 정렬
              children: [
                _buildHeaderText(),
                const SizedBox(height: 20),
                _buildServiceSelection(),
                const SizedBox(height: 20),
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
      height: 100, // 높이 조정
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
            blurRadius: 6, // 그림자의 흐림 정도
            offset: Offset(0, 3), // 그림자의 위치
          ),
        ],
      ),
      child: const Center( // 텍스트를 중앙에 배치
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
      height: 300, // 높이 조정
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
            blurRadius: 6, // 그림자의 흐림 정도
            offset: Offset(0, 3), // 그림자의 위치
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // stretch를 통해 텍스트가 가운데 정렬되도록 설정
        children: [
          const Text(
            '필요한 서비스를 선택해 주세요.',
            textAlign: TextAlign.center, // 텍스트를 가운데 정렬
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _serviceOptions.sublist(0, 3).map((option) => _buildServiceOption(option)).toList(),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  ..._serviceOptions.sublist(3).map((option) => Expanded(child: _buildServiceOption(option))).toList(),
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
    bool isSelected = _selectedServices.contains(_serviceOptions.indexOf(option));
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
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? Colors.teal : Colors.white,
              border: Border.all(
                color: Colors.teal,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 그림자 색상과 투명도
                  blurRadius: 6, // 그림자의 흐림 정도
                  offset: Offset(0, 3), // 그림자의 위치
                ),
              ],
            ),
            child: Image.asset(
              option.icon,
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            option.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold, // 아이콘 아래의 글자를 볼드체로 변경
              color: isSelected ? Colors.teal : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight, // 오른쪽 정렬
      child: Container(
        height: 50, // 높이 조정
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // 그림자 색상과 투명도
              blurRadius: 6, // 그림자의 흐림 정도
              offset: Offset(0, 3), // 그림자의 위치
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_selectedServices.isNotEmpty) {
              // 선택한 항목을 Hive에 저장
              var box = Hive.box('selectedServicesBox');
              box.put('selectedServices', _selectedServices);

              // 다음 화면으로 이동 (여기에 원하는 동작을 추가하세요)
              print("선택한 서비스가 저장되었습니다: $_selectedServices");
            } else {
              // 선택하지 않았을 때 경고 메시지 표시 (Snackbar)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('적어도 하나의 서비스를 선택해 주세요.'),
                  duration: Duration(seconds: 2), // 2초간 표시
                ),
              );
            }
          },
          child: const Text(
            '완료 >',
            style: TextStyle(color: Colors.black), // 글씨 색을 검은색으로 변경
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // 박스 배경색을 흰색으로 변경
            padding: const EdgeInsets.symmetric(vertical: 15),
            minimumSize: Size(90, 50), // 버튼의 최소 크기를 지정
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // 직각 네모로 변경
            ),
          ),
        ),
      ),
    );
  }
}

class ServiceOption {
  final String icon;
  final String label;

  ServiceOption({required this.icon, required this.label});
}
