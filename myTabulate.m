function tbl=myTabulate(fhx)
fhx2 = tabulate(num2str(fhx(:))) ;
           % 利用 tabulate 能統計字符的能力 先將數據轉換成字符 在進行統計
           % 因為 這樣 tabulate 只會統計有出現的字符 所以 10 就不會統計到了

fhx2(:,1) = cellfun(@str2num, fhx2(:,1), 'UniformOutput', false);
           % 將 統計完成的資料轉換一下屬性 因為字符統計的緣故 第一行會變成 字符
           % 所以我將第一行在轉換回整數

tbl = cell2mat(fhx2);