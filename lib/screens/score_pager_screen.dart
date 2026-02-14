import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hymn_app/models/score_item.dart';
import 'package:hymn_app/theme/app_theme.dart';
import 'package:hymn_app/widgets/score_cached_image.dart';

class ScorePagerScreen extends StatefulWidget {
  final List<ScoreItem> items;
  final int initialIndex;

  const ScorePagerScreen({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<ScorePagerScreen> createState() => _ScorePagerScreenState();
}

class _ScorePagerScreenState extends State<ScorePagerScreen> {
  late final PageController _pageController = PageController(
    initialPage: widget.initialIndex,
  );

  final ValueNotifier<bool> _zooming = ValueNotifier(false);

  int _currentIndex = 0;
  bool _uiHidden = false;

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _zooming.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void uiToggle() {
    setState(() {
      _uiHidden = !_uiHidden;
    });

    if (_uiHidden) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _uiHidden
          ? null
          : AppBar(
              title: Text(widget.items[_currentIndex].title),
              backgroundColor: AppColors.card,
              elevation: 0,
            ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: uiToggle,
        child: Container(
          color: Colors.black,
          child: ValueListenableBuilder<bool>(
            valueListenable: _zooming,
            builder: (_, zooming, __) {
              return PageView.builder(
                controller: _pageController,
                physics: zooming ? const NeverScrollableScrollPhysics() : null,
                itemCount: widget.items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (_, index) {
                  final item = widget.items[index];
                  return _ZoomableScoreImage(
                    item: item,
                    onZoomChanged: (z) => _zooming.value = z,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ZoomableScoreImage extends StatefulWidget {
  final ScoreItem item;
  final void Function(bool zooming) onZoomChanged;

  const _ZoomableScoreImage({required this.item, required this.onZoomChanged});

  @override
  State<_ZoomableScoreImage> createState() => __ZoomableScoreImageState();
}

class __ZoomableScoreImageState extends State<_ZoomableScoreImage> {
  final TransformationController _tc = TransformationController();

  @override
  void initState() {
    super.initState();
    _tc.addListener(_handleZoomChange);
  }

  @override
  void dispose() {
    _tc.removeListener(_handleZoomChange);
    _tc.dispose();
    super.dispose();
  }

  void _handleZoomChange() {
    final scaleX = _tc.value.storage[0];
    widget.onZoomChanged(scaleX > 1.0);
  }

  void _handleDoubleTap() {
    final isZoomed = _tc.value.storage[0] > 1.0;

    if (isZoomed) {
      _tc.value = Matrix4.identity();
      widget.onZoomChanged(false);
    } else {
      _tc.value = Matrix4.identity()..scale(2.5);
      widget.onZoomChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.item.downloadUrl ?? widget.item.fileUrl;
    return Center(
      child: imageUrl == null || imageUrl.isEmpty
          ? const Text('악보 이미지를 불러올 수 없습니다')
          : GestureDetector(
              onDoubleTap: _handleDoubleTap,
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                transformationController: _tc,
                minScale: 1,
                maxScale: 4,
                child: ScoreCachedImage(imageUrl: imageUrl),
              ),
            ),
    );
  }
}
