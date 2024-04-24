import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:speakly/blocs/map_bloc/exercise_bloc/exercise_bloc.dart';
import 'package:speakly/blocs/map_bloc/exercise_bloc/exercise_event.dart';
import 'package:speakly/blocs/map_bloc/exercise_bloc/exercise_state.dart';
import 'package:speakly/interceptors/interceptor_initialize.dart';
import 'package:speakly/middleware/constants/app_style.dart';
import 'package:speakly/middleware/extensions/widget_ext.dart';
import 'package:speakly/middleware/mixins/after_layout_mixin.dart';
import 'package:speakly/middleware/route/app_route.dart';
import 'package:speakly/middleware/route/route_names.dart';
import 'package:speakly/middleware/typedef/typedef.dart';
import 'package:speakly/models/exercise_models/map_models/exercise_model.dart';
import 'package:speakly/store/auth_state/auth_state.dart';

class ExerciseMainScreen extends StatefulWidget {
  const ExerciseMainScreen({super.key});

  @override
  State<ExerciseMainScreen> createState() => _ExerciseMainScreenState();
}

class _ExerciseMainScreenState extends State<ExerciseMainScreen>
    with AfterLayoutMixin {
  final _exerciseBloc = InterceptorInitialize.di<ExerciseBloc>();

  @override
  void afterFirstLayout(BuildContext context) {
    _exerciseBloc
      ..add(GetAllExerciseEvent())
      ..add(GetAllExercisePromptModelEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _exerciseBloc,
        child: BlocConsumer<ExerciseBloc, ExerciseState>(
            listener: _listener,
            bloc: _exerciseBloc,
            builder: (context, state) => Scaffold(
                backgroundColor: AppStyle.ghostWhite,
                body: SafeArea(
                    child: Stack(alignment: Alignment.topRight, children: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: ListView.builder(
                          reverse: true,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 40, bottom: 40),
                          shrinkWrap: true,
                          itemCount: _exerciseBloc.exerciseModelList.length,
                          itemBuilder: (context, index) => index % 2 == 0
                              ? Observer(
                                  builder: (context) => ExerciseRightItemWidget(
                                      isPayed:
                                          InterceptorInitialize.di<AuthState>()
                                              .isPayed,
                                      isDoneIndex: _exerciseBloc.doneIndex,
                                      indexCallBack: (id) => _exerciseBloc.add(
                                          GetExerciseInformationModelEvent(
                                              exerciseId: id,
                                              index: index + 1)),
                                      exerciseModel: _exerciseBloc
                                          .exerciseModelList[index],
                                      index: index + 1,
                                      count: _exerciseBloc
                                          .exerciseModelList.length))
                              : Observer(builder: (context) => ExerciseLeftItemWidget(isPayed: InterceptorInitialize.di<AuthState>().isPayed, isDoneIndex: _exerciseBloc.doneIndex, indexCallBack: (id) => _exerciseBloc.add(GetExerciseInformationModelEvent(exerciseId: id, index: index + 1)), exerciseModel: _exerciseBloc.exerciseModelList[index], index: index + 1, count: _exerciseBloc.exerciseModelList.length)))),
                  Container(
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: const BoxDecoration(
                          color: AppStyle.lightOrange,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text('Beta',
                          style: AppStyle.getPoppinsTextStyle(
                              fontSize: 20, color: AppStyle.white)))
                ])))));
  }

  Future<void> _listener(BuildContext context, ExerciseState state) async {
    if (state is GetExerciseInformationModelState) {
      await router.push(RouteNames.exerciseProgressScreen);
    }
  }
}

class ExerciseRightItemWidget extends StatelessWidget {
  const ExerciseRightItemWidget(
      {required this.exerciseModel,
      required this.index,
      required this.count,
      required this.indexCallBack,
      required this.isDoneIndex,
      required this.isPayed,
      super.key});

