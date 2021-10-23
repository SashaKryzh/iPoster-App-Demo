import 'dart:async';

class FavoriteUpdate {
  final int adId;
  final bool isFavorite;

  FavoriteUpdate({this.adId, this.isFavorite});
}

class FavoriteNotify {
  final StreamController<FavoriteUpdate> _controller =
      StreamController<FavoriteUpdate>.broadcast();

  Stream<FavoriteUpdate> get updates => _controller.stream;

  void dispose() {
    _controller.close();
  }

  void changeTo(int adId, bool isFavorite) {
    _controller.add(FavoriteUpdate(adId: adId, isFavorite: isFavorite));
  }
}
