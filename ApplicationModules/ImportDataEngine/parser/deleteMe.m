for i = 1:8; customFDnames{28+i,3}=sprintf('%04i',i+2); end
for i = 1:4; customFDnames{36+i,3}=sprintf('%04i',i+0); end
for i = 1:2; customFDnames{40+i,3}=sprintf('%04i',i+0); end
for i = 1:2; customFDnames{42+i,3}=sprintf('%04i',i+0); end
for i = 1:3; customFDnames{45+i,3}=sprintf('%04i',i+2000); end
for i = 1:5; customFDnames{49+i,3}=sprintf('%04i',i+0); end

customFDnames{45,3} = '1001';
customFDnames{49,3} = '3001';
for i = 1:2; customFDnames{54+i,3}=sprintf('%04i',i+1000); end
for i = 1:2; customFDnames{57+i,3}=sprintf('%04i',i+1000); end
customFDnames{57,3} = '0001';
for i = 1:2; customFDnames{59+i,3}=sprintf('%04i',i+3000); end

customFDnames{2,3} = '0001';
customFDnames{3,3} = '0002';
customFDnames{4,3} = '0003';