  final ExerciseModel exerciseModel;
  final int index;
  final int count;
  final StringCallBack indexCallBack;
  final int isDoneIndex;
  final bool isPayed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!isPayed) {
            router.push(RouteNames.paymentLogin);
          } else if (isDoneIndex + 1 == index) {
            indexCallBack.call(exerciseModel.id);
          }
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            ExerciseImageWidget(
              imageUrl: exerciseModel.image_url,
              isShadow: isPayed && isDoneIndex + 1 == index,
              isGrayFilter: isPayed && isDoneIndex + 1 >= index,
            ),
            Text(exerciseModel.name,
                textAlign: TextAlign.center,
                style: AppStyle.getPoppinsTextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600))
          ]),
          Row(
            crossAxisAlignment: index == 1
                ? CrossAxisAlignment.start
                : index == count
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.center,
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: index == 1 ? 69 : 0,
                      bottom: index == count ? 69 : 0),
                  height: 3,
                  width: 30,
                  color: isDoneIndex >= index
                      ? AppStyle.blueMagentaViolet
                      : AppStyle.greyD9),
              Container(
                margin: EdgeInsets.only(
                    top: index == count ? 69 : 0, bottom: index == 1 ? 69 : 0),
                height: index == 1 || index == count ? 72 : 120,
                width: 3,
                color: isDoneIndex >= index
                    ? AppStyle.blueMagentaViolet
                    : AppStyle.greyD9,
              ),
            ],
          ).paddingOnly(l: 20)
        ])).paddingOnly(r: 160);
  }
}

class ExerciseLeftItemWidget extends StatelessWidget {
  const ExerciseLeftItemWidget(
      {required this.exerciseModel,
      required this.index,
      required this.count,
      required this.indexCallBack,
      required this.isDoneIndex,
      required this.isPayed,
      super.key});

  final ExerciseModel exerciseModel;
  final int index;
  final int count;
  final StringCallBack indexCallBack;
  final int isDoneIndex;
  final bool isPayed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (!isPayed) {
            router.push(RouteNames.paymentLogin);
          } else if (isDoneIndex + 1 == index) {
            indexCallBack.call(exerciseModel.id);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: index == count
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: index == count ? 0 : 0),
                  height: index == count ? 200 : 120,
                  width: 3,
                  color: isDoneIndex >= index
                      ? AppStyle.blueMagentaViolet
                      : AppStyle.greyD9,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: index == count ? 69 : 0),
                  height: 3,
                  width: 30,
                  color: isDoneIndex >= index
                      ? AppStyle.blueMagentaViolet
                      : AppStyle.greyD9,
                ),
              ],
            ).paddingOnly(r: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              ExerciseImageWidget(
                imageUrl: exerciseModel.image_url,
                isShadow: isPayed && isDoneIndex + 1 == index,
                isGrayFilter: isPayed && isDoneIndex + 1 >= index,
              ),
              Text(exerciseModel.name,
                  textAlign: TextAlign.center,
                  style: AppStyle.getPoppinsTextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600))
            ]).paddingOnly(t: index == count ? 50 : 0)
          ],
        )).paddingOnly(l: 160);
  }
}

class ExerciseImageWidget extends StatelessWidget {
  const ExerciseImageWidget(
      {required this.imageUrl,
      required this.isShadow,
      required this.isGrayFilter,
      super.key});

  final String imageUrl;
  final bool isShadow;
  final bool isGrayFilter;

  final _greyMode = const ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            if (isShadow)
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 7,
                  color: AppStyle.purple.withOpacity(0.5))
          ],
          color: AppStyle.azureishWhite,
          shape: BoxShape.circle,
          border: Border.all(color: AppStyle.white, width: 5)),
      child: CachedNetworkImage(
          width: 100,
          height: 94,
          fit: BoxFit.contain,
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: isGrayFilter ? null : _greyMode,
                      image: CachedNetworkImageProvider(imageUrl),
                      fit: BoxFit.contain))),
          progressIndicatorBuilder: (context, url, progress) => Container(
                width: 100,
                height: 94,
                decoration: BoxDecoration(
                    color: AppStyle.azureishWhite,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppStyle.white, width: 5)),
              )),
    );
  }
}
