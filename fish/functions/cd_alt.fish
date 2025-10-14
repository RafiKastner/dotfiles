function cd_alt --wraps=z --description 'alias cd=z'
  if test (count $argv) -ne 0;
    builtin cd "$argv"
    return
  end 
  while true;
    
  end
end
