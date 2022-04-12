import shutil
import sys
from datetime import datetime

from pathlib import Path

from jinja2 import Template

if __name__ == "__main__":
    for i, v in enumerate(sys.argv):
        print(f"{i} = {v}")
    dist_loc = Path(sys.argv[1])
    instdir = Path("$INSTDIR")
    dist_paths = [p.relative_to(dist_loc) for p in sorted(dist_loc.rglob("*")) if p.is_file()]
    mapped_out_paths = {}
    for dist_path in dist_paths:
        if "__pycache__" not in dist_path.parts:
            out_path = instdir.joinpath(dist_path.parent)
            if out_path not in mapped_out_paths:
                mapped_out_paths[out_path] = [dist_loc.joinpath(dist_path)]
            else:
                mapped_out_paths[out_path].append(dist_loc.joinpath(dist_path))

    jinja_template_path = Path(sys.argv[2])
    with open(jinja_template_path, "r") as f:
        template = Template(f.read())

    nsis_content = template.render(
        app_name = sys.argv[3],
        main_app = sys.argv[4],
        version_major = sys.argv[5],
        version_minor = sys.argv[6],
        version_patch = sys.argv[7],
        version_build = sys.argv[8],
        company = sys.argv[9],
        web_site = sys.argv[10],
        year = datetime.now().year,
        cura_license_file = Path(sys.argv[11]),
        compression_method = sys.argv[12],  # ZLIB, BZIP2 or LZMA
        cura_banner_img = Path(sys.argv[13]),
        mapped_out_paths = mapped_out_paths,
        destination = Path(sys.argv[15])
    )

    with open(dist_loc.parent.joinpath(jinja_template_path.stem), "w") as f:
        f.write(nsis_content)

    shutil.copy(Path(__file__).absolute().parent.joinpath("fileassoc.nsh"), dist_loc.parent.joinpath("fileassoc.nsh"))
    icon_path = Path(sys.argv[14])
    shutil.copy(icon_path, dist_loc.joinpath(icon_path.name))
