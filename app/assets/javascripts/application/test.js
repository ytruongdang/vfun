(function($){
  console.log("okkoo")
  $(document).ready(function(){
    
    $('.read-more').click(function(){
      if($(this).hasClass('less'))
      {
        $(this).parent().find('.hidden-text').css('overflow', 'hidden');  
        $(this).removeClass('less');
        $(this).text("Read More");
      }else
      {1
        $(this).parent().find('.hidden-text').css('overflow', 'visible');
        $(this).addClass('less'); 
        $(this).text("Read Less") ;
      }
    })
    
    $(document).on("ajax:success", ".vote_like, .vote_dislike", function(e, data, status, xhr){
      if(data.message)
      {
        // console.log(data.path)
        location.href = data.path
      }else{
        var liked = (data.liked? data.liked : 0);
        var disliked = (data.disliked ? data.disliked : 0);
        $('#liked_number').text(liked);
        $('#disliked_number').text(disliked);
      }
    })
    $(window).scroll(function(){
      $('video.video-detail-gif').each(function(){
        var offset = $(this).offset().top - $(window).scrollTop();
        if(offset >= 0 && offset <=450)
        {
          $(this).trigger("play");
          $(this).parent().find('span').css("display", "none");
        }else{
          $(this).trigger("pause");
          $(this).parent().find('span').css("display", "block");
        }
        
      })
      
    });
    $(document).on('click', '.video-thumbnai', function(){
      var video = $(this).find('video.video-detail-gif');
      var icon = $(this).find('span');
      var state = video.data('onplay');
      if(state){
        video.data("onplay", false);
        icon.css("display", "block");
        video.trigger("pause");
      }else{         
        video.data("onplay", true);
        video.trigger("play");
        icon.css("display", "none");
      }
    });
    
  });
  
  
})(jQuery)