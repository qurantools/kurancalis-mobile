var config_module = angular.module('myConfig', []);

//var domain = "http://kurancalis.com";
//var domain = "http://kurancalis.com";
var domain = "http://kurancalis.com";
//var domain = "http://kurancalis.com";

var config_data = {
    'webServiceUrl': 'https://securewebserver.net/jetty/qt/rest',
    //'webServiceUrl': 'https://securewebserver.net/jetty/qt/rest',
    'webAddress': domain,
    'mobileAddress': domain+'/m/www',
    'mobileLoginCallbackAddress': domain +'/m/www/components/mobile_auth/login_callback.html',
    'FBAppID': '295857580594128',
    //'FBAppID': '506964319483452',
    'clientSecret':'8387ff88dfd5c632d6c64059ab3fcebb',
    'version':"2.0",
    'isMobile':isMobile(),
    'isNative':isNative(),
    'isAndroid':isAndroid(),
    'isIOS':isIOS(),
    'translationTableCount': 139055
}

var MAX_AUTHOR_MASK = "18446744073709551615"; //64 authors
var DEFAULT_TURKISH_AUTHOR_MASK = "412317382160";
var DIYANET_AUTHOR_ID = "8192";

function isMobile() {
    //test for mobile
    var mobileTest = false;
    if (mobileTest == true) {
        return true;
    } else {
        if (navigator.userAgent.match(/Android/i)
            || navigator.userAgent.match(/webOS/i)
            || navigator.userAgent.match(/iPhone/i)
            || navigator.userAgent.match(/iPad/i)
            || navigator.userAgent.match(/iPod/i)
            || navigator.userAgent.match(/BlackBerry/i)
            || navigator.userAgent.match(/Windows Phone/i)
        ) {
            return true;
        }
        else {
            return false;
        }
    }
}

function isNative(){
    return (document.URL.indexOf( 'http://' ) === -1 && document.URL.indexOf( 'https://' ) === -1);
}

function isAndroid(){
    return (navigator.userAgent.match(/Android/i));
}

function isIOS(){
    return (navigator.userAgent.match(/webOS/i)
            || navigator.userAgent.match(/iPhone/i)
            || navigator.userAgent.match(/iPad/i)
            || navigator.userAgent.match(/iPod/i));
}