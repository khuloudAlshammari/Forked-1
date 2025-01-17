import 'package:flutter/cupertino.dart';
import 'package:forked/Components/CardRecipeCard.dart';
import 'package:forked/Components/userDisplay.dart';
import 'package:forked/Controllers/OthersProfileController.dart';
import 'package:forked/Models/User.dart';
import 'package:forked/Models/following.dart';
import 'package:forked/Models/forkedRecipe.dart';
import 'package:forked/Services/FireStoreRequests/RiecipeRequests.dart';
import 'package:forked/Services/FireStoreRequests/UserRequests.dart';
import 'package:forked/Services/FireStoreRequests/allRequests.dart';
import 'package:forked/Services/FireStoreRequests/followingRequests.dart';
import 'package:forked/Views/othersProfile.dart';
import 'package:forked/Views/viewForkedRecippie.dart';
import 'package:forked/main.dart';
import 'package:get/get.dart';
import '../Models/originalRecipie.dart';
import '../Services/FireStoreRequests/forkedRecipeRequests.dart';
import '../Views/ViewRecipe.dart';

class ListsOfHomeController extends GetxController {
  List<Widget> daliyInspirationList = [];
  List<Widget> mostPopularList = [];
  List<Widget> followingList = [];
  List<Widget> exploreList = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    exploreList = await exploring(exploreList);
    daliyInspirationList =
        await addInDaliyInspirationList(daliyInspirationList);
    mostPopularList = await addInMostPopularList(mostPopularList);
    followingList = (await addInFollowingList(
        followingList: followingList, userId: myUserData.userID))!;
    update();
  }

