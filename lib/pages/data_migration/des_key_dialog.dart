part of 'data_migration.dart';


class DesKeyDialog extends StatelessWidget {
  String? desKey;

  @override
  Widget build(BuildContext context) => SimpleDialog(
    title: Text('设定密钥'),
    children: <Widget>[
      Column(children: <Widget>[
        Text('请设定密钥：'),
        TextField(
          onChanged: (value) {
            desKey = value;
          },
          controller: TextEditingController()..text = desKey ?? '',
          // inputFormatters: [
          //   WhitelistingTextInputFormatter(
          //       RegExp(r'\S{8}'))
          // ],
          decoration: InputDecoration(labelText: '请输入8位字符。'),
          maxLength: 8,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(desKey),
            child: Text('确定'))
      ])
    ],
  );
}