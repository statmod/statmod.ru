function highlight_quote(el_n) {
  el = document.getElementById(el_n);

  if (!el_n)
    return false;

  el.className = 'hl';
}

if (location.hash != '') {
  highlight_quote('qa_' + location.hash.substr(1));
}

