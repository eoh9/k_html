import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({Key? key}) : super(key: key);

  @override
  State<SplashScreen2> createState() => _SplashScreenState2();
}

class _SplashScreenState2 extends State<SplashScreen2> {
  static const String _loadingImage = 'assets/images/loading_page.png';
  static const String _backgroundImage = 'assets/images/background_page1.png';
  String _currentBackgroundImage = _loadingImage;
  late final Box _surveyBox;

  @override
  void initState() {
    super.initState();
    _initializeSurvey();
  }

  Future<void> _initializeSurvey() async {
    _surveyBox = Hive.box('surveyBox');
    // 2초 대기 후 화면 실행.
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _currentBackgroundImage = _backgroundImage);
    _showSurveyDialog();
  }

  void _showSurveyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => _HistoryInterestDialog(
        onComplete: _showFoodPreferenceDialog,
      ),
    );
  }

  void _showFoodPreferenceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => _FoodPreferenceDialog(
        onBack: _showSurveyDialog,
        onComplete: _showAllergyDialog,
      ),
    );
  }

  void _showAllergyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (_) => _AllergyDialog(
        onBack: _showFoodPreferenceDialog,
        onComplete: () {
          // Navigate to next screen or perform final action
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_currentBackgroundImage),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _SurveyDialogWrapper extends StatelessWidget {
  final Widget child;

  const _SurveyDialogWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _SurveyHeader(),
        Align(
          alignment: Alignment.topCenter,
          child: Dialog(
            insetPadding: const EdgeInsets.only(top: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _SurveyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.17,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, -35),
              child: Image.asset(
                'assets/images/survey_dragon.png',
                width: 110.0,
                height: 110.0,
              ),
            ),
            const SizedBox(width: 10),
            Transform.translate(
              offset: const Offset(-25, -5),
              child: const Text(
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
    );
  }
}

class _HistoryInterestDialog extends StatefulWidget {
  final VoidCallback onComplete;

  const _HistoryInterestDialog({Key? key, required this.onComplete}) : super(key: key);

  @override
  _HistoryInterestDialogState createState() => _HistoryInterestDialogState();
}

class _HistoryInterestDialogState extends State<_HistoryInterestDialog> {
  int _selectedOption = 0;
  final Box _surveyBox = Hive.box('surveyBox');

  @override
  Widget build(BuildContext context) {
    return _SurveyDialogWrapper(
      child: Column(
        children: [
          const Text(
            '역사에 대한 관심도는\n\t어느정도 이신가요?',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildRadioListTile('잘 모르겠습니다.', 1),
                _buildRadioListTile('보통 일반인 수준입니다.', 2),
                _buildRadioListTile('아주 잘 합니다.', 3),
              ],
            ),
          ),
          _NextButton(onPressed: widget.onComplete),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(String title, int value) {
    return ListTile(
      title: Text(title),
      leading: Radio<int>(
        value: value,
        groupValue: _selectedOption,
        onChanged: (int? newValue) {
          setState(() => _selectedOption = newValue!);
          _surveyBox.put('historyInterest', newValue);
        },
      ),
    );
  }
}

class _FoodPreferenceDialog extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const _FoodPreferenceDialog({
    Key? key,
    required this.onBack,
    required this.onComplete,
  }) : super(key: key);

  @override
  _FoodPreferenceDialogState createState() => _FoodPreferenceDialogState();
}

class _FoodPreferenceDialogState extends State<_FoodPreferenceDialog> {
  final List<String> _selectedFood = [];
  final List<String> _selectedDrink = [];
  final Box _surveyBox = Hive.box('surveyBox');

  @override
  Widget build(BuildContext context) {
    return _SurveyDialogWrapper(
      child: Column(
        children: [
          const Text(
            '좋아하는 음식과 음료의\n\t\t종류를 선택해주세요.',
            style: TextStyle(fontSize: 18),
          ),
          Expanded(
            child: Column(
              children: [
                _buildPreferenceGrid(
                  ["한식", "양식", "중식", "일식"],
                  _selectedFood,
                  'food',
                ),
                const Divider(thickness: 1, color: Colors.grey),
                _buildPreferenceGrid(
                  ["커피류", "생과일주스", "따뜻한 차", "스무디"],
                  _selectedDrink,
                  'drink',
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BackButton(onPressed: widget.onBack),
              _NextButton(onPressed: widget.onComplete),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceGrid(List<String> items, List<String> selectedItems, String key) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 1.5,
        crossAxisSpacing: 15,
        mainAxisSpacing: 20,
        padding: const EdgeInsets.all(10),
        children: items.map((item) => _buildPreferenceItem(item, selectedItems, key)).toList(),
      ),
    );
  }

  Widget _buildPreferenceItem(String item, List<String> selectedItems, String key) {
    final bool isSelected = selectedItems.contains(item);
    return InkWell(
      onTap: () => _toggleSelection(item, selectedItems, key),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Center(
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.green : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSelection(String item, List<String> selectedItems, String key) {
    setState(() {
      if (selectedItems.contains(item)) {
        selectedItems.remove(item);
      } else {
        selectedItems.add(item);
      }
      _surveyBox.put(key, selectedItems);
    });
  }
}

class _AllergyDialog extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onComplete;

  const _AllergyDialog({
    Key? key,
    required this.onBack,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController allergyController = TextEditingController();
    final Box surveyBox = Hive.box('surveyBox');

    return _SurveyDialogWrapper(
      child: Column(
        children: [
          const Text(
            '못 먹거나 알러지 있는 음식\n\t\t\t\t\t\t\t있으면 알려주세요.',
            style: TextStyle(fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: allergyController,
              decoration: const InputDecoration(
                hintText: '여기에 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BackButton(onPressed: onBack),
              _SubmitButton(
                onPressed: () {
                  surveyBox.put('allergies', allergyController.text);
                  onComplete();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _NextButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 65.0,
      icon: Image.asset(
        'assets/images/next_dragon.png',
        fit: BoxFit.contain,
      ),
      onPressed: onPressed,
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 23.0),
      child: IconButton(
        iconSize: 100.0,
        icon: Image.asset(
          'assets/images/before_dragon.png',
          fit: BoxFit.contain,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, right: 15.0),
      child: IconButton(
        iconSize: 118,
        icon: Image.asset(
          'assets/images/submit_dragon.png',
          fit: BoxFit.contain,
        ),
        onPressed: onPressed,
      ),
    );
  }
}