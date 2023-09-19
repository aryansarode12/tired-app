import 'dart:io'; // Import the dart:io package for File class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tired/constants.dart';
import 'package:tired/models/video.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadVideoController extends GetxController {
  Future<List<String>> _uploadVideoToStorage(
      String id, String videoPath) async {
    Reference videoRef = firebaseStorage.ref().child('videos').child(id);

    // Compress the video
    final compressVideoInfo = await VideoCompress.compressVideo(
      videoPath,

      ///update compress quality here
      quality: VideoQuality.LowQuality, // Set your desired compression quality
    );

    final compressVideoPath = compressVideoInfo!.path;

    UploadTask uploadVideoTask = videoRef.putFile(File(compressVideoPath!));
    TaskSnapshot videoSnapshot = await uploadVideoTask.whenComplete(() => null);
    String videoUrl = await videoSnapshot.ref.getDownloadURL();

    // Generate thumbnail
    final appDir = await getTemporaryDirectory();
    final thumbnailPath = '${appDir.path}/thumbnail.png';

    await VideoThumbnail.thumbnailFile(
      video:
          compressVideoPath, // Use the compressed video for generating thumbnail
      thumbnailPath: thumbnailPath,
    );

    Reference thumbnailRef =
        firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask uploadThumbnailTask = thumbnailRef.putFile(File(thumbnailPath));
    TaskSnapshot thumbnailSnapshot =
        await uploadThumbnailTask.whenComplete(() => null);
    String thumbnailUrl = await thumbnailSnapshot.ref.getDownloadURL();

    // Delete the temporary files
    File(compressVideoPath).delete();
    File(thumbnailPath).delete();

    return [videoUrl, thumbnailUrl];
  }

  Future<void> _uploadImageToStorage(String id, String imagePath) async {
    // You can implement the image upload logic here in a similar manner
  }

  Future<void> uploadVideo(
      String songName, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(uid).get();

      ///just posting a default dp in case
      String profileImage = (userDoc.data()
              as Map<String, dynamic>?)?['profilephoto'] ??
          'https://imgs.search.brave.com/bWazwl3jAJKNBjdEJjUfcq61qbKegJoJuQUF6m5zfWk/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9jZG4u/dmVjdG9yc3RvY2su/Y29tL2kvcHJldmll/dy0xeC8wMi85MC9t/YWxlLWF2YXRhci1w/cm9maWxlLXBpY3R1/cmUtYXZhdGFyLXZl/Y3Rvci00NDU0MDI5/MC5qcGc';

      ///remove the conditional state here
      String username =
          (userDoc.data() as Map<String, dynamic>?)?['name'] ?? 'unknown';
      print("userprofile url : $profileImage");

      // get id
      var allDocs = await firestore.collection('videos').get();
      int len = allDocs.docs.length;

      /// Await the result of _uploadVideoToStorage
      List<String> urls = await _uploadVideoToStorage('video $len', videoPath);
      String videoUrl = urls[0];
      String thumbnailUrl = urls[1];

      ///check whether the strings are null (delete this before executing)
      print("username $username");
      print("videoUrl : $videoUrl");
      print('items : songname $songName , caption $caption');

      await _uploadImageToStorage("video $len", videoPath);

      Video video = Video(
        username: username,
        uid: uid,
        id: 'video $len',
        likes: [],
        commentCount: 0,
        shareCount: 0,
        songName: songName,
        caption: caption,
        videoUrl: videoUrl,
        profilePhoto: profileImage,
        thumbnail: thumbnailUrl,
      );
      await firestore.collection('videos').doc('Video $len').set(
            video.toJson(),
          );
      Get.back();

      Get.snackbar('New Video', 'Video Successfully Uploaded');
    } catch (e) {
      Get.snackbar(
        'Error Uploading Video,Try Again',
        e.toString(),
      );
    }
  }
}
