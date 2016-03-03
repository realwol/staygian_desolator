$(function(){
  $('#product_price').change(function(){
    $('.variable_price').val($(this).val());
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
    var variable_id = $(this).data('variable-id');
    $.ajax({
      url: '/variables/remove_variable',
      data: {variable_id: variable_id},
      type: 'delete',
      success: function(){
        alert('操作成功！');
      }
    })
  });

  // $('#ul-sortable').sortable({
  //   placeholder: "ui-state-default"
  // });

  // $('#ul-sortable').mouseout(function(){
  //   $('.hidden_field_value').each(function(i,l){
  //     i = i + 1;
  //     $(this).attr('name',"variable[][image_url"+i+"]");
  //   })
  // });

  // $('#ul-sortable').disableSelection();

  // $('.variable_image').mousedown(function(e){
  //   var flag = $(this).attr("src");
  //   var src = $(this).data("src");
  //   if(flag==''){
  //     switch (e.which) {
  //       case 3:
  //       $(this).next('.hidden_field_value:first').attr('value', src);
  //       $(this).attr('src', src);
  //     }
  //   }else{
  //     switch (e.which) {
  //       case 3:
  //       $(this).next('.hidden_field_value:first').attr('value', '');
  //       $(this).attr('src','');
  //     }
  //   }
  // });


  $('#datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd',
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
