import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:speakly/interceptors/interceptor_initialize.dart';
import 'package:speakly/middleware/constants/app_style.dart';
import 'package:speakly/middleware/extensions/context_extension.dart';
import 'package:speakly/middleware/extensions/icons_image_extension.dart';
import 'package:speakly/middleware/extensions/widget_ext.dart';
import 'package:speakly/models/exercise_models/small_chat_message_model.dart';
import 'package:speakly/store/auth_state/auth_state.dart';
import 'package:speakly/widget/shared/chat_shared_widgets/chat_widgets/chat_widgets.dart';
import 'package:speakly/widget/shared/chat_shared_widgets/chat_widgets/hint_widget.dart';

class SmallChatHumanMessageWidget extends StatelessWidget {
  const SmallChatHumanMessageWidget({
    required this.smallChatMessageModel,
    required this.isLastItem,
    required this.speakAudioLoading,
    required this.speakHumanAudioAiMessage,
  });

  final SmallChatMessageModel smallChatMessageModel;
  final bool isLastItem;
  final bool speakAudioLoading;
  final Function(String, String) speakHumanAudioAiMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, bottom: 20),
        constraints: BoxConstraints(maxWidth: context.width),
        child: Column(children: [
          Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OnlyHumanMessageWidget(message: smallChatMessageModel.value),
                const ChatAvatarWidget(isHuman: false)
              ]),
          Row(children: [
            SpeakMessageIcon(
                isLoading: speakAudioLoading,
                onTap: () => speakHumanAudioAiMessage(
                    smallChatMessageModel.messageId,
                    smallChatMessageModel.fileUrl)).paddingOnly(l: 10)
          ]).paddingOnly(t: 10),
        ]));
  }
}

class OnlyHumanMessageWidget extends StatelessWidget {
  const OnlyHumanMessageWidget({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 3,
                      color: AppStyle.black.withOpacity(.25))
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                color: AppStyle.white),
            alignment: Alignment.centerLeft,
            child: Text(message,
                textAlign: TextAlign.start,
                style: AppStyle.getSfProTextStyle(
                    color: AppStyle.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400))));
  }
}

class SmallChatAiMessage extends StatelessWidget {
  const SmallChatAiMessage({
    required this.smallChatMessageModel,
    required this.speakAudioAiMessage,
    required this.translateAiMessage,
    required this.speakAudioLoading,
    required this.translateLoading,
    Key? key,
  }) : super(key: key);

  final SmallChatMessageModel smallChatMessageModel;
  final void Function(String, String) speakAudioAiMessage;
  final void Function(String) translateAiMessage;
  final bool speakAudioLoading;
  final bool translateLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(right: 20),
        constraints: BoxConstraints(maxWidth: context.width),
        child: Column(children: [
          Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ChatAvatarWidget(isHuman: true),
                OnlyAiMessageWidget(
                    message: smallChatMessageModel.value,
                    messageTranslate: smallChatMessageModel.translateMessage)
              ]),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            SpeakMessageIcon(
                isLoading: speakAudioLoading,
                onTap: () => speakAudioAiMessage(
                    smallChatMessageModel.messageId,
                    smallChatMessageModel.fileUrl)),
            const SizedBox(width: 20),
            TranslateIcon(
                isLoading: translateLoading,
                onTap: () =>
                    translateAiMessage(smallChatMessageModel.messageId)),
          ]).paddingOnly(l: 40, t: 10),
          if (smallChatMessageModel.hintMessage != '')
            SmallChatHintWidget(hintMessage: smallChatMessageModel.hintMessage)
        ])).paddingOnly(b: 25);
  }
}

class OnlyAiMessageWidget extends StatelessWidget {
  const OnlyAiMessageWidget(
      {required this.message, required this.messageTranslate, super.key});

  final String message;
  final String? messageTranslate;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                gradient: AppStyle.aiMessageBackgroundGradient,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      blurRadius: 3,
                      color: AppStyle.black.withOpacity(.25))
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                constraints: BoxConstraints(maxWidth: context.width / 1.6),
                child: Text(message,
                    textAlign: TextAlign.start,
                    style: AppStyle.getSfProTextStyle(
                        color: AppStyle.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              if (messageTranslate != null && messageTranslate != '')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      height: 15,
                      indent: 1,
                      color: AppStyle.white.withOpacity(0.5),
                    ),
                    Row(children: [
                      AppIcons.translateIcon.svg(color: AppStyle.white),
                      Text(
                          'Translation to ${InterceptorInitialize.di<AuthState>().userModel.languageModel?.language}',
                          textAlign: TextAlign.start,
                          style: AppStyle.getSfProTextStyle(
                              color: AppStyle.ghostWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w400))
                    ]),
                    Text(messageTranslate ?? '',
                        textAlign: TextAlign.start,
                        style: AppStyle.getSfProTextStyle(
                            color: AppStyle.ghostWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400))
                  ],
                )
            ])));
  }
}

class SmallChatHintWidget extends StatelessWidget {
  const SmallChatHintWidget({this.hintMessage, super.key});

  final String? hintMessage;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DottedBorder(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          borderType: BorderType.RRect,
          radius: const Radius.circular(5),
          dashPattern: [10, 5],
          strokeWidth: 1,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const HintIcon(),
            HintMessageWidget(hintMessage: 'Say "$hintMessage"')
          ]))
    ]).paddingOnly(l: 50, t: 10);
  }
}
