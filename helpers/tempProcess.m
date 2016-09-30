
%  Example status bar!
      m = 500;
      progressbar('Processing .delim files') % Init single bar
      for i = 1:m
        pause(0.01) % Do something important
        progressbar(i/m) % Update progress bar
      end