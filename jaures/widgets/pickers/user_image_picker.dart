import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;
  //final void Function(XFile pickedImage) imagePickFn;
  //Future<XFile?>
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile _pickedImage;
  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final pickedImageFile = await _picker.pickImage(
      source: ImageSource.camera, // !!!!!!!!!!!! ImageSource.gallery
      //source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImageFile;
      print(_pickedImage.path);
    });
    widget.imagePickFn(File(pickedImageFile.path));
  }

  void _pickImage2() async {
    final pickedImageFile = await _picker.pickImage(
      source: ImageSource.gallery, // !!!!!!!!!!!! ImageSource.camera
      //source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImageFile;
      print(_pickedImage.path);
    });
    widget.imagePickFn(File(pickedImageFile.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_pickedImage == null)
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            child: _pickedImage != null
                ? Image.file(
                    File(_pickedImage.path),
                    height: 150,
                    width: 150, //double.infinity,
                    fit: BoxFit.fill, //cover,
                  )
                : null,
            //backgroundImage: _pickedImage != null ? Image.file(File(_pickedImage.path)) : null,
            //Image.file(File(_imageFileList![index].path)
          ),
        Semantics(
          label: 'image_picker_example_picked_image',
          child: _pickedImage != null ? (kIsWeb ? Image.network(_pickedImage.path) : Image.file(File(_pickedImage.path))) : null,
        ),
        DropdownButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryIconTheme.color,
          ),
          items: [
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.image),
                    SizedBox(width: 8),
                    Text(
                      'Photo(Facultative)',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              value: 'camera',
            ),
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home),
                    SizedBox(width: 8),
                    Text(
                      'Gallarie(Facultative)',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
              value: 'gallerie',
            ),
          ],
          onChanged: (itemIdentifier) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Prendre une photo de profil.'),
                backgroundColor: Theme.of(context).backgroundColor,
              ),
            );
            if (itemIdentifier == 'camera') {
              _pickImage();
            } else {
              _pickImage2();
            }
          },
        ), // end dropdown
      ],
    );
  }
}
