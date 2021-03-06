﻿function toggle_quote(el_n) {
  el = document.getElementById(el_n);
  el_add = document.getElementById(el_n + '_add');


  if (!el || !el_add) 
    return false;
  if (el.style && el.style.display=='none') {
    el.style.display='';
    el_add.style.display='none';
  } else {
    el.style.display='none';
    el_add.style.display='';
  }

  el_img = document.images[el_n + '_img'];

  if (!el_img)
    return false;
      
  if (el_img.src.search(/red/i)	 != -1) {
    el_img.src = el_img.src.replace(/red/i, 'orange'); 
    el_img.alt = 'убрать цитату'; 
  } else {
    el_img.src = el_img.src.replace(/orange/i, 'red'); 
    el_img.alt = 'посмотреть цитату'; 
  } 


  return false;
}

function toggle_text(el_n, force, unfold) {
  el = document.getElementById(el_n);
  el_sign = document.getElementById(el_n + '_sign');

  if (!el) 
    return false;

  if (!(force == true)) {
    unfold = (el.style && el.style.display=='none');
  }


  if (unfold) {
    el.style.display='';
    el_sign.childNodes[0].innerText='\u2013';
  } else {
    el.style.display='none';
    el_sign.childNodes[0].innerText='+';
  }

  return false;
}

function toggle_text_all(id_array, unfold) {
  var key;

  for (key in id_array) {
    toggle_text(id_array[key], true, unfold);
  }
  return false;
}



