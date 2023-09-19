import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tired/constants.dart';
import 'package:tired/models/video.dart';

class VideoController extends GetxController {
  final Rx<List<Video>> _videoList = Rx<List<Video>>([]);

  List<Video> get videoList => _videoList.value;

  @override
  void onInit() {
    super.onInit();
    _videoList.bindStream(
        firestore.collection('videos').snapshots().map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(
          Video.fromSnap(element),
        );
      }
      return retVal;
    }));
  }

  shareVideo(String vidID) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('videos').doc(vidID).get();

    int newShareCount = (doc.data() as dynamic)['shareCount'] + 1;
    await FirebaseFirestore.instance
        .collection('videos')
        .doc(vidID)
        .update({'ShareCount': newShareCount.toString()});
  }

  likeVideo(String id) {}
}

likeVideo(String id) async {
  DocumentSnapshot doc = await firestore.collection('videos').doc(id).get();
  var uid = authController.user.uid;
  if ((doc.data()! as dynamic)['likes'].contains(uid)) {
    await firestore.collection('videos').doc(id).update({
      'likes': FieldValue.arrayRemove([uid]),
    });
  } else {
    await firestore.collection('videos').doc(id).update({
      'likes': FieldValue.arrayUnion([uid]),
    });
  }
}
