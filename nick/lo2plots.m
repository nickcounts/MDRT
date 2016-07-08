colors = { [0 0 1], [0 .5 0], [.75 0 .75],...
[0 .75 .75], [.68 .46 0]};
lineStyle = {'-','--',':'};

i = 1; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 2; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 3; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 4; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 5; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i}, 'displayname', [fd.Type '-' fd.ID])
i = 6; load(fullfile(path, [filenames{i} '.mat'])); plot(fd.ts.Time + offset, fd.ts.Data, 'color', colors{i-5}, 'displayname', [fd.Type '-' fd.ID])