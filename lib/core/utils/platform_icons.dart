import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformIcons {
  static final isIOS = Platform.isIOS;

  static IconData get camera {
    return isIOS ? CupertinoIcons.camera : Icons.camera;
  }

  static IconData get library {
    return isIOS ? CupertinoIcons.photo : Icons.library_add;
  }
}
