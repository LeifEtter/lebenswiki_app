import 'dart:developer';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageHelper {
  static Future<Either<CustomError, String>> uploadImage(
    BuildContext context, {
    required String pathToStore,
    required File? chosenImage,
    required int userId,
    required FirebaseStorage storage,
  }) async {
    //Compress image file

    if (chosenImage == null) {
      return const Left(CustomError(error: "No image given"));
    }
    final lastIndex = chosenImage.absolute.path.lastIndexOf('.');
    final splitted = chosenImage.absolute.path.substring(0, (lastIndex));
    final outPath =
        "${splitted}_out${chosenImage.absolute.path.substring(lastIndex)}";

    File? compressionResult = await FlutterImageCompress.compressAndGetFile(
      chosenImage.absolute.path,
      outPath,
      minWidth: 1000,
      minHeight: 650,
      quality: 50,
    );

    final fileName = basename(chosenImage.path);
    final destination = '$pathToStore$fileName';

    Reference ref = storage.ref().child(destination);
    UploadTask uploadTask = ref.putFile(compressionResult!);

    Either<CustomError, String> result =
        const Left(CustomError(error: "Irgendwas ist schiefgelaufen"));

    await uploadTask.whenComplete(() async {
      String downloadUrl = await ref.getDownloadURL();
      result = Right(downloadUrl);
    }).catchError((error) {
      log(error);
      result = const Left(
          CustomError(error: "Bild konnte nicht hochgeladen werden"));
    });
    return result;
  }
}
