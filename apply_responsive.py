import os
import re

lib_dir = r"c:\Users\user\Desktop\dev\node_app\lib"
import_statement = "import 'package:node_app/core/utils/responsive_size.dart';"

# Updated patterns to avoid matching variables or existing .w/.h
patterns = [
    (r'(width:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.w\4'),
    (r'(height:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.h\4'),
    (r'(fontSize:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.sp\4'),
    (r'(size:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.w\4'),
    (r'(EdgeInsets\.all\(\s*)([0-9]+(\.[0-9]+)?)(\s*\))', r'\1\2.w\4'),
    (r'(BorderRadius\.circular\(\s*)([0-9]+(\.[0-9]+)?)(\s*\))', r'\1\2.r\4'),
    (r'(horizontal:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.w\4'),
    (r'(vertical:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.h\4'),
    (r'(top:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.h\4'),
    (r'(bottom:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.h\4'),
    (r'(left:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.w\4'),
    (r'(right:\s*)([0-9]+(\.[0-9]+)?)([,)])', r'\1\2.w\4'),
]

# Specifically exclude matching things that already have .w, .h, .sp, .r or are 0 / 0.0 or double constants
def should_replace(val):
    if val in ['0', '0.0', '1', '1.0', '1.5', '2.0', 'double.infinity']: return False
    return True

modified_files = 0

for root, _, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart') and file != 'responsive_size.dart':
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()

            original_content = content
            
            # Apply regex replacements
            for pattern, repl in patterns:
                # We need to use a function to filter out cases like 0 or 1
                def repl_func(match):
                    full_match = match.group(0)
                    val = match.group(2)
                    # Don't replace if it's already got .w or if it's 0 or double.infinity etc
                    if match.group(4) == '.w' or match.group(4) == '.h' or match.group(4) == '.sp' or match.group(4) == '.r':
                        return full_match
                    if val in ['0', '0.0', 'double.infinity']:
                        return full_match
                    # If the next character is ., it might be a double access like 20.0.w
                    # we should avoid matching 20.0 if it already is followed by .w
                    return re.sub(pattern, repl, full_match)

                content = re.sub(pattern, lambda m: m.group(1) + m.group(2) + repl[-2:] if not m.group(2) in ['0', '0.0'] and not m.group(2).startswith('0.') else m.group(0), content)

            # Manual loop for precise replacement
            import_needed = False
            lines = original_content.split('\n')
            new_lines = []
            
            for line in lines:
                original_line = line
                for pat, rep in patterns:
                    def custom_rep(m):
                        val = m.group(2)
                        # Avoid matching 0, or already suffixed
                        if val in ['0', '0.0']: return m.group(0)
                        # Check lookahead for .w, .h etc
                        next_chars = line[m.end():m.end()+2]
                        if next_chars in ['.w', '.h', '.s', '.r']: return m.group(0)
                        
                        suffix = ''
                        if '.w' in rep: suffix = '.w'
                        elif '.h' in rep: suffix = '.h'
                        elif '.sp' in rep: suffix = '.sp'
                        elif '.r' in rep: suffix = '.r'
                        
                        return m.group(1) + val + suffix + m.group(4)
                        
                    line = re.sub(pat, custom_rep, line)
                
                if line != original_line:
                    import_needed = True
                new_lines.append(line)
            
            if import_needed:
                new_content = '\n'.join(new_lines)
                # insert import after last import
                import_idx = -1
                for i, ln in enumerate(new_lines):
                    if ln.startswith('import '):
                        import_idx = i
                
                if import_idx != -1 and import_statement not in new_content:
                    new_lines.insert(import_idx + 1, import_statement)
                    new_content = '\n'.join(new_lines)
                elif import_statement not in new_content:
                    new_lines.insert(0, import_statement)
                    new_content = '\n'.join(new_lines)
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                modified_files += 1

print(f"Modified {modified_files} files.")
