# iPoster app (Demo)

This is a demo source code of the iPoster.ua mobile application that I have developed and published to the App Store.

![iPoster app](/resources/Thumbnail.jpg)

The purpose of the app is to deliver iPoster notifications to the user's phones. So it has two features: chat and notification list.

Also, the app supports two languages: Ukrainian and Russian.

**Links:**
* [App Store](https://apps.apple.com/ua/app/iposter/id1551116779)
* [Figma](https://www.figma.com/community/file/1030067581654775051/iPoster-App)
* iPoster.ua

> *Published for demonstration of my experience in Flutter and overall app development.*

## Development
This is the third and the most simple app version. It is written using [pragmatic state managment](https://medium.com/flutter-community/flutter-pragmatic-state-management-using-provider-5c1129f9b5bb): *ChangeNotifier, ChangeNotifierProvider, Consumer*.

#### Tecnologies used
* Flutter
* Firebase
* Google / Apple sign in
* iPoster API

### Other app versions
#### Version 1: iPoster
The very first and the most complex app version. It implements all functionality of the iPoster website. But because it is the first flutter app that I have developed the code is very messy and hard to maintain. So we have decided to rewrite everything, but next time with a much better code.

Used state managment: [BLoC](https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/).

#### Version 2: iPoster lite
In the second version, I have implemented only the basic functionality of the website. The code has become much better compared to the first version and we considered publishing it on the App Store. But after looking at the resulting app, we have concluded that this app doesn't solve our problem. So, that's why there is a third version :)

Used state managment: [Pragmatic state managment](https://medium.com/flutter-community/flutter-pragmatic-state-management-using-provider-5c1129f9b5bb).

> *All versions have been written by me with some help from the iPoster website developer.*

> *Maybe someday I will also publish the code for the first and second versions. For now, they are in my private repository.*

## What I have learned
The most obvious thing:
* I have learned a lot about Flutter, Firebase, Google / Apple sign in, overall app development, and publishing.

The more valuable lessons:
* Develop a maintainable code is much harder than to develop a one-time educational project.
* Firstly, create very detailed visual prototypes and then get to code.
* In the beginning, stay as simple as possible and add complex features later.
* Don't leave the bad app architecture for later, because later it will be much harder to fix.