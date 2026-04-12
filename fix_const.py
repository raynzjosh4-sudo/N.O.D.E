import os
import re

lib_dir = r"c:\Users\user\Desktop\dev\node_app\lib"

modified_files = 0

# Strip 'const' from widgets
for root, _, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()

            original_content = content
            
            # Since dart formatting usually does "const Widget(" or "const [", 
            # we'll just aggressively remove 'const ' from anything that might wrap a responsive extension.
            # A more robust fix: iterate lines, if a line has .r, .w, .h, .sp, remove 'const ' from it and previous few lines.
            
            lines = content.split('\n')
            for i in range(len(lines)):
                if re.search(r'\.[whr](?!w)|(?<=\d)\.sp', lines[i]):
                    # Found responsive extension on this line
                    # Look backwards up to 30 lines for 'const ' and remove it
                    for j in range(i, max(-1, i-30), -1):
                        newLine = re.sub(r'\bconst\s+([A-Z])', r'\1', lines[j])
                        newLine = re.sub(r'const\s+\[', r'[', newLine)
                        newLine = re.sub(r'const\s+\(', r'(', newLine)
                        if newLine != lines[j]:
                            lines[j] = newLine
            
            # Sometimes the responsive extension is multiple lines below the const keyword.
            new_content = '\n'.join(lines)
            
            if new_content != original_content:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                modified_files += 1

print(f"Removed const in {modified_files} files.")
