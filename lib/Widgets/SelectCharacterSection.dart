import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SelectCharacterItem.dart';

class SelectCharacterSection extends StatefulWidget{

  //我想要的SelectCharacterSection:
  //传入标题，一些icons或者图片，把每一个icon或者图片包装成一个按钮
  //在父widget需要时可以获知都有哪些icons被选中，以及选中数量

  final String title;
  List<SelectCharacterItem> items;
  List<bool> isSelected;
  SelectCharacterSection(this.title,this.items, this.isSelected);

  @override
  State<StatefulWidget> createState() => SelectCharacterSectionState(title, items,isSelected);

}

class SelectCharacterSectionState extends State<SelectCharacterSection>{


  String title;
  List<SelectCharacterItem> items;
  List<bool> isSelected;


  SelectCharacterSectionState(this.title, this.items,this.isSelected);

  @override
  void initState() {
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text("${title}",textAlign: TextAlign.left,),
          ),
          Wrap(
            children: List<Widget>.generate(items.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    print(isSelected[index]);
                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  child: items[index].icon,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isSelected[index] ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
          ),

        ],
      ),
    );
  }

}