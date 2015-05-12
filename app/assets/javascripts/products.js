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

  $('#datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd'
  });

})
