function [entropy,value]=information(X,y,attribute)
lost=isnan(X);%take out the value
lostTbl=myTabulate(y(lost));
lostValue=0;lostCount=0;
if(size(lostTbl,1)~=0)
    lostValue=lostTbl(:,1);lostCount=lostTbl(:,2);
end
entropy=inf;
if attribute==0% nominant value
    v=unique(X(~lost));%possible value
    value=v(1);
    for i=1:length(v)
        left=find(X==v(i)); right=find(X~=v(i));%division
        ratio=length(left)/(length(left)+length(right));
        
        leftTbl=myTabulate(y(left)); rightTbl=myTabulate(y(right));
        if(size(leftTbl,1)==0||size(rightTbl,1)==0)
            continue;
        end
        leftValue=leftTbl(:,1);leftCount=leftTbl(:,2);
        leftEntropy=ratio*calEntropy(leftCount,leftValue,lostCount,lostValue,ratio);
       
        rightValue=rightTbl(:,1);rightCount=rightTbl(:,2);
        rightEntropy=(1-ratio)*calEntropy(rightCount,rightValue,lostCount,lostValue,1-ratio);
        
        tmpEntropy=leftEntropy+rightEntropy;
        if(tmpEntropy<entropy)
            entropy=tmpEntropy;
            value=v(i);
        end
    end
else
    [B,I]=sort(X(~lost));
    v=sort(unique(X(~lost)));
    value=v(1);
    index=1;
    for i=1:length(v)-1
       while(index+1<=length(B)&&B(index+1)==v(i))
           index=index+1;
       end
        ratio=index/length(B);
        leftTbl=myTabulate(y(I(1:index)));
        leftValue=leftTbl(:,1);leftCount=leftTbl(:,2);
        leftEntropy=ratio*calEntropy(leftCount,leftValue,lostCount,lostValue,ratio);
        rightTbl=myTabulate(y(I(index+1:end)));
        rightValue=rightTbl(:,1);rightCount=rightTbl(:,2);
        rightEntropy=(1-ratio)*calEntropy(rightCount,rightValue,lostCount,lostValue,1-ratio);
        
        tmpEntropy=leftEntropy+rightEntropy;
        if(tmpEntropy<entropy)
            entropy=tmpEntropy;
            value=(v(i)+v(i+1))/2;
        end
    end
end
%fprintf('1\n');
end
function entropy=calEntropy(Count,Value,lostCount,lostValue,ratio)
if lostCount==0
    pro=Count/sum(Count);
    entropy=-sum(pro.*log(pro));
    return 
end
[BC,IC]=sort(Count);
[BL,IL]=sort(lostCount);
i=1;j=1;
pro=[];
while i<=length(IC) && j<=length(IL)
    if(BC(i)==BL(j))
        pro=[pro;Count(IC(i))+floor(ratio*lostCount(IL(j))+0.5)];
        i=i+1;j=j+1;
    else if(BC(i)<BL(j))
            pro=[pro;Count(IC(i))];
            i=i+1;
        else 
            pro=[pro;floor(lostCount(IL(j))*ratio+0.5)];
            j=j+1;
        end
    end
end
if i<=length(IC)
   pro=[pro;Count(IC(i:end))] ;
end
if j<=length(IL)
    pro=[pro;lostCount(IL(j:end))];
end
pro=pro/sum(pro);
entropy=-sum(pro.*log(pro));
end

%http://www-scf.usc.edu/~csci567/21-penalty-methods.pdf