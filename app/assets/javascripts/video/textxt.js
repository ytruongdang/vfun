var cache = {};
function googleSuggest(request, response) {
    var term = request.term;
    if (term in cache) { response(cache[term]); return; }
    $.ajax({
        url: '/videos/tags_ajax',
        dataType: 'JSON',
        data: { q: term },
        success: function(data) {
            cache[term] = data;
            response(data);
        }
    });
}
function upload_video()
{
    var form = $('#new_video');
    var wrapper = form.find('.progress-wrapper');
    var bitrate = wrapper.find('.bitrate');
    var progress_bar = wrapper.find('.progress-bar');
    var video_upload_id = $('#video_attachment_id');
    form.fileupload({
      dataType: 'json',
      // dropZone: $('#dropzone'),
      add: function (e, data) {
        types = /(\.|\/)(mp4|webm)$/i;
        file = data.files[0];
        if (types.test(file.type) || types.test(file.name)) {
          data.submit();
        }
        else { alert(file.name + " must be MP4, WEBM"); }
      },
    });

    form.on('fileuploaddone', function(e, data) {   
        // console.log(data.result);     
        response = (data.result);
        console.log(response.id);
        video_upload_id.val(response.id);
        wrapper.hide();
        // progress_bar.width(0);
    });

    form.on('fileuploadprogressall', function (e, data) {
        wrapper.show();
        bitrate.text((data.bitrate / 1024).toFixed(2) + 'Kb/s');
        var progress = parseInt(data.loaded / data.total * 100, 10);
        progress_bar.css('width', progress + '%').text(progress + '%');
    });
    
}
    (function($){
        $(document).ready(function(){
            $('#video_tag_list').tagEditor({ autocomplete: { source: googleSuggest, minLength: 3 } });
            upload_video();
    })
})(jQuery)