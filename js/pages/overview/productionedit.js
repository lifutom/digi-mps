function refresh_data() {

    window.location.reload();

}

function form_submit() {
    searchform.submit();
    window.opener.find_row($("#idx").val());
}

function window_close() {
    window.close();
}