# Force XeLaTeX for this thesis template (pdflatex is not supported)
$pdf_mode = 5;
$xelatex = 'xelatex -shell-escape %O %S';

# pdfx regenerates creationdate.timestamp on each pass; ignoring its content
# prevents latexmk from rerunning until the maximum-pass limit is reached.
$hash_calc_ignore_pattern{'timestamp'} = '^.*$';
