// Run: node tests/test_convert.js
const { convert } = require('../site/convert.js');

// [Kirill, Lotin, Yangi lotin]
const cases = [
  ['Ўзбекистон', 'Oʻzbekiston', 'Özbekiston'],
  ['ўзбекча', 'oʻzbekcha', 'özbekça'],
  ['ғалаба', 'gʻalaba', 'ğalaba'],
  ['шаҳар', 'shahar', 'şahar'],
  ['чиройли', 'chiroyli', 'çiroyli'],
  ['Шаҳло', 'Shahlo', 'Şahlo'],
  ['ШАҲАР', 'SHAHAR', 'ŞAHAR'],
  ['ЎЗБЕКИСТОН', 'OʻZBEKISTON', 'ÖZBEKISTON'],
  ['маъно', 'maʼno', 'maʼno'],
  ['мустақил', 'mustaqil', 'mustaqil'],
  ['ёшлар', 'yoshlar', 'yoşlar'],
  ['юлдуз', 'yulduz', 'yulduz'],
  ['яхши', 'yaxshi', 'yaxşi'],
  ['ер', 'yer', 'yer'],
  ['эркин', 'erkin', 'erkin'],
  ['мева', 'meva', 'meva'],
  ['Исҳоқ', 'Isʼhoq', 'Ishoq'],
  ['машҳур', 'mashhur', 'maşhur'],
  ['тонг', 'tong', 'tong'],
  ['Салом, дунё!', 'Salom, dunyo!', 'Salom, dunyo!'],
];

const names = ['cyr', 'lat', 'new'];
let fail = 0;
for (const row of cases) {
  for (let a = 0; a < 3; a++) for (let b = 0; b < 3; b++) {
    if (a === b) continue;
    const got = convert(row[a], names[a], names[b]);
    if (got !== row[b]) { fail++; console.log(`FAIL ${names[a]}→${names[b]}: ${row[a]} → ${got} (want ${row[b]})`); }
  }
}

// Lotin typed with plain apostrophes is understood too
const loose = [["O'zbekiston", 'new', 'Özbekiston'], ["g'alaba", 'cyr', 'ғалаба'], ["ma'no", 'new', 'maʼno'], ["o‘g‘il", 'new', 'öğil']];
for (const [src, to, want] of loose) {
  const got = convert(src, 'lat', to);
  if (got !== want) { fail++; console.log(`FAIL lat→${to}: ${src} → ${got} (want ${want})`); }
}

if (fail) { console.log(`${fail} failed`); process.exit(1); }
console.log('All converter checks passed.');