//daily inspiration
  //number of
  Future<List<Widget>> addInDaliyInspirationList(List<Widget> shuffeled) async {
    List<originalRecipe> explorrer = await readAllOriginalRecipies();
    List<forkedRecipe> forkedExplorer = await readAllforkedlRecipies();

    explorrer.shuffle();

    forkedExplorer.shuffle();

    for (var i = 0; i < 6; i++) {
      if (i % 2 == 0 && i < explorrer.length) {
        //Get.snackbar("ortiginal", explorrer[i].title.toString());
        shuffeled.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                //   minWidth: Get.width*.5,
                // minHeight: Get.height*.45,
                //   maxHeight: Get.height*.46,
                //  maxWidth: Get.width*.51,

                ),
            child: SmallCardRecipeCard(
              recipeName: explorrer[i].title!,
              recipeImage: explorrer[i].imgPath,
              userName: explorrer[i].username,
                            userAvatar: explorrer[i].userProfileImage,

              ImageFunct: () {
                Get.to(ViewRecipe(myRecipie: explorrer[i]));
              },
              likeFunct: () {},
              accontFunct: () {},
            ),
          ),
        ));
      }

      if (i % 2 == 1 && i < forkedExplorer.length) {
        //Get.snackbar("forked", forkedExplorer[i].title.toString());

        daliyInspirationList.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                //   minWidth: Get.width*.5,
                // minHeight: Get.height*.45,
                //   maxHeight: Get.height*.46,
                //  maxWidth: Get.width*.51,
                ),
            child: SmallCardRecipeCard(
              recipeName: forkedExplorer[i].title!,
              recipeImage: forkedExplorer[i].imgPath,
              userName: forkedExplorer[i].username,
                            userAvatar: forkedExplorer[i].userProfileImage,

              ImageFunct: () {
                Get.to(viewMyForkedRecipie(myRecipie: forkedExplorer[i],));

              },
              likeFunct: () {},
              accontFunct: () {},
            ),
          ),
        ));
      }
    }
    ;
    shuffeled.shuffle();

    return shuffeled;
  }

  //Most PopularList
  Future<List<Widget>> addInMostPopularList(
      List<Widget> mostPopularList) async {
    List<user> mostPopular = await usersFollowersQuery();

    for (var i = 0; i < 5; i++) {
      if (i < mostPopular.length) {
        mostPopularList.add(Container(
          // height: Get.height * .27,
          // width: Get.width * .4,
          child: UserDisplay(
            folowers: mostPopular[i].followersNumber!,
            userName: mostPopular[i].username!,
            image: mostPopular[i].userProfileImage,
            funct: () async{
              List<following> userFollowingCount = await readUsersFollowing(userID: mostPopular[i].userID.toString());
     List<following> userFollowersCount =
            await readUsersFollowers(userID: mostPopular[i].userID.toString());
              Get.to(othersProfile(
                listOfFollowersCount:userFollowersCount ,
                listOfFollowingCount: userFollowingCount,
                otherUser: mostPopular[i], 
              ))!.then((value) => Get.delete<OthersProfileController>());
            },
          ),
        ));
      }
    }
    return mostPopularList;
  }

  //following List:

  Future<List<Widget>?> addInFollowingList(
      {List<Widget>? followingList, String? userId}) async {

    List<following> UsersFollowing = await readUsersFollowing(userID: userId);
    List<String> followingID = [];
    List<originalRecipe> originals = [];
    List<forkedRecipe> forks = [];

    List<Widget> originalsWiget = [];
    List<Widget> forksWiget = [];

    for (var i = 0; i < 11; i++) {
      if (i < UsersFollowing.length) {
        followingID.add(UsersFollowing[i].followedUserID!);
      }
    }

    originals = await FollowingRecipies(followingIDs: followingID);
    forks = await FollowingForkedRecipies(followingIDs: followingID);


    for (var i = 0; i < 10; i++) {
      if (i % 2 == 0 && i < originals.length) {
        //Get.snackbar("ortiginal", originals[i].title.toString());
        followingList!.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: SmallCardRecipeCard(
              recipeName: originals[i].title!,
              recipeImage: originals[i].imgPath,
              userName: originals[i].username,
              userAvatar: originals[i].userProfileImage,
              ImageFunct: () {                Get.to(ViewRecipe(myRecipie: originals[i]));
},
              likeFunct: () {},
              accontFunct: () {},
            ),
          ),
        ));
      }

      if (i % 2 == 1 && i < forks.length) {
        //Get.snackbar("forked", forks[i].title.toString());

        followingList!.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                //   minWidth: Get.width*.5,
                // minHeight: Get.height*.45,
                //   maxHeight: Get.height*.46,
                //  maxWidth: Get.width*.51,
                ),
            child: SmallCardRecipeCard(
              recipeName: forks[i].title!,
              recipeImage: forks[i].imgPath!,
              userName: forks[i].username,
                            userAvatar: forks[i].userProfileImage,

              ImageFunct: () {    Get.to(viewMyForkedRecipie(myRecipie: forks[i],));},
              likeFunct: () {},
              accontFunct: () {},
            ),
          ),
        ));
      }
    }
    ;

    return followingList;
  }

  // addInFollowingList() {
  //   followingList.add(Container(
  //     height: Get.height * .3,
  //     width: Get.width * .4,
  //     child: SmallCardRecipeCard(
  //       recipeName: "pancake",
  //       userName: "",
  //       ImageFunct: () {},
  //     ),
  //   ));
  // }

  Future<List<Widget>> exploring(List<Widget> shuffeled) async {
    List<originalRecipe> explorrer = await readAllOriginalRecipies();
    List<forkedRecipe> forkedExplorer = await readAllforkedlRecipies();

    explorrer.shuffle();

    forkedExplorer.shuffle();

    for (var i = 0; i < 10; i++) {
      if (i % 2 == 0 && i < explorrer.length) {
        //Get.snackbar("ortiginal", explorrer[i].title.toString());
        shuffeled.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                //   minWidth: Get.width*.5,
                // minHeight: Get.height*.45,
                //   maxHeight: Get.height*.46,
                //  maxWidth: Get.width*.51,

                ),
            child: SmallCardRecipeCard(
              recipeName: explorrer[i].title!,
              recipeImage: explorrer[i].imgPath,
              userName: explorrer[i].username,
                            userAvatar: explorrer[i].userProfileImage,

              ImageFunct: () {    Get.to(ViewRecipe(myRecipie: explorrer[i]));},
              likeFunct: () {},
              accontFunct: () {},
            ),
          ),
        ));
      }

      if (i % 2 == 1 && i < forkedExplorer.length) {
        //Get.snackbar("forked", forkedExplorer[i].title.toString());

        shuffeled.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                //   minWidth: Get.width*.5,
                // minHeight: Get.height*.45,
                //   maxHeight: Get.height*.46,
                //  maxWidth: Get.width*.51,
                ),
            child: SmallCardRecipeCard(
              recipeName: forkedExplorer[i].title!,
              recipeImage: forkedExplorer[i].imgPath,
              userName: forkedExplorer[i].username,
                            userAvatar: forkedExplorer[i].userProfileImage,

              ImageFunct: () {    Get.to(viewMyForkedRecipie(myRecipie: forkedExplorer[i],));},
              likeFunct: () {},
              accontFunct: () {},
            ),
          ),
        ));
      }
    }
    ;
    shuffeled.shuffle();

    return shuffeled;
  }
}

// mostPopularList.add(Container(
//   height: Get.height * .27,
//   width: Get.width * .4,
//   child: UserDisplay(
//     folowers: 500,
//     userName: "Caven",
//     funct: () {},
//   ),
// ))
