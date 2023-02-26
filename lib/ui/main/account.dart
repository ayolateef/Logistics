import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../main.dart';
import '../../model/account.dart';
import '../../servicelocator.dart';
import '../../services/RestData/RestDataServices.dart';
import '../../services/firebase/cloudstorage.dart';
import '../../viewmodel/createaccount.dart';
import '../widgets/easyDialog2.dart';
import '../widgets/iAvatarWithPhotoFileCaching.dart';
import '../widgets/ibutton2.dart';
import '../widgets/ilist4.dart';

class AccountScreen extends StatefulWidget {
  final Function(String)? callback;
  AccountScreen({Key? key, this.callback}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  ///////////////////////////////////////////////////////////////////////////////
  //

  Account? account;
  final RestDataService _restdataService = serviceLocator<RestDataService>();
  final CreateAccountViewModel _accountViewModel =
      serviceLocator<CreateAccountViewModel>();

  @override
  void didChangeDependencies() {
    account =
        Provider.of<CreateAccountViewModel>(context, listen: false).account;
    print(account?.notifyCount);

    super.didChangeDependencies();
  }

  _makePhoto() {
    print("Make photo");
    getImage();
  }

  _pressLogOutButton() {
    print("User pressed Log Out");
    account?.logOut();
    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
  }

  _pressEditProfileButton() {
    print("User pressed Edit profile");
    _openEditProfileDialog();
  }

  _callbackSave() {
    print("User pressed Save profile");
    print(
        "User Name: ${editControllerName.text}, E-mail: ${editControllerEmail.text}, Phone: ${editControllerPhone.text}");
  }

  _callbackChange() {
    print("User pressed Change password");
    print(
        "Old password: ${editControllerOldPassword.text}, New password: ${editControllerNewPassword1.text}, "
        "New password 2: ${editControllerNewPassword2.text}");
  }

  //
  //
  ///////////////////////////////////////////////////////////////////////////////
  dynamic windowWidth;
  dynamic windowHeight;
  final picker = ImagePicker();
  final editControllerName = TextEditingController();
  final editControllerEmail = TextEditingController();
  final editControllerPhone = TextEditingController();
  final editControllerOldPassword = TextEditingController();
  final editControllerNewPassword1 = TextEditingController();
  final editControllerNewPassword2 = TextEditingController();
  double _show = 0;
  Widget _dialogBody = Container();

  Future getImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null && pickedFile.path != null) {
      print("Photo file: ${pickedFile.path}");
      File _storedImage;

      if (pickedFile == null) {
        return;
      }
      setState(() {
        //  _storedImage = pickedFile;
      });

      final fileName = path.basename(pickedFile.path);
      print(fileName);
      var img = await File(pickedFile.path);

      CloudStorageResult? imgcloud = await CloudStorageService()
          .uploadImage(imageToUpload: img, title: "useravatar");
      account?.setAvatar(imgcloud?.imageUrl ?? '');
      // account.setavatarinternet(cloud.imageFileName);
      String token =
          // ignore: use_build_context_synchronously
          Provider.of<CreateAccountViewModel>(context, listen: false).token;

      _restdataService.editPhoto(token, account?.email ?? '',
          imgcloud?.imageUrl ?? '', imgcloud?.imageUrl ?? '');
      // if (account.userAvatarInternet != "" ||
      //     account.userAvatarInternet != null) {
      //       print(account.userAvatarInternet)
      //   await CloudStorageService().deleteImage(account.userAvatarInternet);
      // }
      setState(() {
        //_avatar = pickedFile.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    editControllerName.dispose();
    editControllerEmail.dispose();
    editControllerPhone.dispose();
    editControllerOldPassword.dispose();
    editControllerNewPassword1.dispose();
    editControllerNewPassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    windowWidth = MediaQuery.of(context).size.width;
    windowHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 40),
          child: Container(
              child: ListView(
            padding: const EdgeInsets.only(top: 0),
            shrinkWrap: true,
            children: _getList(),
          )),
        ),
        IEasyDialog2(
          setPosition: (double value) {
            _show = value;
          },
          getPosition: () {
            return _show;
          },
          color: theme.colorGrey,
          body: _dialogBody,
          backgroundColor: theme.colorBackground,
        ),
      ],
    );
  }

  _getList() {
    var list = <Widget>[];

    list.add(Stack(
      children: [
        IAvatarWithPhotoFileCaching(
          avatar: account?.userAvatar ?? '',
          color: theme.colorPrimary,
          colorBorder: theme.colorGrey,
          callback: _makePhoto,
        ),
        _logoutWidget(),
      ],
    ));

    list.add(const SizedBox(
      height: 10,
    ));

    list.add(Container(
      color: theme.colorBackgroundGray,
      child: _userInfo(),
    ));

    list.add(const SizedBox(
      height: 30,
    ));

    list.add(Container(
        margin: const EdgeInsets.only(left: 30, right: 30), child: _logout()));

    list.add(const SizedBox(
      height: 30,
    ));

    list.add(Container(
        margin: const EdgeInsets.only(left: 30, right: 30),
        child: _changePassword()));

    list.add(const SizedBox(
      height: 100,
    ));

    return list;
  }

  _changePassword() {
    return Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(70) ?? '', // Change password
          textStyle: theme.text14boldWhite!,
          padding: 40,
          pressButton: _pressChangePasswordButton),
    );
  }

  _logout() {
    return Container(
      alignment: Alignment.center,
      child: IButton2(
          color: theme.colorPrimary,
          text: strings.get(64) ?? '', // Edit profile
          textStyle: theme.text14boldWhite!,
          padding: 40,
          pressButton: _pressEditProfileButton),
    );
  }

  _logoutWidget() {
    return Container(
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 10, right: 10),
      child: Stack(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorBackgroundDialog,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(1, 1), // changes position of shadow
                ),
              ],
            ),
            child: Icon(Icons.exit_to_app,
                color: theme.colorDefaultText?.withOpacity(0.1), size: 30),
          ),
          Positioned.fill(
            child: Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  splashColor: Colors.grey[400],
                  onTap: () {
                    _pressLogOutButton();
                  }, // needed
                )),
          )
        ],
      ),
    );
  }

  _userInfo() {
    return Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        child: Column(
          children: <Widget>[
            IList4(
              text: "${strings.get(32)}:", // "Username",
              textStyle: theme.text14bold!,
              text2: account?.userName ?? '',
              textStyle2: theme.text14bold!,
            ),
            const SizedBox(
              height: 10,
            ),
            IList4(
              text: "${strings.get(33)}:", // "E-mail",
              textStyle: theme.text14bold!,
              text2: account?.email ?? '',
              textStyle2: theme.text14bold!,
            ),
            const SizedBox(
              height: 10,
            ),
            IList4(
              text: "${strings.get(63)}:", // "Phone",
              textStyle: theme.text14bold!,
              text2: account?.phone ?? '',
              textStyle2: theme.text14bold!,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  _edit(TextEditingController _controller, String _hint, bool _obscure) {
    return Container(
      height: 30,
      child: TextField(
        controller: _controller,
        onChanged: (String value) async {},
        cursorColor: theme.colorDefaultText,
        style: theme.text14,
        cursorWidth: 1,
        obscureText: _obscure,
        textAlign: TextAlign.left,
        maxLines: 1,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: _hint,
            hintStyle: theme.text14),
      ),
    );
  }

  _pressChangePasswordButton() {
    _dialogBody = Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(
                strings.get(70) ?? '',
                textAlign: TextAlign.center,
                style: theme.text18boldPrimary,
              ) // "Change password",
              ), // "Reason to Reject",
          const SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(72)}:",
            style: theme.text12bold,
          ), // "Old password",
          _edit(editControllerOldPassword, strings.get(73) ?? '',
              true), //  "Enter your old password",
          const SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(74)}:",
            style: theme.text12bold,
          ), // "New password",
          _edit(editControllerNewPassword1, strings.get(75) ?? '',
              true), //  "Enter your new password",
          const SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(76)}:",
            style: theme.text12bold,
          ), // "Confirm New password",
          _edit(editControllerNewPassword2, strings.get(75) ?? '',
              true), //  "Enter your new password",
          const SizedBox(
            height: 30,
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(71) ?? '', // Change
                  textStyle: theme.text14boldWhite!,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                    _callbackChange();
                  }),
              const SizedBox(
                width: 10,
              ),
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(66) ?? '', // Cancel
                  textStyle: theme.text14boldWhite!,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                  }),
            ],
          )),
        ],
      ),
    );

    setState(() {
      _show = 1;
    });
  }

  _openEditProfileDialog() {
    editControllerName.text = account?.userName ?? '';
    editControllerEmail.text = account?.email ?? '';
    editControllerPhone.text = account?.phone ?? '';

    _dialogBody = Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              alignment: Alignment.center,
              child: Text(
                strings.get(64) ?? '',
                textAlign: TextAlign.center,
                style: theme.text18boldPrimary,
              ) // "Edit profile",
              ), // "Reason to Reject",
          const SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(32)}:",
            style: theme.text12bold,
          ), // "User Name",
          _edit(editControllerName, strings.get(67) ?? '',
              false), //  "Enter your User Name",
          const SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(33)}:",
            style: theme.text12bold,
          ), // "E-mail",
          _edit(editControllerEmail, strings.get(68) ?? '',
              false), //  "Enter your User E-mail",
          const SizedBox(
            height: 20,
          ),
          Text(
            "${strings.get(63)}:",
            style: theme.text12bold,
          ), // Phone
          _edit(editControllerPhone, strings.get(69) ?? '',
              false), //  "Enter your User Phone",
          const SizedBox(
            height: 30,
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(71) ?? '', // Change
                  textStyle: theme.text14boldWhite!,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                    _callbackSave();
                  }),
              const SizedBox(
                width: 10,
              ),
              IButton2(
                  color: theme.colorPrimary,
                  text: strings.get(66) ?? '', // Cancel
                  textStyle: theme.text14boldWhite!,
                  pressButton: () {
                    setState(() {
                      _show = 0;
                    });
                  }),
            ],
          )),
        ],
      ),
    );

    setState(() {
      _show = 1;
    });
  }

  getImage() {
    _dialogBody = Column(
      children: [
        InkWell(
            onTap: () {
              getImage2(ImageSource.gallery);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 40,
                color: theme.colorBackgroundGray,
                child: Center(
                  child: Text(strings.get(77) ?? ''), // "Open Gallery",
                ))),
        InkWell(
            onTap: () {
              getImage2(ImageSource.camera);
              setState(() {
                _show = 0;
              });
            }, // needed
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              margin: const EdgeInsets.only(bottom: 10),
              height: 40,
              color: theme.colorBackgroundGray,
              child: Center(
                child: Text(strings.get(78) ?? ''), //  "Open Camera",
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        IButton2(
            color: theme.colorPrimary,
            text: strings.get(66) ?? '', // Cancel
            textStyle: theme.text14boldWhite!,
            pressButton: () {
              setState(() {
                _show = 0;
              });
            }),
      ],
    );
    setState(() {
      _show = 1;
    });
  }
}
