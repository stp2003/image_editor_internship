import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import '../widgets/edit_image_viewmodel.dart';
import '../widgets/image_text.dart';

class EditImageScreen extends StatefulWidget {
  final String selectedImage;

  const EditImageScreen({
    super.key,
    required this.selectedImage,
  });

  @override
  State<EditImageScreen> createState() => _EditImageScreenState();
}

class _EditImageScreenState extends EditImageViewModel {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Screenshot(
        controller: screenshotController,
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              children: [
                _selectedImage,
                for (int i = 0; i < texts.length; i++)
                  Positioned(
                    left: texts[i].left,
                    top: texts[i].top,
                    child: GestureDetector(
                      onLongPress: () {
                        //*** on log pressing the text it gets deleted ->
                        setState(
                          () {
                            currentIndex = i;
                            removeText(context);
                          },
                        );
                      },
                      onTap: () => setCurrentIndex(context, i),
                      child: Draggable(
                        feedback: ImageText(textInfo: texts[i]),
                        child: ImageText(textInfo: texts[i]),
                        onDragEnd: (drag) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          Offset off = renderBox.globalToLocal(drag.offset);
                          setState(
                            () {
                              texts[i].top = off.dy - 96;
                              texts[i].left = off.dx;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                creatorText.text.isNotEmpty
                    ? Positioned(
                        left: 0,
                        bottom: 0,
                        child: Text(
                          creatorText.text,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(
                              0.3,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _addNewTextFloatingActionButton,
    );
  }

  Widget get _selectedImage => Center(
        child: Image.file(
          File(
            widget.selectedImage,
          ),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        ),
      );

  Widget get _addNewTextFloatingActionButton => FloatingActionButton(
        onPressed: () => addNewDialog(context),
        backgroundColor: Colors.white,
        tooltip: 'Add New Text..',
        child: const Icon(
          Icons.edit,
          color: Colors.black87,
        ),
      );

  // Appbar ->
  AppBar get _appBar => AppBar(
        backgroundColor: Colors.black26,
        leading: const BackButton(),
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              //?? Buttons icon ->
              IconButton(
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                onPressed: () => saveToGallery(context),
                tooltip: 'Save Image',
              ),
              IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: increaseFontSize,
                tooltip: 'Increase font size',
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onPressed: decreaseFontSize,
                tooltip: 'Decrease font size',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_align_left,
                  color: Colors.white,
                ),
                onPressed: alignLeft,
                tooltip: 'Align left',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_align_center,
                  color: Colors.white,
                ),
                onPressed: alignCenter,
                tooltip: 'Align Center',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_align_right,
                  color: Colors.white,
                ),
                onPressed: alignRight,
                tooltip: 'Align Right',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_bold,
                  color: Colors.white,
                ),
                onPressed: boldText,
                tooltip: 'Bold',
              ),
              IconButton(
                icon: const Icon(
                  Icons.format_italic,
                  color: Colors.white,
                ),
                onPressed: italicText,
                tooltip: 'Italic',
              ),
              IconButton(
                icon: const Icon(
                  Icons.space_bar,
                  color: Colors.white,
                ),
                onPressed: addLinesToText,
                tooltip: 'Add New Line',
              ),
              Tooltip(
                message: 'Red',
                child: GestureDetector(
                    onTap: () => changeTextColor(Colors.red),
                    child: const CircleAvatar(
                      backgroundColor: Colors.red,
                    )),
              ),
              const SizedBox(width: 5.0),

              //?? For colors ->
              Tooltip(
                message: 'White',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.white),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Black',
                child: GestureDetector(
                    onTap: () => changeTextColor(Colors.black),
                    child: const CircleAvatar(
                      backgroundColor: Colors.black,
                    )),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Blue',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.blue),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Yellow',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.yellow),
                  child: const CircleAvatar(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Green',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.green),
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Orange',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.orange),
                  child: const CircleAvatar(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
              Tooltip(
                message: 'Pink',
                child: GestureDetector(
                  onTap: () => changeTextColor(Colors.pink),
                  child: const CircleAvatar(
                    backgroundColor: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
            ],
          ),
        ),
      );
}
