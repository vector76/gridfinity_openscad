@set OPENSCAD="C:\Program Files\OpenSCAD\openscad.exe"
@set PYTHON="C:\Users\Vector\Anaconda3\python.exe"

%OPENSCAD% gridfinity_basic_cup.scad -D part=1 -o basic_cup_2x1x2.stl --export-format binstl
%PYTHON% canonicalize.py basic_cup_2x1x2.stl

%OPENSCAD% gridfinity_basic_cup.scad -D part=2 -o divided_cup_2x1x2x5.stl --export-format binstl
%PYTHON% canonicalize.py divided_cup_2x1x2x5.stl

%OPENSCAD% gridfinity_basic_cup.scad -D part=3 -o divided_cup_2x1x3x5.stl --export-format binstl
%PYTHON% canonicalize.py divided_cup_2x1x3x5.stl

%OPENSCAD% gridfinity_baseplate.scad -D part=1 -o frame_plain.stl --export-format binstl
%PYTHON% canonicalize.py frame_plain.stl

%OPENSCAD% gridfinity_baseplate.scad -D part=2 -o weighted_baseplate.stl --export-format binstl
%PYTHON% canonicalize.py weighted_baseplate.stl

%OPENSCAD% gridfinity_glue_stick.scad -o glue_stick_cup.stl --export-format binstl
%PYTHON% canonicalize.py glue_stick_cup.stl

%OPENSCAD% gridfinity_flsun_q5.scad -o flsun_q5.stl --export-format binstl
%PYTHON% canonicalize.py flsun_q5.stl

%OPENSCAD% gridfinity_socket_holder.scad -D part=1 -o socket_holder_metric.stl --export-format binstl
%PYTHON% canonicalize.py metric.stl

%OPENSCAD% gridfinity_socket_holder.scad -D part=2 -o socket_holder_imperial.stl --export-format binstl
%PYTHON% canonicalize.py socket_holder_imperial.stl

%OPENSCAD% gridfinity_socket_holder.scad -D part=3 -o socket_holder_imperial_small.stl --export-format binstl
%PYTHON% canonicalize.py socket_holder_imperial_small.stl

%OPENSCAD% gridfinity_socket_holder.scad -D part=4 -o socket_holder_imperial_big.stl --export-format binstl
%PYTHON% canonicalize.py socket_holder_imperial_big.stl

%OPENSCAD% gridfinity_socket_holder.scad -D part=5 -o socket_holder_metric_stacking.stl --export-format binstl
%PYTHON% canonicalize.py socket_holder_metric_stacking.stl

%OPENSCAD% gridfinity_socket_holder.scad -D part=6 -o socket_holder_metric_small.stl --export-format binstl
%PYTHON% canonicalize.py socket_holder_metric_small.stl

pause