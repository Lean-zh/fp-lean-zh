import json
import sys
import re

newline_re = re.compile(r'(?<=[，。、：）\)])\n(?=[\u4E00-\u9FFF\w`])')

def trim_space(book):
    sections = book['sections']
    for ch in sections:
        ch["Chapter"]["content"] = newline_re.sub("", ch['Chapter']['content'])
    return book

if __name__ == '__main__':
    if len(sys.argv) > 1:
        if sys.argv[1] == "supports":
            sys.exit(0)

    context, book = json.load(sys.stdin)
    result = json.dumps(trim_space(book))
    print(result)
