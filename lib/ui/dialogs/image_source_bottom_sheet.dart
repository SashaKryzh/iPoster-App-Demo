import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/dialogs/custom_modal_bottom_shett.dart';
import 'package:iposter_chat_demo/ui/widgets/with_highlight.dart';

Future<ImageSource> showImageSourceBottomSheet(BuildContext context) async {
  return await showCustomModalBottomSheet(
    context,
    CustomBottomSheet(
      children: [
        WithHighlight(
          child: TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text(
              S.of(context).camera,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        SizedBox(height: 5),
        WithHighlight(
          child: TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text(S.of(context).library,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
          ),
        ),
      ],
    ),
  );
}
