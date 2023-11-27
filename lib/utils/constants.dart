const kAppName = 'surplusbydp';
const kUser = 'kUser';

const kFontFamily = 'Roboto';

//! SERVER
// const httpScheme = 'https';
const httpScheme = 'http';
//! LOCAL

//! SERVER
// const baseUrl = 'surplus-84pe.onrender.com';

//! LOCAL
const baseUrl = '192.168.1.139:5000';
// const baseUrl = '192.168.200.87:5000';

const apiPath = '/api';
const apiVersion = '/v1/user';

const kURL = '$httpScheme://$baseUrl$apiPath$apiVersion';

/// endpoints
const kAuth = '/signIn';
const kSignUp = '/signUp';
const kResetPassword = '/reset/password';
const kPosts = "/posts";
const kCreatePost = "/add/post";
const kUpdatePost = "/update/post";
const kUpdateProfile = "/update/profile";
const kSearchPost = "/search/post";
const kGetUserPosts = "/get/posts";
const kConnect = "/connect";
const kGetChats = "/get/chats";
const kSendMessage = "/send/chat";
const kBlessPost = "/bless/post";
const kGetPost = "/post";
const kUserProfile = "/info";
