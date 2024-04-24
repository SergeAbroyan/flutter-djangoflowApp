import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:speakly/blocs/map_bloc/exercise_bloc/exercise_bloc.dart';
import 'package:speakly/blocs/map_bloc/exercise_bloc/exercise_state.dart';
import 'package:speakly/interceptors/interceptor_initialize.dart';
import 'package:speakly/middleware/constants/app_style.dart';
import 'package:speakly/middleware/extensions/widget_ext.dart';
import 'package:speakly/middleware/route/app_route.dart';
import 'package:speakly/middleware/route/route_names.dart';
import 'package:speakly/models/exercise_models/map_models/exercise_information_model.dart';
import 'package:speakly/store/auth_state/auth_state.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/choose_right_word_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/create_sentence_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/grammar_lesson_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/learn_word_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/repeat_sentence_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/repeat_word_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/small_chat_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/translate_sentence_screen.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/translate_word_screen.dart';
import 'package:speakly/widget/shared/cancel_button.dart';
import 'package:speakly/widget/shared/centered_button.dart';

class ExerciseProgressScreen extends StatefulWidget {
  const ExerciseProgressScreen({super.key});

  @override
  State<ExerciseProgressScreen> createState() => _ExerciseProgressScreenState();
}

class _ExerciseProgressScreenState extends State<ExerciseProgressScreen>
    with SingleTickerProviderStateMixin {
  final _exerciseBloc = InterceptorInitialize.di<ExerciseBloc>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _exerciseBloc,
        child: BlocConsumer<ExerciseBloc, ExerciseState>(
            listener: _listener,
            bloc: _exerciseBloc,
            builder: (context, state) => Scaffold(
                  body: Container(
                    decoration: BoxDecoration(
                        gradient: AppStyle.exerciseBackgroundGradient),
                    child: SafeArea(
                        child: Column(
                      children: [
                        if (_exerciseBloc
                                .exerciseInformationList[
                                    _exerciseBloc.selectedIndex]
                                .exerciseTypeEnum !=
                            ExerciseTypeEnum.grammarLesson)
                          ExercisesAppBarWidgets(
                            maxValue:
                                _exerciseBloc.exerciseInformationList.length,
                            currentValue: _exerciseBloc.selectedIndex,
                            animationController: _animationController,
                          ),
                        if (_exerciseBloc
                                .exerciseInformationList[
                                    _exerciseBloc.selectedIndex]
                                .exerciseTypeEnum ==
                            ExerciseTypeEnum.grammarLesson)
                          GestureDetector(
                              onTap: () => router.pop(),
                              child: Container(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 20),
                                  alignment: Alignment.centerLeft,
                                  child: const Icon(
                                      Icons.arrow_back_ios_new_sharp,
                                      color: AppStyle.lightGray))),
                        ExercisesWidgets(
                            exerciseInformationModel:
                                _exerciseBloc.exerciseInformationList,
                            selectedIndex: _exerciseBloc.selectedIndex),
                      ],
                    )),
                  ),
                )));
  }

  Future<void> _listener(BuildContext context, ExerciseState state) async {
    if (state is ChangeExerciseFinishState) {
      await _showUserFeedbackDialog();
      await router.push(RouteNames.exerciseFeedbackScreen);
    }
  }

  Future<void> _showUserFeedbackDialog() async {
    final response = await FirebaseFirestore.instance
        .collection('usersFeedbackMap')
        .doc(InterceptorInitialize.di<AuthState>().userModel.userId)
        .get();

    final result = response.data();
    if (result == null) {
      var rate = 0.0;
      final textEditingController = TextEditingController();

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
                elevation: 0,
                contentPadding: EdgeInsets.zero,
                titlePadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                iconPadding: EdgeInsets.zero,
                content: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                          alignment: Alignment.centerRight,
                          child: const CancelButton()),
                      Text('How would you rate your experience?',
                              textAlign: TextAlign.center,
                              style: AppStyle.getPoppinsTextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppStyle.raisinBlack))
                          .paddingOnly(b: 20),
                      RatingBar(
                          itemSize: 45,
                          initialRating: rate,
                          allowHalfRating: true,
                          itemCount: 5,
                          ratingWidget: RatingWidget(
                              full: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    const RadialGradient(
                                        center: Alignment.topCenter,
                                        stops: [
                                      .5,
                                      1
                                    ],
                                        colors: [
                                      Color.fromRGBO(252, 214, 53, 1),
                                      Color.fromRGBO(247, 169, 40, 1)
                                    ]).createShader(bounds),
                                child: const Icon(Icons.star_rate_rounded),
                              ),
                              half: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) =>
                                    const RadialGradient(
                                        center: Alignment.topCenter,
                                        stops: [
                                      .5,
                                      1
                                    ],
                                        colors: [
                                      Color.fromRGBO(252, 214, 53, 1),
                                      Color.fromRGBO(247, 169, 40, 1)
                                    ]).createShader(bounds),
                                child: const Icon(Icons.star_half_rounded),
                              ),
                              empty: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) =>
                                      const RadialGradient(
                                          center: Alignment.topCenter,
                                          stops: [
                                            .5,
                                            1
                                          ],
                                          colors: [
                                            AppStyle.borderGray,
                                            AppStyle.borderGray
                                          ]).createShader(bounds),
                                  child: const Icon(Icons.star_rate_rounded))),
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          onRatingUpdate: (rating) {
                            setState(() {
                              rate = rating;
                            });
                          }),
                      TextFormField(
                              minLines: 4,
                              maxLines: 10,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  hintText:
                                      'MapScreens.Tell us what we can improve'
                                          .tr()
                                          .tr(),
                                  hintStyle: AppStyle.getPoppinsTextStyle()))
                          .paddingOnly(b: 20, t: 20),
                      Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: CenteredButtonWidget(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection('usersFeedbackMap')
                                    .doc(InterceptorInitialize.di<AuthState>()
                                        .userModel
                                        .userId)
                                    .set({
                                  'rate': rate,
                                  'feedback': textEditingController.text
                                });

                                Navigator.pop(context);
                              },
                              title: 'Submit',
                              width: double.infinity))
                    ])));
          });
    }
  }
}

