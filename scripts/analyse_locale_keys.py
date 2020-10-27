import json
import os


def _get_level_keys(value, level):
    keys = []
    level = level + "." if level != "" else level
    for (k, v) in value.items():
        keys.append(level + k)
        if type(v) is dict:
            keys.extend(_get_level_keys(v, level + k))
    return dict((k, 1) for k in keys)


def get_keys(file):
    keys = {}
    with open(file, 'r') as f:
        content = f.read()
        data = json.loads(content)
        keys = _get_level_keys(data, "")
    return keys


def main(langs, default):
    default_keys = get_keys(os.path.join(langs, default))

    for file in os.listdir(langs):
        if not file.endswith(default):
            print("")
            print(
                f"Checking language file '{file}' against default '{default}' language file for consistency."
            )
            keys = get_keys(os.path.join(langs, file))
            for dk in default_keys:
                if not dk in keys:
                    print(
                        f"Found inconsistency: key '{dk}' was not found in default language file."
                    )

if __name__ == "__main__":
    langs = os.path.abspath("../resources/langs/")
    default = "en.json"
    main(langs, default)