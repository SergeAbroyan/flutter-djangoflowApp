import 'package:npua_project/components/avatar_image_widget.dart';
import 'package:flutter/widgets.dart';

class NameAvatarWidget extends StatelessWidget {
  const NameAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: const [AvatarWidget(), Text('name')]);
  }
}
