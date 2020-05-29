
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/localization/app_localizations.dart';
import 'package:flutter_deer/res/resources.dart';
import 'package:flutter_deer/util/toast.dart';
import 'package:flutter_deer/util/utils.dart';
import 'package:flutter_deer/widgets/app_bar.dart';
import 'package:flutter_deer/widgets/my_button.dart';
import 'package:flutter_deer/widgets/my_scroll_view.dart';
import 'package:flutter_deer/widgets/text_field.dart';

/// design/1注册登录/index.html#artboard11
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //定义一个controller
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _vCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  final FocusNode _nodeText3 = FocusNode();
  bool _clickable = false;
  
  @override
  void initState() {
    super.initState();
    //监听输入改变  
    _nameController.addListener(_verify);
    _vCodeController.addListener(_verify);
    _passwordController.addListener(_verify);
  }

  @override
  void dispose() {
    _nameController.removeListener(_verify);
    _vCodeController.removeListener(_verify);
    _passwordController.removeListener(_verify);
    _nameController.dispose();
    _vCodeController.dispose();
    _passwordController.dispose();
    _nodeText1.dispose();
    _nodeText2.dispose();
    _nodeText3.dispose();
    super.dispose();
  }
  
  void _verify() {
    var name = _nameController.text;
    var vCode = _vCodeController.text;
    var password = _passwordController.text;
    var clickable = true;
    if (name.isEmpty || name.length < 11) {
      clickable = false;
    }
    if (vCode.isEmpty || vCode.length < 6) {
      clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      clickable = false;
    }
    if (clickable != _clickable) {
      setState(() {
        _clickable = clickable;
      });
    }
  }
  
  void _register() {
    Toast.show('点击注册');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: AppLocalizations.of(context).register,
        ),
        body: MyScrollView(
          keyboardConfig: Utils.getKeyboardActionsConfig(context, [_nodeText1, _nodeText2, _nodeText3]),
          crossAxisAlignment: CrossAxisAlignment.center,
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
          children: _buildBody(),
        ),
    );
  }

  List<Widget> _buildBody() {
    return [
      Text(
        AppLocalizations.of(context).openYourAccount,
        style: TextStyles.textBold26,
      ),
      Gaps.vGap16,
      MyTextField(
        key: const Key('phone'),
        focusNode: _nodeText1,
        controller: _nameController,
        maxLength: 11,
        keyboardType: TextInputType.phone,
        hintText: AppLocalizations.of(context).inputPhoneHint,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('vcode'),
        focusNode: _nodeText2,
        controller: _vCodeController,
        keyboardType: TextInputType.number,
        getVCode: () async {
          if (_nameController.text.length == 11) {
            Toast.show(AppLocalizations.of(context).verificationButton);
            /// 一般可以在这里发送真正的请求，请求成功返回true
            return true;
          } else {
            Toast.show(AppLocalizations.of(context).inputPhoneInvalid);
            return false;
          }
        },
        maxLength: 6,
        hintText: AppLocalizations.of(context).inputVerificationCodeHint,
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('password'),
        keyName: 'password',
        focusNode: _nodeText3,
        isInputPwd: true,
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        maxLength: 16,
        hintText: AppLocalizations.of(context).inputPasswordHint,
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('register'),
        onPressed: _clickable ? _register : null,
        text: AppLocalizations.of(context).register,
      )
    ];
  }
}
