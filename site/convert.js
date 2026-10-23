// Uzbek script converter: Kirill (cyr), Lotin (lat, official oʻ gʻ sh ch)
// and Yangi lotin (new, ö ğ ş ç). Lotin is the pivot between the others.
// Works in the browser (window.UzConvert) and in Node (module.exports).
(function (root) {
  'use strict';

  var OKINA = 'ʻ'; // ʻ in oʻ, gʻ
  var TUTUQ = 'ʼ'; // ʼ tutuq belgisi
  var QUOTES = "'‘’ʻʼ`";

  function isQuote(ch) { return !!ch && QUOTES.indexOf(ch) >= 0; }
  function isUpper(ch) { return ch !== ch.toLowerCase() && ch === ch.toUpperCase(); }
  function isLetter(ch) { return !!ch && ch.toLowerCase() !== ch.toUpperCase(); }

  // Case for a multi-letter replacement of an uppercase source letter:
  // "SH" inside an all-caps word, "Sh" otherwise.
  function applyCase(out, src, prev, next) {
    if (!isUpper(src)) return out;
    if (out.length > 1 && !isUpper(next || '') && !(isUpper(prev || '') && !isLetter(next || ''))) {
      return out.charAt(0).toUpperCase() + out.slice(1);
    }
    return out.toUpperCase();
  }

  // ---------- Kirill -> Lotin ----------
  var CYR = {
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'ж': 'j', 'з': 'z', 'и': 'i',
    'й': 'y', 'к': 'k', 'л': 'l', 'м': 'm', 'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r',
    'с': 's', 'т': 't', 'у': 'u', 'ф': 'f', 'х': 'x', 'ч': 'ch', 'ш': 'sh', 'щ': 'sh',
    'ъ': TUTUQ, 'ы': 'i', 'ь': '', 'э': 'e', 'ю': 'yu', 'я': 'ya', 'ё': 'yo',
    'ў': 'o' + OKINA, 'қ': 'q', 'ғ': 'g' + OKINA, 'ҳ': 'h'
  };
  var CYR_VOWELS = 'аеёиоуэюяўы';

  function cyrToLat(text) {
    var out = '';
    for (var i = 0; i < text.length; i++) {
      var ch = text[i], lo = ch.toLowerCase(), prev = text[i - 1] || '', next = text[i + 1] || '';
      var plo = prev.toLowerCase(), r;
      if (lo === 'е') {
        // "ye" at the start of a word and after a vowel or ъ/ь, else "e"
        r = (!isLetter(prev) || CYR_VOWELS.indexOf(plo) >= 0 || plo === 'ъ' || plo === 'ь') ? 'ye' : 'e';
      } else if (lo === 'ц') {
        // "ts" between vowels, "s" elsewhere
        r = (CYR_VOWELS.indexOf(plo) >= 0 && isLetter(prev)) ? 'ts' : 's';
      } else if (lo === 'с' && next.toLowerCase() === 'ҳ') {
        r = 's' + TUTUQ; // сҳ = sʼh, so it is not read as sh
      } else if (CYR.hasOwnProperty(lo)) {
        r = CYR[lo];
      } else { out += ch; continue; }
      out += applyCase(r, ch, prev, next);
    }
    return out;
  }

  // ---------- Lotin -> Kirill ----------
  var LAT = {
    'a': 'а', 'b': 'б', 'd': 'д', 'e': 'е', 'f': 'ф', 'g': 'г', 'h': 'ҳ', 'i': 'и',
    'j': 'ж', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н', 'o': 'о', 'p': 'п', 'q': 'қ',
    'r': 'р', 's': 'с', 't': 'т', 'u': 'у', 'v': 'в', 'x': 'х', 'y': 'й', 'z': 'з',
    'c': 'с', 'w': 'в'
  };

  function latToCyr(text) {
    var out = '';
    for (var i = 0; i < text.length; i++) {
      var ch = text[i], lo = ch.toLowerCase(), next = text[i + 1] || '', nlo = next.toLowerCase();
      var prev = text[i - 1] || '';
      var after = text[i + 2] || '';
      var r = null, skip = 0;
      if ((lo === 'o' || lo === 'g') && isQuote(next)) {
        r = lo === 'o' ? 'ў' : 'ғ'; skip = 1;
      } else if (lo === 's' && nlo === 'h') { r = 'ш'; skip = 1; }
      else if (lo === 'c' && nlo === 'h') { r = 'ч'; skip = 1; }
      else if (lo === 's' && isQuote(next) && after.toLowerCase() === 'h') {
        r = 'сҳ'; skip = 2; // sʼh = с + ҳ, not ш
      } else if (lo === 'y' && 'aoue'.indexOf(nlo) >= 0 && nlo && !(nlo === 'o' && isQuote(after))) {
        r = { a: 'я', o: 'ё', u: 'ю', e: 'е' }[nlo]; skip = 1;
      } else if (lo === 'e') {
        r = isLetter(prev) ? 'е' : 'э';
      } else if (isQuote(ch) && isLetter(prev) && isLetter(next)) {
        r = 'ъ';
      } else if (LAT.hasOwnProperty(lo)) {
        r = LAT[lo];
      }
      if (r === null) { out += ch; continue; }
      out += applyCase(r, ch, prev, text[i + 1 + skip] || '');
      i += skip;
    }
    return out;
  }

  // ---------- Lotin <-> Yangi lotin ----------
  function latToNew(text) {
    var out = '';
    for (var i = 0; i < text.length; i++) {
      var ch = text[i], lo = ch.toLowerCase(), next = text[i + 1] || '', nlo = next.toLowerCase();
      var up = isUpper(ch);
      if ((lo === 'o' || lo === 'g') && isQuote(next)) {
        var r = lo === 'o' ? 'ö' : 'ğ'; out += up ? r.toUpperCase() : r; i++;
      } else if ((lo === 's' || lo === 'c') && nlo === 'h') {
        var r2 = lo === 's' ? 'ş' : 'ç'; out += up ? r2.toUpperCase() : r2; i++;
      } else if (lo === 's' && isQuote(next) && (text[i + 2] || '').toLowerCase() === 'h') {
        out += ch; i++; // sʼh -> sh: the separator is not needed in the new alphabet
      } else if (isQuote(ch) && isLetter(text[i - 1]) && isLetter(next)) {
        out += TUTUQ;
      } else {
        out += ch;
      }
    }
    return out;
  }

  var NEW = { 'ö': 'o' + OKINA, 'ğ': 'g' + OKINA, 'ş': 'sh', 'ç': 'ch' };

  function newToLat(text) {
    var out = '';
    for (var i = 0; i < text.length; i++) {
      var ch = text[i], lo = ch.toLowerCase(), prev = text[i - 1] || '', next = text[i + 1] || '';
      if (NEW.hasOwnProperty(lo)) {
        out += applyCase(NEW[lo], ch, prev, next);
      } else if (lo === 's' && next.toLowerCase() === 'h') {
        out += ch + TUTUQ; // s + h stays two letters: sʼh
      } else if (isQuote(ch) && isLetter(prev) && isLetter(next)) {
        out += TUTUQ;
      } else {
        out += ch;
      }
    }
    return out;
  }

  // ---------- public ----------
  var toLat = { cyr: cyrToLat, new: newToLat };
  var fromLat = { cyr: latToCyr, lat: function (t) { return t; }, new: latToNew };

  function convert(text, from, to) {
    if (from === to) return text;
    var lat = from === 'lat' ? text : toLat[from](text);
    return fromLat[to](lat);
  }

  var api = { convert: convert };
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  else root.UzConvert = api;
})(this);
