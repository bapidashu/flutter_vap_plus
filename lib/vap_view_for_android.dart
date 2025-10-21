import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'vap_controller.dart';
import 'vap_view.dart';

class VapViewForAndroid extends StatelessWidget {
  final void Function(VapController controller) onControllerCreated;
  final VapScaleFit fit;
  final int repeatCount;
  final void Function(dynamic event, dynamic arguments)? onEvent;
  final void Function(Object error)? onError;

  VapViewForAndroid(
      {required this.onControllerCreated,
      required this.fit,
      required this.repeatCount,
      this.onEvent,
      this.onError});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'scaleType': fit.name,
      'repeatCount': repeatCount
    };
    return AndroidView(
      viewType: "flutter_vap",
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: StandardMessageCodec(),
      // 使用 Hybrid Composition 模式以支持透明背景
      // 注意：这在某些Android版本上可能会有性能影响
      // hybridComposition: true,
      onPlatformViewCreated: (viewId) async {
        // MethodChannel在native端init块中已经同步设置完成，无需延迟
        onControllerCreated(VapController(
            viewId: viewId,
            onEvent: (event, arguments) {
              onEvent?.call(event, arguments);
              if (event == 'onFailed' && arguments != null) {
                onError?.call(arguments);
              }
            }));
      },
    );
  }
}
