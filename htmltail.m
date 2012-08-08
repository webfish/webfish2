function tail = htmltail(addline)


tail = {'   <div class="post">', '    <div id="nav"><img height="11" src="../footnote.png"></div>', '   </div>', '  </div>', ' </body>', '</html>'};

if nargin == 1
    tail = horzcat(addline, tail);
end
    
