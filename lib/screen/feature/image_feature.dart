import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controller/image_controller.dart';
import '../../helper/global.dart';
import '../../widget/custom_btn.dart';
import '../../widget/custom_loading.dart';

class ImageFeature extends StatefulWidget {
  const ImageFeature({super.key});

  @override
  State<ImageFeature> createState() => _ImageFeatureState();
}

class _ImageFeatureState extends State<ImageFeature> {
  final _c = ImageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Classifier'),
        actions: [
          Obx(
            () => _c.status.value == Status.complete
                ? IconButton(
                    padding: const EdgeInsets.only(right: 6),
                    onPressed: () => _showPredictionDialog(_c.prediction),
                    icon: const Icon(Icons.info_outline))
                : const SizedBox(),
          )
        ],
      ),
      floatingActionButton: Obx(() => Padding(
            padding: const EdgeInsets.only(right: 6, bottom: 6),
            child: FloatingActionButton(
              onPressed: _c.takePicture, // 사진을 찍고 바로 분류
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: const Icon(Icons.camera_alt, size: 26), // 카메라 아이콘 추가
            ),
          )),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
            top: mq.height * .02,
            bottom: mq.height * .1,
            left: mq.width * .04,
            right: mq.width * .04),
        children: [
          Container(
              height: mq.height * .5,
              margin: EdgeInsets.symmetric(vertical: mq.height * .015),
              alignment: Alignment.center,
              child: Obx(() => _imageDisplay())),
          CustomBtn(onTap: _c.classifyImage, text: 'Classify Image'),
        ],
      ),
    );
  }

  Widget _imageDisplay() => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: _c.image == null
            ? Lottie.asset('assets/lottie/ai_play.json', height: mq.height * .3)
            : Image.file(_c.image!), // 선택된 이미지 또는 촬영된 이미지를 보여줌
      );

  void _showPredictionDialog(List<double> prediction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Prediction Result"),
          content: Text("Prediction: $prediction"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
