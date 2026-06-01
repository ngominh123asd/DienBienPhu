import re

file_path = r'd:\GM48 36.yyp\objects\oCont_Room\Draw_64.gml'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace any ", 0.XX, 0.XX, 0);" with ", 1.0, 1.0, 0);"
content = re.sub(r',\s*(?:0\.\d+|1\.1)\s*,\s*(?:0\.\d+|1\.1)\s*,\s*0\);', ', 1.0, 1.0, 0);', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed Draw_64.gml scales successfully.")
