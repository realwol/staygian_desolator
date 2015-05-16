$(function(){
  $('.variable_image').dblclick(function(){
    var classString = $(this).attr('class');
    var classNames = classString.split(" ");
    var names = "."+classNames[1];
    $(names).each(function(){
      $(this).next('.hidden_field_value:first').attr('value', '');
      $(this).remove();
    })
  });

  $('.variable_image').mousedown(function(e){
    switch (e.which) {
      case 3:
      $(this).next('.hidden_field_value:first').attr('value', '');
      $(this).remove();
    }
  });

  $('#product_price').change(function(){
    $('.variable_price').val($(this).val());
  });

  $('.product_image').dblclick(function(){
    $(this).next('.product_hidden_field_value:first').attr('value','')
    $(this).remove();
  });

  $('.remove_item').click(function(){
    $("input[name='item']").each(function(){
      if($(this).prop("checked")==true){
        $(this).parents('tr').remove();
      }
    })
    $("input[name='check_all']").prop("checked", false);
  });

  $("input[name='check_all']").click(function(){
    if($(this).prop("checked")==true){
      $("input[name='item']").each(function(){
        $(this).prop("checked",true);
      })
    }else{
      $("input[name='item']").each(function(){
        $(this).prop("checked",false);
      })
    }
  });

  $("input[name='item']").click(function(){
    var all_checked = true;
    $("input[name='item']").each( function(){
      if($(this).prop("checked")==false){
        all_checked = false;
      }
    })
    if(all_checked){
      $("input[name='check_all']").prop("checked", true);
    }
    if($(this).prop('checked')==false){
      $("input[name='check_all']").prop('checked',false);
    }
  });

  $('.remove_variable').click(function(){
    $(this).parents('tr').remove();
  });

  $('#ul-sortable').sortable({
    placeholder: "ui-state-default"
  });

  $('#ul-sortable').mouseout(function(){
    $('.hidden_field_value').each(function(i,l){
      i = i + 1;
      $(this).attr('name',"variable[][image_url"+i+"]");
    })
  });

  $('#ul-sortable').disableSelection();

  $('.variable_image').click(function(){
    var classString = $(this).attr('class');
    var classNames = classString.split(" ");
    var names = "."+classNames[1];
    $(names).each(function(){
      $(this).css("border","2px solid red");
    })
  });

  $.fn.datetimepicker.dates['en'] = {
      // days: ["Sunday1", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"],
      // daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
      daysMin: ["日", "一", "二", "三", "四", "五", "六"],
      months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
      monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
      today: "今天",
      todayHighlight: true
  };

  $('#datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd',
    language: 'zh-CN',
    minView: "month",
    autoclose: true
  });

  $('#check_button').click(function(){
    var link = $(this).data('link');
    var notice = $('#check_notice');
    var shop_id = $('#test_links').val();
    $.get( link, {
      shop_id : shop_id
    }).success(function(json){
      if(json==1){
        notice.css({'display':'block', 'color':'green'});
        notice.text('店铺尚未抓取');
        return
      }else if(json==0){
        notice.css({'display':'block', 'color':'red'});
        notice.text('店铺已被抓取');
        return
      }
    })
  })

})
