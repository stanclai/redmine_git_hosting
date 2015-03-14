function post_mode_change(element) {
  if (!element) return;
  var idx = element.selectedIndex;
  if (idx == 0) {
    $('#payload_options').show();
  } else {
    $('#payload_options').hide();
  }
}

function push_mode_change(element) {
  if (!element) return;
  var idx = element.selectedIndex;
  if (idx == 0) {
    $('#ref_spec_options').hide();
  } else {
    $('#ref_spec_options').show();
  }
}

function key_mode_change(element) {
  if (!element) return;
  var idx = element.selectedIndex;
  if (idx == 0) {
    $('#new_key_window').show();
  } else {
    $('#new_key_window').hide();
  }
}

function trigger_mode_change(element) {
  element = $('#'+element.id);
  if(element.is(":checked")) {
    $('#triggers_options').show();
  } else {
    $('#triggers_options').hide();
  }
}

function updateUrl(element) {
  var url = $(element).data('url');
  var target = $(element).data('target');
  var committer = $(element).data('committer');
  $('#git_url_text_' + target).val(url);
  $('#git_url_permissions_' + target).html(committer);
  $(element).parent().find('li').removeClass('selected');
  $(element).addClass('selected');
}

function setFirstGitUrl(elements) {
  $(elements).each(function(index, element){
    var first_url = $(element).children().first();
    updateUrl(first_url);
  });
}

function bindGitUrls(elements) {
  $(elements).each(function(index, element){
    $(element).on('click', function(){
      updateUrl($(this));
    });
  });
}
