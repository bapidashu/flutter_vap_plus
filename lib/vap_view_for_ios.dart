import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'vap_controller.dart';
import 'vap_view.dart';

class VapViewForIos extends StatelessWidget {
  final void Function(VapController controller) onControllerCreated;
  final VapScaleFit fit;
  final void Function(dynamic event, dynamic arguments)? onEvent;
  final void Function()? onStart;

  VapViewForIos(
      {required this.onControllerCreated,
      required this.fit,
      this.onEvent,
    this.onStart});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'scaleType': fit.name
    };
    return UiKitView(
      viewType: "flutter_vap",
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: StandardMessageCodec(),
      onPlatformViewCreated: (viewId) async {
        // MethodChannel在native端已经同步设置完成，无需延迟
        onControllerCreated(VapController(
          viewId: viewId,
          onEvent: onEvent,
          onStart: onStart,
        ));
      },
    );
  }
}
