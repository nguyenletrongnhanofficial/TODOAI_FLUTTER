import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todoai_flutter/modules/tasks/add_task.dart';
import '../../pages/login_page.dart';
import '/widgets/add_popup/styles.dart';

import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

/// {@template add__button}
/// Button to add a new [].
///
/// Opens a [HeroDialogRoute] of [_AddPopupCard].
///
/// Uses a [Hero] with tag [_heroAdd].
/// {@endtemplate}
class AddButton extends StatelessWidget {
  /// {@macro add__button}
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(HeroDialogRoute(builder: (context) {
          return _AddPopupCard();
        }));
      },
      child: Hero(
        tag: _heroAdd,
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin, end: end);
        },
        child: Lottie.asset(
          "assets/lotties/add.json",
          height: 80,
          repeat: false,
        ),
      ),
    );
  }
}

/// Tag-value used for the add  popup button.
const String _heroAdd = 'add--hero';

/// {@template add__popup_card}
/// Popup card to add a new []. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAdd].
/// {@endtemplate}
class _AddPopupCard extends StatelessWidget {
  /// {@macro add__popup_card}
  const _AddPopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Hero(
            tag: _heroAdd,
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin, end: end);
            },
            child: Material(
              color: Colors.transparent.withOpacity(0.2),
              child: InkWell(
                  onTap: () {
                    // Xử lý sự kiện onTap, ví dụ: đóng hộp thoại
                    // Navigator.pop(context);
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 70), child: AddTask())),
            )));
    
  }
}
