const newline = /(?<=[，。、：）\)])\n(?!\n)/g;
const space = /\s+(<strong>.*?<\/strong>)\s+/g
const paras = document.querySelectorAll("#content > main > p");
for (const p of paras) {
  p.innerHTML = p.innerHTML.replace(newline, "");
  p.innerHTML = p.innerHTML.replace(space, "$1");
}
