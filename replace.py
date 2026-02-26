import os
import re

def replace_match(match, new_word):
    orig = match.group(0)
    if orig.isupper():
        return new_word.upper()
    elif orig.istitle():
        return new_word.capitalize()
    elif orig.islower():
        return new_word.lower()
    else:
        return new_word.lower()

def replace_text(content):
    # Mumbai -> Pune
    content = re.sub(re.escape('mumbai'), lambda m: replace_match(m, 'pune'), content, flags=re.IGNORECASE)
    # Andheri -> Kondhwa
    content = re.sub(re.escape('andheri'), lambda m: replace_match(m, 'kondhwa'), content, flags=re.IGNORECASE)
    return content

def is_text_file(filepath):
    text_exts = {'.txt', '.html', '.htm', '.css', '.js', '.json', '.php', '.xml', '.svg', '.md', '.csv'}
    bin_exts = {'.png', '.jpg', '.jpeg', '.gif', '.ico', '.pdf', '.zip', '.woff', '.woff2', '.ttf', '.eot', '.mp4', '.webm', '.webp'}
    ext = os.path.splitext(filepath)[1].lower()
    
    if ext in text_exts:
        return True
    if ext in bin_exts:
        return False

    try:
        with open(filepath, 'tr', encoding='utf-8') as check_file:
            check_file.read(1024)
            return True
    except UnicodeDecodeError:
        return False
    except Exception:
        return False

def process_file(filepath):
    if not is_text_file(filepath):
        return

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        try:
            with open(filepath, 'r', encoding='latin-1') as f:
                content = f.read()
        except Exception:
            return
    except Exception:
        return

    new_content = replace_text(content)

    if new_content != content:
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
        except Exception as e:
            print(f"Failed to write {filepath}: {e}")

def main():
    root_dir = r"E:\New folder (3)"
    
    # Process contents first
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename == "replace.py":
                continue
            filepath = os.path.join(dirpath, filename)
            process_file(filepath)
            
    # Then rename files and directories bottom-up
    for dirpath, dirnames, filenames in os.walk(root_dir, topdown=False):
        for filename in filenames:
            if filename == "replace.py":
                continue
            new_filename = replace_text(filename)
            if new_filename != filename:
                old_path = os.path.join(dirpath, filename)
                new_path = os.path.join(dirpath, new_filename)
                os.rename(old_path, new_path)
                print(f"Renamed file: {old_path} -> {new_path}")
                
        for dirname in dirnames:
            new_dirname = replace_text(dirname)
            if new_dirname != dirname:
                old_path = os.path.join(dirpath, dirname)
                new_path = os.path.join(dirpath, new_dirname)
                try:
                    os.rename(old_path, new_path)
                    print(f"Renamed dir: {old_path} -> {new_path}")
                except Exception as e:
                    print(f"Failed to rename {old_path}: {e}")

if __name__ == "__main__":
    main()
