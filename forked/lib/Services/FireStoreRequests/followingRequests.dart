
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forked/Models/following.dart';
import 'package:get/get.dart';

final db = FirebaseFirestore.instance;

createFollowing({required String followedUserID,required String userID}) async {
 
  // User appt =
  //     User(userID: id, email: email);
try{


  await db.collection('following').doc("${userID}_${followedUserID}").set({"userID":userID, "followedUserID":followedUserID});

}catch(err){
Get.snackbar("title", "error inside createfollowing");
}
}


deleteFollowing({required String followingID})async{
  try{


await db.collection("following").doc(followingID).delete();

  }catch(ee){


Get.snackbar("title", "error inside deleteFollowing");


  }
}






readUsersFollowing({String? userID})async{

List<following> userFollowing=[];
try{
  await FirebaseFirestore.instance
    .collection('following').
   where('userID', isEqualTo: userID ) // we need to change username to userName
    .get() //Future<QuerySnapshot<Map<String, dynamic>>>
    .then((QuerySnapshot querySnapshot) {
      
        querySnapshot.docs.forEach((doc) {// QuerySnapshot<Object?>
       
userFollowing.add(following.fronJson(doc.data() as Map<String, dynamic>));  

        });
    });

for (var element in userFollowing) {
Get.snackbar("title", element.followedUserID.toString());
}
return userFollowing;
}catch(err){}
}



readUsersFollowers({String? userID})async{

List<following> userFollowers=[];

try{
  await FirebaseFirestore.instance
    .collection('following').
   where('followedUserID', isEqualTo: userID ) // we need to change username to userName
    .get() //Future<QuerySnapshot<Map<String, dynamic>>>
    .then((QuerySnapshot querySnapshot) {
      
        querySnapshot.docs.forEach((doc) {// QuerySnapshot<Object?>
       
userFollowers.add(following.fronJson(doc.data() as Map<String, dynamic>));  

        });
    });

for (var element in userFollowers) {
Get.snackbar("title", element.followedUserID.toString());
}
return userFollowers;}
catch(err){


}
}