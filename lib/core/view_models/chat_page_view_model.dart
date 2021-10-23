import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iposter_chat_demo/core/models/chat.dart';
import 'package:iposter_chat_demo/core/models/images.dart';
import 'package:iposter_chat_demo/core/models/message.dart';
import 'package:iposter_chat_demo/core/view_models/base_view_model.dart';
import 'package:iposter_chat_demo/generated/l10n.dart';
import 'package:iposter_chat_demo/ui/dialogs/image_preview_dialog.dart';
import 'package:iposter_chat_demo/ui/dialogs/image_source_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class ChatPageViewModel extends BaseViewModel {
  Chat chat;

  String error;
  List<Message> _messages = [];

  bool isLoading = true;

  List<Message> get messages => List.unmodifiable(_messages);

  MessageInputViewModel inputViewModel;

  ChatPageViewModel(BuildContext context, {@required this.chat})
      : inputViewModel = MessageInputViewModel(
          context,
          chat.dialogId,
          chat.adsId,
        ),
        super(context: context) {
    load();
    inputViewModel.onMessageSend(onMessageSend);
  }

  @override
  void dispose() {
    inputViewModel.dispose();
    super.dispose();
  }

  Future load({bool showLoading = true}) async {
    error = null;
    isLoading = true;
    if (showLoading) notifyListeners();

    try {
      _messages = await iPosterAPI.getMessages(chat.adsId, chat.userId);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  void onMessageSend(Message newMessage) {
    _messages.insert(0, newMessage);
    notifyListeners();
  }

  Future refresh() {
    return load(showLoading: false);
  }

  void onUserNamePressed() async {
    urlLauncher.launch(await chat.adsURL);
  }

  void onAdTitlePressed() async {
    urlLauncher.launch(await chat.adsURL);
  }

  // Looks like useless button
  // void onOpenPressed() {}
}

/////////////////////////////////////////////////////
/////////
///////
///

enum MessageButtonType { send, attach }

/// Will work without dialogId when opening from AdDetailPage
/// only when it's not your Ad.
/// DONT LET USER OPEN CHAT ON HIS AD !!! (AdDetailPage)
class MessageInputViewModel extends BaseViewModel
    implements ImagePreviewProvider {
  TextEditingController controller = TextEditingController();
  ImagePicker _imagePicker = ImagePicker();

  bool isSendingImage = false;
  String sendImageError;

  final int adsId;
  final int dialogId;

  bool _textEmpty = true;
  bool _isSending = false;

  MessageButtonType get buttonType {
    return _textEmpty ? MessageButtonType.attach : MessageButtonType.send;
  }

  Function(Message) _onMessageSend;

  void onMessageSend(void Function(Message) callback) =>
      _onMessageSend = callback;

  MessageInputViewModel(BuildContext context, this.dialogId, this.adsId)
      : assert(adsId != null),
        super(context: context) {
    controller.addListener(textListener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void textListener() {
    if (controller.text.isEmpty && _textEmpty == false) {
      _textEmpty = true;
      notifyListeners();
    } else if (controller.text.isNotEmpty && _textEmpty) {
      _textEmpty = false;
      notifyListeners();
    }
  }

  Future send() async {
    if (_isSending) return;
    _isSending = true;

    final message = Message.toSend(dialogId, adsId, message: controller.text);

    try {
      final response = await iPosterAPI.sendMessage(message);
      if (response.success) {
        _onMessageSend(message);
        controller.clear();
      } else {
        _showErrorAlertDialog(response.message);
      }
    } catch (e) {
      _showErrorAlertDialog(e.toString());
    }

    _isSending = false;
  }

  Future sendImage(File image) async {
    if (isSendingImage) return;

    isSendingImage = true;
    sendImageError = null;
    notifyListeners();

    try {
      final imageName = await iPosterAPI.uploadImage(
        image,
        ImageUploadType.messageType,
      );
      final message = Message.toSend(
        dialogId,
        adsId,
        image: iPosterImage(name: imageName, from: ImageFrom.message),
      );
      final response = await iPosterAPI.sendMessage(message);
      if (response.success) {
        Navigator.pop(context);
        _onMessageSend(message);
      } else {
        sendImageError = response.message;
      }
    } catch (e) {
      sendImageError = e.toString();
    }

    isSendingImage = false;
    notifyListeners();
  }

  Future<PickedFile> _retrieveLostData() async {
    final LostData response = await _imagePicker.getLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      return response.file;
    } else {
      print(response.exception.code);
      return null;
    }
  }

  Future attach() async {
    sendImageError = null;

    File image;

    FocusScope.of(context)
        .unfocus(); // Hide keyboard so it will not block screen when using camera
    final source = await showImageSourceBottomSheet(context);
    if (source == null) return;
    PickedFile pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile == null && Platform.isAndroid) {
      pickedFile = await _retrieveLostData();
    }
    if (pickedFile == null) {
      return;
    }

    image = File(pickedFile.path);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ImagePreviewDialog(image, this),
    );
  }

  _showErrorAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).pomylka),
          content: Text(message),
          actions: [
            RaisedButton(
              child: Text(S.of(context).ok),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
