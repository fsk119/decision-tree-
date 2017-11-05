function y=prediction(X,tree)
    N=size(X,1);y=zeros(N,1);
    for i=1:N
        [ytmp,protmp]=pred(X(i,:),tree);
        [~,I]=max(protmp);
        y(i)=ytmp(I(1));
    end
end

function [y,pro]=pred(X,tree)
    if(tree.leaf)
        pro=1;
        y=tree.value;
        return ;
    end
    if isnan(X(tree.condition))
        [yleft,proleft]=pred(X,tree.left);
        [yright,proright]=pred(X,tree.right);
        [y,pro]=combine(yleft,proleft*tree.proLeft,yright,proright*tree.proRight);
    else
        if(tree.attribute==0)
            if X(tree.condition)==tree.value
                [y,pro]=pred(X,tree.left);
            else
                [y,pro]=pred(X,tree.right);
            end
        else
            if X(tree.condition)<=tree.value
                [y,pro]=pred(X,tree.left);
            else
                [y,pro]=pred(X,tree.right);
            end
        end
    end
end
function [y,pro]=combine(yleft,proleft,yright,proright)
    [Bleft,Ileft]=sort(yleft);
    [Bright,Iright]=sort(yright);
    i=1;j=1;
    y=[];pro=[];
    while i<=length(yleft)&&j<=length(yright)
        if(Bleft(i)==Bright(j))
            y=[y Bleft(i)];
            pro=[pro proleft(Ileft(i))+proright(Iright(j))];
            i=i+1;j=j+1;
        else if(Bleft(i)<Bright(j))
                y=[y Bleft(i)];pro=[pro proleft(Ileft(i))];
                i=i+1;
            else
                y=[y Bright(j)];pro=[pro proright(Iright(j))];
                j=j+1;
            end
        end
    end
    if i<=length(yleft)
        y=[y Bleft(i:end)];
        pro=[pro proleft(Ileft(i:end))];
    end
    if j<=length(yright)
        y=[y Bright(j:end)];
        pro=[pro proright(Iright(j:end))];
    end
end