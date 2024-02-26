function setCookie(key, value) {
    /*var expires = new Date();
    expires.setTime(expires.getTime() + 31536000000); //1 year
    document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();*/
    Cookies.set(key, value, {expires: 365*10});
}

function getCookie(key) {
    /*var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
    return keyValue ? keyValue[2] : null;*/
    return Cookies.get(key);
}

function deleteCookie(key) {
    Cookies.set(key,'');
}