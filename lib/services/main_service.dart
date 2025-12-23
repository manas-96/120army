// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onetwentyarmyprayer2/services/local_notification_service.dart';

import '../baseurls.dart';
import '../exports.dart';
import '../main.dart';
import '../model/accountdelete_model.dart';
import '../model/addfriend_model.dart';
import '../model/challenges_model.dart';
import '../model/commentlist_model.dart';
import '../model/confirm_model.dart';
import '../model/count_notification_model.dart';
import '../model/createpost_model.dart';
import '../model/deletepost_model.dart';
import '../model/forgotpassword_model.dart';
import '../model/like_unlike_model.dart';
import '../model/listpost_model.dart';
import '../model/login_model.dart';
import '../model/notification_list_model.dart';
import '../model/other_profile_model.dart';
import '../model/otp__verify_model.dart';
import '../model/otp_model.dart';
import '../model/photoslist_model.dart';
import '../model/profile_model.dart';
import '../model/profileupdate_model.dart';
import '../model/pushpost_model.dart';
import '../model/refresh_token_model.dart';
import '../model/register_model.dart';
import '../model/reward_tasklist_model.dart';
import '../model/rewards_level_model.dart';
import '../model/rewardupdate_model.dart';
import '../model/successprayerchallenges_model.dart';
import '../model/suggest_friend_list_model.dart';
import '../model/suggest_friend_remove_model.dart';
import '../model/updatenotification_model.dart';
import '../model/weeklypc_model.dart';
import '../shared_pref.dart';
import 'pusher.dart';

