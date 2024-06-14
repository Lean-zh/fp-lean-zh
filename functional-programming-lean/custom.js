const newline = /(?<=[，。、：」）])\n(?!\n)/g;
const space = /\s+(<.+?>\p{Script=Han}.+?<\/.+?>)\s+/g
const paras = document.querySelectorAll("#content > main > p");
for (const p of paras) {
  p.innerHTML = p.innerHTML.replace(newline, "");
  p.innerHTML = p.innerHTML.replace(space, "$1");
}
