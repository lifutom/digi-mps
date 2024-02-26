/* Version 1.0 */
function add2cart(id) {

    var cnt = $('#cnt' + id.toString()).val();
    var locationid = $('#locationid' + id.toString()).val();

    $('#actcnt').val(cnt);
    $('#sparepartid').val(id);
    $('#locationid').val(locationid);
    $('#form').submit();

}