function outsize = fsize_latex2nr(inpsize)

switch inpsize
    case 'tiny'
        outsize = 5;
    case 'scriptsize'
        outsize = 7;
    case 'footnotesize'
        outsize = 8;
    case 'small'
        outsize = 9;
    case 'normalsize'
        outsize = 10;
    case 'large'
        outsize = 12;
    case 'Large'
        outsize = 14;
    case 'LARGE'
        outsize = 18;
    case 'huge'
        outsize = 20;
    case 'Huge'
        outsize = 24;
end