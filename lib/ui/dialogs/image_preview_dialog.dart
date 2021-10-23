import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iposter_chat_demo/core/view_models/base_view_model.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

abstract class ImagePreviewProvider extends BaseViewModel {
  bool isSendingImage;
  String sendImageError;
  Future sendImage(File image);
}

class ImagePreviewDialog extends StatelessWidget {
  final File image;
  final ImagePreviewProvider provider;

  ImagePreviewDialog(this.image, this.provider);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      builder: (context, _) {
        return Consumer<ImagePreviewProvider>(
          builder: (context, model, _) {
            return AlertDialog(
              content: SizedBox(
                height: 300,
                width: 300,
                child: Stack(
                  children: [
                    LoadingOverlay(
                      isLoading: model.isSendingImage,
                      child: Center(
                        child: Image.file(
                          image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (model.sendImageError != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              model.sendImageError,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(S.of(context).vidminyty),
                  onPressed: model.isSendingImage
                      ? null
                      : () => Navigator.pop(context),
                ),
                RaisedButton(
                  child: Text(S.of(context).vidpravyty),
                  onPressed: model.isSendingImage
                      ? null
                      : () => provider.sendImage(image),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