class MainService {
  // ================================ Register =========================
  Future<Registermodel?> registerService({
    first_name,
    last_name,
    email,
    type,
    phone_no,
    country_code,
    gender,
    date_of_birth,
    password,
    timezone,
  }) async {
    return _safeApiCall(() async {
      final Map<String, String> body = {
        "first_name": first_name.toString(),
        "last_name": last_name.toString(),
        "type": type.toString(),
        "gender": gender.toString().toLowerCase(),
        "date_of_birth": date_of_birth.toString(),
        "password": password.toString(),
        "timezone": timezone.toString(),
      };

      if (type == "email") {
        body["email"] = email.toString();
      } else if (type == "phone") {
        body["phone_no"] = phone_no.toString();
        body["country_code"] = '+${country_code.toString()}';
      }

      final response = await http.post(
        Uri.parse(registerApi),
        headers: apiHeader,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Registermodel.fromJson(decoded);
    });
  }

  // ================================ OTP =========================
  Future<Otpmodel?> otpService({String? user_id}) async {
    return _safeApiCall(() async {
      final Map<String, String> body = {"user_id": user_id.toString()};

      final response = await http.post(
        Uri.parse(otpApi),
        headers: apiHeader,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Otpmodel.fromJson(decoded);
    });
  }

  // ================================ Verify OTP =========================
  Future<Otpverifymodel?> otpverifyService({otp, user_id, type}) async {
    return _safeApiCall(() async {
      final Map<String, String> body = {
        "otp": otp.toString(),
        "user_id": user_id.toString(),
        "type": type.toString(),
      };

      final response = await http.post(
        Uri.parse(otpVerify),
        headers: apiHeader,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Otpverifymodel.fromJson(decoded);
    });
  }

  // ================================ Login =========================
  Future<Loginmodel?> loginService({username, password, device_token}) async {
    return _safeApiCall(() async {
      final Map<String, String> body = {
        "username": username,
        "password": password,
        "device_token": device_token,
        "platform": "android",
      };

      final response = await http.post(
        Uri.parse(loginApi),
        headers: apiHeader,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Loginmodel.fromJson(decoded);
    });
  }

  // ================================ Profile =========================
  Future<Profilemodel?> profileService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final response = await http.get(Uri.parse(profileApi), headers: headers);

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Profilemodel.fromJson(decoded);
    });
  }

  // ================================ Profile Update =========================

  Future<Profileupdatemodel?> profileupdateService({
    required int formnum,
    String? first_name,
    String? last_name,
    String? bio,
    String? phone_no,
    String? email,
    String? gender,
    String? date_of_birth,
    String? language,
    String? places_lived,
    String? image,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");

      final headers = {"Authorization": "$token", "Accept": "application/json"};
      if (formnum == 1 || formnum == 2) {
        final request = http.MultipartRequest(
          "PATCH",
          Uri.parse(profileupdateApi),
        );
        request.headers.addAll(headers);
        request.fields[formnum == 1 ? 'cover_image' : 'profile_image'] = 'true';

        if (image != null && image.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath('image', image));
        } else {
          request.fields['image'] = '';
        }

        final response = await http.Response.fromStream(await request.send());
        _checkUnauthenticated(response);
        return Profileupdatemodel.fromJson(json.decode(response.body));
      }

      final jsonHeaders = {...headers, "Content-Type": "application/json"};

      final body = <String, dynamic>{};

      switch (formnum) {
        case 3:
          if (bio != null) body["bio"] = bio;
          break;
        case 4:
          body["first_name"] = first_name ?? '';
          body["last_name"] = last_name ?? '';
          break;
        case 5:
          body["gender"] =
              (gender ?? '').toLowerCase() == "male" ? "male" : "female";
          body["date_of_birth"] = date_of_birth ?? '';
          body["language"] = language ?? '';
          break;
        case 6:
          body["places_lived"] = places_lived ?? '';
          break;
        case 7:
          String? emailLogin =
              SharedPrefUtils.getCachedStr("emailLogin") ?? "0";

          if (emailLogin == "0") {
            // Show Mobile, update only phone_no
            body["phone_no"] = phone_no ?? '';
          } else {
            // Show Email, update only email
            body["email"] = email ?? '';
          }

          break;
        default:
          break;
      }

      final response = await http.patch(
        Uri.parse(profileupdateApi),
        headers: jsonHeaders,
        body: jsonEncode(body),
      );

      _checkUnauthenticated(response);
      return Profileupdatemodel.fromJson(json.decode(response.body));
    });
  }

  // ================================RewardsList=========================

  Future<Rewardtasklist?> rewardlistService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final response = await http.get(
        Uri.parse(rewardtasklistApi),
        headers: headers,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Rewardtasklist.fromJson(decoded);
    });
  }

  // ================================ Rewardslevel =========================
  Future<Rewardlevelmodel?> rewardlevelService({String? userId}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      // Build URL depending on userId
      final url =
          (userId != null && userId.isNotEmpty)
              ? "$rewardlevelApi?user_id=$userId"
              : rewardlevelApi;

      final response = await http.get(Uri.parse(url), headers: headers);

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Rewardlevelmodel.fromJson(decoded);
    });
  }

  // ================================ Rewardsupdate =========================

  Future<Rewardupdate?> rewardupdateService(reward_id, task_id) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "reward_id": reward_id.toString(),
        "task_id": task_id.toString(),
      };

      final response = await http.patch(
        Uri.parse(rewardupdateApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Rewardupdate.fromJson(decoded);
    });
  }

  // ================================ Weeklyprayerchallenge =========================
  Future<Weeklypcmodel?> weeklypcService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final response = await http.get(
        Uri.parse(prayerchallengesApi),
        headers: headers,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Weeklypcmodel.fromJson(decoded);
    });
  }

  // ================================challenges ====================================================
  Future<Challengesmodel?> challengesService({String? userId}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      // Build the URL depending on whether userId is provided
      final url =
          userId != null && userId.isNotEmpty
              ? "$challengesApi?user_id=$userId"
              : challengesApi;

      final response = await http.get(Uri.parse(url), headers: headers);

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Challengesmodel.fromJson(decoded);
    });
  }

  // ====================================================Successprayerchallenges======================

  Future<Successprayerchallengesmodel?> successprayerchallengeService({
    prayer_id,
    challenge_id,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "prayer_id": prayer_id.toString(),
        "challenge_id": challenge_id.toString(),
      };

      final response = await http.patch(
        Uri.parse(successprayerchallengesApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Successprayerchallengesmodel.fromJson(decoded);
    });
  }

  // ================================ suggest-friend-list =========================
  Future<Suggestfriendlistmodel> suggestfriendlistService({
    int page = 1,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse('${suggestfriendApi}page=$page');

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Suggestfriendlistmodel.fromJson(decoded);
    });
  }

  // ================================ remove-suggest-friend-list =========================

  Future<Suggestfriendremovemodel?> suggestfriendremoveService({
    remove_user_id,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "remove_user_id": remove_user_id.toString(),
      };

      final response = await http.post(
        Uri.parse(removesuggestfriendApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Suggestfriendremovemodel.fromJson(decoded);
    });
  }

  // ================================ remove-suggest-friend-list =========================

  Future<Addfriendmodel?> addfriendService({friend_id}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {"friend_id": friend_id.toString()};

      final response = await http.post(
        Uri.parse(addfriendApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Addfriendmodel.fromJson(decoded);
    });
  }

  // ================================ friend-request-list =========================
  Future<Suggestfriendlistmodel> friendrequestlistService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse(friendrequestlistApi);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Suggestfriendlistmodel.fromJson(decoded);
    });
  }

  // ================================ confirm-friend-request =========================
  Future<Confirmmodel> confirmService({friend_id, required status}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "friend_id": friend_id.toString(),
        "status": status,
      };

      final response = await http.post(
        Uri.parse(confirmApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Confirmmodel.fromJson(decoded);
    });
  }

  // ================================ cancel-friendrequest =========================

  Future<Suggestfriendremovemodel?> cancelfriendService({friend_id}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {"friend_id": friend_id.toString()};

      final response = await http.delete(
        Uri.parse(cancelfriendrequest),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Suggestfriendremovemodel.fromJson(decoded);
    });
  }

  // ====================================================searchfriendlist======================

  Future<Suggestfriendlistmodel> searchfriendlistService({
    int page = 1,
    String search = "",
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final uri = Uri.parse('${searchfriendlist}page=$page&search=$search');

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Suggestfriendlistmodel.fromJson(decoded);
    });
  }

  // ================================ friend-list =========================
  Future<Suggestfriendlistmodel> friendlistService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse(friendlist);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Suggestfriendlistmodel.fromJson(decoded);
    });
  }

  // ================================ createpost =========================

  Future<Createpostmodel> createpostService({
    required String type,
    required String tagged_user_ids,
    required String location,
    required String privacy,
    required String post,
    required List<String> filePaths,
    required Function(double) onProgress,
    required String notification_type,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");

      Dio dio = Dio();
      dio.options.headers = {...apiHeader, "Authorization": "$token"};

      // Base form data
      final Map<String, dynamic> formMap = {
        "post": post,
        "type": type,
        "privacy": privacy,
        "location": location,
        "tagged_user_ids": tagged_user_ids.toString(),
        "notification_type": notification_type,
      };

      // Add multiple files if any
      if (filePaths.isNotEmpty) {
        formMap["post_files"] = [
          for (var path in filePaths)
            await MultipartFile.fromFile(
              path,
              filename: path.split('/').last.toString(),
            ),
        ];
      }

      FormData formData = FormData.fromMap(formMap);

      final dioResponse = await dio.post(
        createPost,
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            onProgress((sent / total) * 100);
          }
        },
      );

      // Convert to http.Response for compatibility
      final httpResponse = http.Response(
        dioResponse.data is String
            ? dioResponse.data
            : jsonEncode(dioResponse.data),
        dioResponse.statusCode ?? 0,
        headers: Map<String, String>.from(
          dioResponse.headers.map.map((k, v) => MapEntry(k, v.join(','))),
        ),
      );

      _checkUnauthenticated(httpResponse);

      return Createpostmodel.fromJson(dioResponse.data);
    });
  }

  // ==============================================================post=list=================================================

  Future<Postdatalist> postListService({int page = 1}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse('${postList}page=$page');

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Postdatalist.fromJson(decoded);
    });
  }

  // ================================ deletepost =========================

  Future<Deletepost?> deletepostService({id}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {"id": id.toString()};

      final response = await http.delete(
        Uri.parse(deletePost),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Deletepost.fromJson(decoded);
    });
  }

  // ==============================================================otherprofile=================================================

  Future<Otherprofilemodel?> otherprofileService({String? userId}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      // Build URL dynamically
      final url =
          (userId != null && userId.isNotEmpty)
              ? "$otherprofile?user_id=$userId"
              : otherprofile;

      final uri = Uri.parse(url);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Otherprofilemodel.fromJson(decoded);
    });
  }

  // =========================================Commentlist===============================================

  Future<Commentlistmodel> commentListService({postid}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse('$commentslistApi?post_id=$postid');

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Commentlistmodel.fromJson(decoded);
    });
  }

  // ==============================================================photolist=================================================

  Future<Photoslist?> photoslistService({String? userId}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      // Build URL depending on userId
      final url =
          (userId != null && userId.isNotEmpty)
              ? "$medialistApi?user_id=$userId"
              : medialistApi;

      final uri = Uri.parse(url);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Photoslist.fromJson(decoded);
    });
  }

  // ===================================comment=post=======================

  Future<Createpostmodel?> commentpostService({
    required post,
    required parent_post_id,
    required main_post_id,
    required parent_type,
    required author_id,
    required notification_type,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "post": post,
        "type": "comment",
        "privacy": "public",
        "parent_post_id": parent_post_id,
        "main_post_id": main_post_id,
        "parent_type": parent_type,
        "author_id": author_id,
        "notification_type": notification_type,
      };

      final response = await http.post(
        Uri.parse(createPost),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Createpostmodel.fromJson(decoded);
    });
  }

  // ===================================like=unlike=======================

  Future<Likeunlikepostmodel?> likeunlikeService({
    required int id,
    required bool isLiked,
    required String author_id,
    required String type,
    required String author_name,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "id": id.toString(),
        "author_id": author_id,
        "type": type,
        "author_name": author_name,
      };

      // jodi already like kora thake tahole unlike call hobe
      final apiUrl = isLiked ? unlikepostApi : likepostApi;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);
      return Likeunlikepostmodel.fromJson(decoded);
    });
  }

  Future<Postdatalist> reelsListService({int page = 1}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse('${postList}page=$page&type=reels');

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Postdatalist.fromJson(decoded);
    });
  }

  // ================================ accoutdelete =========================

  Future<Accountdelete?> deleteaccountApiService({password}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {"password": password.toString()};

      final response = await http.delete(
        Uri.parse(deleteaccountApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Accountdelete.fromJson(decoded);
    });
  }

  // ============================================================Forgotpassword==============================

  Future<ForgotpasswordModel> forgotpasswordService({username}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {"username": username.toString()};

      final response = await http.post(
        Uri.parse(forgotpasswordApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return ForgotpasswordModel.fromJson(decoded);
    });
  }

  // ============================================================resetpassword==============================

  Future<Accountdelete> resetpasswordService({
    new_password,
    confirm_new_password,
    user_id,
  }) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final Map<String, String> body = {
        "new_password": new_password.toString(),
        "confirm_new_password": confirm_new_password.toString(),
        "user_id": user_id.toString(),
      };

      final response = await http.post(
        Uri.parse(resetpasswordApi),
        headers: headers,
        body: body,
      );

      _checkUnauthenticated(response);
      final decoded = json.decode(response.body);
      return Accountdelete.fromJson(decoded);
    });
  }

  // ==============================================================view-post=================================================

  Future<Pushpostmodel> viewpostService({required post_id}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse('$viewpostApi?post_id=$post_id');

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      // print("Hello worlld");
      // print(response.body);

      return Pushpostmodel.fromJson(decoded);
    });
  }

  // ==============================================================notification-list=================================================

  Future<Notificationlistmodel> notificationlistService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse(notificationlistApi);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Notificationlistmodel.fromJson(decoded);
    });
  }

  // ==============================================================notification-count=================================================

  Future<Countnotificationmodel> notificationcountService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse(notificationcountApi);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Countnotificationmodel.fromJson(decoded);
    });
  }

  // ==============================================================count-friend-request=================================================

  Future<Countnotificationmodel> countfriendrequestService() async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};

      final uri = Uri.parse(countfriendrequestreceivedApi);

      final response = await http.get(uri, headers: headers);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Countnotificationmodel.fromJson(decoded);
    });
  }

  // ==============================================================update-notification=================================================

  Future<Updatenotification> updatenotificationService({required id}) async {
    return _safeApiCall(() async {
      final token = await SharedPrefUtils.readPrefStr("accessToken");
      final headers = {...apiHeader, "Authorization": "$token"};
      final uri = Uri.parse(updatenotificationApi);

      final Map<String, String> body = {"id": id.toString()};

      final response = await http.post(uri, headers: headers, body: body);
      _checkUnauthenticated(response);

      final decoded = json.decode(response.body);

      return Updatenotification.fromJson(decoded);
    });
  }

  // =====================================================pusher===================================================

  // Future<dynamic> isonlinedService({required bool is_online}) async {
  //   return _safeApiCall(() async {
  //     final token = await SharedPrefUtils.readPrefStr("accessToken");

  //     final headers = {"Authorization": "$token", "Accept": "application/json"};
  //     final body = {"is_online": is_online.toString()};

  //     final response = await http.post(
  //       Uri.parse(isonlineApi),
  //       headers: headers,
  //       body: body,
  //     );

  //     _checkUnauthenticated(response);
  //     final decoded = json.decode(response.body);
  //     return decoded;
  //   });
  // }

  void pusherConnect(String userId) {
    PusherService.instance.initPusher(userId: userId);
  }

  // ====================================================alarmpost======================

  void ensureStaticAlarmExists() async {
    final box = Hive.box('alarmBox');
    List alarmList = box.get('alarmList', defaultValue: []);

    final staticTime = '13:20:00';
    final staticType = 2;

    final staticGroupExists = alarmList.any(
      (group) =>
          group['type'] == staticType &&
          group['data'].isNotEmpty &&
          group['data'].first['alarm_time'] == staticTime,
    );

    if (!staticGroupExists) {
      alarmList.insert(0, {
        'type': staticType,
        'data': [
          {'day': 'sun', 'alarm_time': staticTime, 'is_show': true},
          {'day': 'mon', 'alarm_time': staticTime, 'is_show': true},
          {'day': 'tue', 'alarm_time': staticTime, 'is_show': true},
          {'day': 'wed', 'alarm_time': staticTime, 'is_show': true},
          {'day': 'thu', 'alarm_time': staticTime, 'is_show': true},
          {'day': 'fri', 'alarm_time': staticTime, 'is_show': true},
          {'day': 'sat', 'alarm_time': staticTime, 'is_show': true},
        ],
      });

      await box.put('alarmList', alarmList);
      // print("✅ Static 1:20 PM alarm inserted");
      scheduleAlarmsFromHive(); // Schedule it immediately
    }
  }

  void alarmpostService(Map<String, dynamic> payload) async {
    final box = Hive.box('alarmBox');
    List alarmList = box.get('alarmList', defaultValue: []);

    int newType = payload['type'];
    List newData = payload['data'];

    // Get the unique time from the new group (assume all have same time)
    String newTime = newData.first['alarm_time'];

    bool merged = false;

    for (var group in alarmList) {
      if (group['type'] == newType) {
        // Check time match: all alarms in group should have same time
        String groupTime = group['data'].first['alarm_time'];
        if (groupTime == newTime) {
          group['data'].addAll(newData);
          merged = true;
          break;
        }
      }
    }

    if (!merged) {
      alarmList.add(payload);
    }

    await box.put('alarmList', alarmList);

    // printRawAlarmJson();
    scheduleAlarmsFromHive();
  }

  // void printRawAlarmJson() {
  //   final box = Hive.box('alarmBox');
  //   final alarmList = box.get('alarmList', defaultValue: []);
  //   print("📦 JSON: ${alarmList}");
  //   print("📦 JSON String:\n${jsonEncode(alarmList)}");
  // }

  void scheduleAlarmsFromHive() async {
    final box = Hive.box('alarmBox');
    final alarmList = box.get('alarmList', defaultValue: []);

    for (int groupIndex = 0; groupIndex < alarmList.length; groupIndex++) {
      final group = alarmList[groupIndex];
      final data = group['data'] ?? [];

      for (int alarmIndex = 0; alarmIndex < data.length; alarmIndex++) {
        final alarm = data[alarmIndex];
        final isShow = alarm['is_show'] == true;
        final id = groupIndex * 100 + alarmIndex;

        if (!isShow) {
          // Cancel if no longer to be shown
          await NotificationService.cancelNotification(id);
          continue;
        }

        final day = alarm['day'];
        final timeStr = alarm['alarm_time']; // Example: "13:23:00"
        final parts = timeStr.split(':');
        if (parts.length < 2) continue;

        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;

        // Format to 12-hour with AM/PM and no seconds
        final displayHour = hour % 12 == 0 ? 12 : hour % 12;
        final ampm = hour >= 12 ? 'PM' : 'AM';
        final formattedTime =
            '$displayHour:${minute.toString().padLeft(2, '0')} $ampm';

        final scheduledTime = _getNextDateTime(day, hour, minute);

        await NotificationService.scheduleNotification(
          id: id,
          title: '120 Army',
          body: "Hey friends, it's $formattedTime. Let's pray together! 🙏",
          scheduledTime: scheduledTime,
        );
      }
    }
  }

  DateTime _getNextDateTime(String dayStr, int hour, int minute) {
    final now = DateTime.now();
    final weekdays = {
      'sun': DateTime.sunday,
      'mon': DateTime.monday,
      'tue': DateTime.tuesday,
      'wed': DateTime.wednesday,
      'thu': DateTime.thursday,
      'fri': DateTime.friday,
      'sat': DateTime.saturday,
    };

    final targetWeekday = weekdays[dayStr.toLowerCase()] ?? now.weekday;
    DateTime targetDate = DateTime(now.year, now.month, now.day, hour, minute);

    // Move to next week if today is past or not the same day
    while (targetDate.weekday != targetWeekday || targetDate.isBefore(now)) {
      targetDate = targetDate.add(Duration(days: 1));
    }

    return targetDate;
  }

  // ============================ Refresh Token ===========================
  Future<Refreshtokenmodel?> refreshTokenService() async {
    // print("Calling refreshTokenService");
    final refreshToken = await SharedPrefUtils.readPrefStr("refreshToken");

    if (refreshToken == null) throw Exception("No refresh token found");

    final response = await http.post(
      Uri.parse(regeneratetokensApi),
      headers: apiHeader,
      body: {"refresh_token": refreshToken},
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final model = Refreshtokenmodel.fromJson(decoded);

      await SharedPrefUtils.saveStr("accessToken", model.data.accessToken);
      await SharedPrefUtils.saveStr("refreshToken", model.data.refreshToken);

      return model;
    } else {
      await _handleUnauthenticated();
      return null;
      // throw Exception("Unable to refresh token");
    }
  }

  void _checkUnauthenticated(http.Response response) {
    if (response.statusCode == 401) throw UnauthenticatedException();
  }

  Future<T> _safeApiCall<T>(
    Future<T> Function() apiCall, {
    Duration timeout = const Duration(seconds: 40),
    bool retrying = false,
  }) async {
    try {
      return await apiCall().timeout(timeout);
    } on TimeoutException {
      throw Exception("Request timed out. Please try again later.");
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on HttpException catch (e) {
      throw Exception("HTTP Error: ${e.message}");
    } on FormatException {
      throw Exception("Bad response format. Unable to parse data.");
    } catch (e) {
      if (e is UnauthenticatedException && !retrying) {
        await refreshTokenService();
        return await _safeApiCall(apiCall, retrying: true);
      }
      throw Exception("Unexpected error: $e");
    }
  }
}

class UnauthenticatedException implements Exception {
  @override
  String toString() => "Unauthenticated: Access token may have expired.";
}

// ============================ Utilities ===========================
Future<void> _handleUnauthenticated() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();

  Future.delayed(Duration.zero, () {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  });

  // print("Session expired. Redirecting to login.");
}
