import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});
  @override
  State<SplashScreen2> createState() => _SplashScreenState2();
}

class _SplashScreenState2 extends State<SplashScreen2> {
  int selectedOption = 0;
  String backgroundImage = 'assets/images/loading_page.png'; // 초기 배경 이미지 설정
  late Box surveyBox;

  // 선택된 항목을 저장할 리스트
  List<String> selectedFood = [];
  List<String> selectedDrink = [];

  @override
  void initState() {
    super.initState();
    surveyBox = Hive.box('surveyBox');
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        backgroundImage =
            'assets/images/background_page1.png'; // 2초 후 배경 이미지 변경
      });
      _showSurveyDialog();
    });
  }

  void _showSurveyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.17,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -35), // y축 방향으로 10픽셀 위로 이동
                      child: Image.asset(
                        'assets/images/survey_dragon.png',
                        width: 110.0,
                        height: 110.0,
                      ),
                    ),
                    SizedBox(width: 10),
                    Transform.translate(
                      offset: Offset(-25, -5),
                      child: Text(
                        '더 좋은 서비스를 제공하기 위해 간단한\n\t\t\t\t\t\t\t설문을 진행하겠다용',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.2,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Dialog(
                insetPadding: EdgeInsets.only(top: 20),
                child: Container(
                  width: width * 0.85,
                  height: height * 0.4,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          '역사에 대한 관심도는\n\t어느정도 이신가요?',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Expanded(
                        child: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return ListView(
                              children: [
                                ListTile(
                                  title: const Text('잘 모르겠습니다.'),
                                  leading: Radio(
                                    value: 1,
                                    groupValue: selectedOption,
                                    onChanged: (int? value) {
                                      setState(() => selectedOption = value!);
                                      surveyBox.put('historyInterest', 1); //surveyBox.get로 다른 클래스에서 반환 가능
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('보통 일반인 수준입니다.'),
                                  leading: Radio(
                                    value: 2,
                                    groupValue: selectedOption,
                                    onChanged: (int? value) {
                                      setState(() => selectedOption = value!);
                                      surveyBox.put('historyInterest', 2);
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('아주 잘 합니다.'),
                                  leading: Radio(
                                    value: 3,
                                    groupValue: selectedOption,
                                    onChanged: (int? value) {
                                      setState(() => selectedOption = value!);
                                      surveyBox.put('historyInterest', 3);
                                    },
                                  ),
                                ),
                                IconButton(
                                  iconSize: 65.0,
                                  icon: Image.asset(
                                    'assets/images/next_dragon.png',
                                    fit: BoxFit.contain,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showSecondDialog();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSecondDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.17,
                  left: 0,
                  right: 0,
                  child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -35), // y축 방향으로 10픽셀 위로 이동
                      child: Image.asset(
                        'assets/images/survey_dragon.png',
                        width: 110.0,
                        height: 110.0,
                      ),
                    ),
                    SizedBox(width: 10),
                    Transform.translate(
                      offset: Offset(-25, -5),
                      child: Text(
                        '더 좋은 서비스를 제공하기 위해 간단한\n\t\t\t\t\t\t\t설문을 진행하겠다용',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.2,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Dialog(
                    insetPadding: EdgeInsets.only(top: 20),
                    child: Container(
                      width: width * 0.85,
                      height: height * 0.4, // 크기를 조절하였습니다
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '좋아하는 음식과 음료의\n\t\t종류를 선택해주세요.',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 4, // 한 행에 4개의 항목 배치
                                    childAspectRatio:
                                        1.5, // 항목의 가로세로 비율을 1.5로 설정
                                    crossAxisSpacing: 15, // 항목 간의 가로 방향 여백
                                    mainAxisSpacing: 20, // 항목 간의 세로 방향 여백
                                    padding: EdgeInsets.all(10),
                                    children: List.generate(4, (index) {
                                      String food =
                                          ["한식", "양식", "중식", "일식"][index];
                                      bool isSelected =
                                          selectedFood.contains(food);
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedFood.remove(food);
                                            } else {
                                              selectedFood.add(food);
                                            }
                                            surveyBox.put('food', selectedFood);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.green[100]
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: isSelected
                                                ? Border.all(
                                                    color: Colors.green,
                                                    width: 2)
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              food,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 1.0,
                                      bottom: 1.0),
                                  child: Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 4, // 한 행에 4개의 항목 배치
                                    childAspectRatio:
                                        1.5, // 항목의 가로세로 비율을 1.5로 설정
                                    crossAxisSpacing: 15, // 항목 간의 가로 방향 여백
                                    mainAxisSpacing: 20, // 항목 간의 세로 방향 여백
                                    padding: EdgeInsets.all(10),
                                    children: List.generate(4, (index) {
                                      String drink = [
                                        "커피류",
                                        "생과일주스",
                                        "따뜻한 차",
                                        "스무디"
                                      ][index];
                                      bool isSelected =
                                          selectedDrink.contains(drink);
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedDrink.remove(drink);
                                            } else {
                                              selectedDrink.add(drink);
                                            }
                                            surveyBox.put('drink', selectedDrink);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.green[100]
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: isSelected
                                                ? Border.all(
                                                    color: Colors.green,
                                                    width: 2)
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              drink,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                color: isSelected
                                                    ? Colors.green
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    iconSize: 99.0,
                                    icon: Image.asset(
                                      'assets/images/before_dragon.png',
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog and return to the first dialog
                                      _showSurveyDialog();
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 108.0,
                                    icon: Image.asset(
                                      'assets/images/next_dragon.png',
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context); // 현재 대화창 닫기
                                      _showThirdDialog(); // 새로운 대화창 열기
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

void _showThirdDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        TextEditingController allergyController = TextEditingController();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.17,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: Offset(0, -35), // y축 방향으로 10픽셀 위로 이동
                          child: Image.asset(
                            'assets/images/survey_dragon.png',
                            width: 110.0,
                            height: 110.0,
                          ),
                        ),
                        SizedBox(width: 10),
                        Transform.translate(
                          offset: Offset(-25, -5),
                          child: Text(
                            '더 좋은 서비스를 제공하기 위해 간단한\n\t\t\t\t\t\t\t설문을 진행하겠다용',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.2,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Dialog(
                    insetPadding: EdgeInsets.only(top: 20),
                    child: Container(
                      width: width * 0.85,
                      height: height * 0.4,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '못 먹거나 알러지 있는 음식\n\t\t\t\t\t\t\t있으면 알려주세요.',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              controller: allergyController,
                              decoration: InputDecoration(
                                hintText: '여기에 입력하세요',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 5.0,
                                  left: 23.0,
                                ),
                                child: IconButton(
                                  iconSize: 100.0,
                                  icon: Image.asset(
                                    'assets/images/before_dragon.png',
                                    fit: BoxFit.contain,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _showSecondDialog();
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 5.0,
                                  right: 15.0,
                                ),
                                child: IconButton(
                                  iconSize: 118,
                                  icon: Image.asset(
                                    'assets/images/submit_dragon.png',
                                    fit: BoxFit.contain,
                                  ),
                                  onPressed: () {
                                    surveyBox.put('allergies', allergyController.text); // 여기서 사용자 입력을 저장
                                    Navigator.pop(context); // 현재 대화창 닫기
                                    // 여기서 다음 페이지로 이동하는 로직을 추가하세요
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
