function toggle_quote(el_n) {
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
