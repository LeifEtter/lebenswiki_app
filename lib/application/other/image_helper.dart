import 'dart:developer';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:lebenswiki_app/domain/models/error_model.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageHelper {
  //TODO Compress image before upload
  static Future<Either<CustomError, String>> uploadImage(
    BuildContext context, {
    required File? chosenImage,
    required int userId,
    required FirebaseStorage storage,
  }) async {
    if (chosenImage == null) {
      return const Left(CustomError(error: "No image given"));
    }

    final fileName = basename(chosenImage.path);
    final destination = 'images/$userId/$fileName}';

    Reference ref = storage.ref().child(destination);
    UploadTask uploadTask = ref.putFile(chosenImage);

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
