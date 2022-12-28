import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forked/Models/User.dart';
import 'package:get/get.dart';
import 'package:forked/Routes/Router.dart';
import 'Models/following.dart';
import 'Models/forkedRecipe.dart';
import 'Models/likedRecipe.dart';
import 'Models/originalRecipie.dart';
import 'Models/savedRecipe.dart';
import 'firebase_options.dart';

  user myUserData=user();
  List<originalRecipe> userOriginalRecipies =[];
   List<forkedRecipe> userForkedRecipeRecipies =[];
  List<likedRecipe> usersLikedRecipies =[];
  List<savedRecipe> userSavedRecipies =[];
  List<following> userFollowing = [];
  List<following> userFollowers =[];
main()async {

   WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: NamedRoute.StratingPage,
       getPages: appRoutes,



        // home:Home(),

//  home: createRecipe(

// steps: [

//   SizedBox(),
//     SizedBox(),

//   SizedBox(),

// ],
// ingredients: [

//   SizedBox(),

//   SizedBox(),

// ],

//  ),
//  //home: ProfilEdiet(),
    );
  }
}
