Map<String, String> apiHeader = {
  "Accept": "application/json",
  "Content-Type": "application/x-www-form-urlencoded",
};

const baseUrl = "https://staging.120connect.com/api/";
const registerApi = '$baseUrl/app/register';
const otpApi = '$baseUrl/app/resend-otp';
const otpVerify = '$baseUrl/app/verify-otp';
const loginApi = '$baseUrl/app/login';
const profileApi = '$baseUrl/app/profile';
const profileupdateApi = '$baseUrl/app/update-profile';
const regeneratetokensApi = '$baseUrl/app/regenerate-tokens';
const rewardtasklistApi = '$baseUrl/app/reward-task';
const rewardlevelApi = '$baseUrl/app/reward';
const rewardupdateApi = '$baseUrl/app/update-task';
const challengesApi = '$baseUrl/app/challenges';
const prayerchallengesApi = '$baseUrl/app/prayer-challenges';
const successprayerchallengesApi = '$baseUrl/app/update-challenge';
const alarmlistApi = '$baseUrl/app/alarm';
const alarmpostApi = '$baseUrl/app/set-alarm';
const suggestfriendApi = '$baseUrl/app/suggest-friend?';
const removesuggestfriendApi = '$baseUrl/app/remove-suggested-friend';
const addfriendApi = '$baseUrl/app/send-friend-request';
const friendrequestlistApi = '$baseUrl/app/friend-request-received';
const confirmApi = '$baseUrl/app/update-friend-request';
const cancelfriendrequest = '$baseUrl/app/cancel-friend-request';
const searchfriendlist = '$baseUrl/app/search-friend?';
const friendlist = '$baseUrl/app/friend-list';
const createPost = '$baseUrl/app/create-post';
const postList = '$baseUrl/app/all-post?';
const deletePost = '$baseUrl/app/delete-post';
const otherprofile = '$baseUrl/app/user-profile';
const medialistApi = '$baseUrl/app/user-media-list';
const commentslistApi = '$baseUrl/app/get-post-comments';
const likepostApi = '$baseUrl/app/like-post';
const unlikepostApi = '$baseUrl/app/unlike-post';
const deleteaccountApi = '$baseUrl/app/delete-account';
const forgotpasswordApi = '$baseUrl/app/forgot-password';
const resetpasswordApi = '$baseUrl/app/reset-password';
const viewpostApi = '$baseUrl/app/view-post';
const notificationlistApi = '$baseUrl/app/notification';
const notificationcountApi = '$baseUrl/app/count-notification';
const countfriendrequestreceivedApi =
    '$baseUrl/app/count-friend-request-received';
const updatenotificationApi = '$baseUrl/app/update-notification';
// =======================================================
const pusherauthApi = '$baseUrl/pusher/auth';
