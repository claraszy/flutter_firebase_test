import 'package:flutter/material.dart';

class TagRow extends StatefulWidget {
  const TagRow({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final List<String> tags;

  @override
  _TagRowState createState() => _TagRowState();
}

class _TagRowState extends State<TagRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      height: 50,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.tags.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Chip(
                backgroundColor: Colors.white,
                elevation: 5,
                label: Text(
                  '# ' + widget.tags[index].toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.clip,
                ),
                deleteButtonTooltipMessage: 'Delete',
                deleteIcon: Icon(Icons.delete, size: 13, color: Colors.grey,),
                onDeleted: () {
                  setState(() {
                    widget.tags.remove(widget.tags[index]);
                  });
                },
              ),

              //title: Text('#${tags[index]}', style: TextStyle(fontSize: 12),),
            ),
          ),
        ),
      ),
    );
  }
}