class ExercisesAppBarWidgets extends StatelessWidget {
  const ExercisesAppBarWidgets(
      {required this.maxValue,
      required this.currentValue,
      required this.animationController,
      super.key});

  final int maxValue;
  final int currentValue;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, top: 5),
      child: Row(
        children: [
          const CancelButton(),
          Expanded(
              child: AnimatedBuilder(
                  animation: animationController,
                  builder: (_, __) {
                    return SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.white,
                        trackHeight: 10,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withAlpha(1),
                      ),
                      child: Slider(
                        value: currentValue.toDouble(),
                        min: 0,
                        max: maxValue.toDouble(),
                        onChanged: (double value) {},
                        activeColor: AppStyle.blueMagentaViolet,
                        inactiveColor: AppStyle.white,
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

class ExercisesWidgets extends StatelessWidget {
  const ExercisesWidgets(
      {required this.exerciseInformationModel,
      required this.selectedIndex,
      super.key});

  final List<ExerciseInformationAbstractModel> exerciseInformationModel;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    switch (exerciseInformationModel[selectedIndex].exerciseTypeEnum) {
      case ExerciseTypeEnum.repeatSentence:
        return RepeatSentenceScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.learnWord:
        return LearnWordScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.translateSentences:
        return TranslateSentenceScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.createSentence:
        return CreateSentenceScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.smallChat:
        return SmallChatScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.grammarLesson:
        return GrammarLessonScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.repeatWord:
        return RepeatWordScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.translateWord:
        return TranslateWordScreen(key: ValueKey(selectedIndex));
      case ExerciseTypeEnum.chooseRightWord:
        return ChooseRightWordScreen(key: ValueKey(selectedIndex));
    }
  }
}
