// const SERVER_NAME = "172.27.229.36:3007"; // HNI
// const SERVER_NAME = "172.27.40.196:3007"; // HCM
// const SERVER_NAME = "hcm-isurvey.ast.fpt.net"; // HCM
// const SERVER_NAME = "172.27.40.196:3077"; // THICHPV TEST
// const SERVER_NAME = "192.168.1.221:3000";
// const SERVER_NAME = "172.27.131.236:3000";
const SERVER_NAME = "isurvey.ast.fpt.net";
// const SERVER_NAME = "172.27.187.140:3000";
const PROTOCOL = "https";
const SERVER_URL = "$PROTOCOL://$SERVER_NAME";
const GET_TOKEN = "XGdO7A9jvwng2iLxHLZ9bWiQ46yHGpR4";
const POST_TOKEN =
    "McQeThWmZq4t7w!z%C*F-JaNdRgUjXn2r5u8x/A?D(G+KbPeShVmYp3s6v9y\$B&E)H@McQfTjWnZr4t7w!z%C*F-JaNdRgUkXp2s5v8x/A?D(G+KbPeShVmYq3t6w9z\$";
const URL_GET_TICKET = "$PROTOCOL://$SERVER_NAME/api/ticket/";
const URL_GET_SLIDE = "$PROTOCOL://$SERVER_NAME/api/slider/?token=$GET_TOKEN";
const URL_SAVE_SIGNATURE = "$PROTOCOL://$SERVER_NAME/api/signature/store";
