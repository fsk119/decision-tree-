function tree=train(X,y,attribute,impurity,random)
tree=struct('leaf',false,'condition','null','left','null','right','null','value','null','proLeft',0,'proRight',0,'attribute',0);
%child may be add tbl to prune
tbl=tabulate(y);value=tbl(:,1);count=tbl(:,2);
[M,I]=max(count);
if(size(value,1)==1||M>impurity*sum(count))
    tree.leaf=true;
    tree.value=value(I);
    return 
end
minEntropy=inf;
%non random else choose some attribute to test
for i=1:length(attribute)
    [entropy,value]=information(X(:,i),y,attribute(i));
    if(entropy<minEntropy)
        condition=i;
        minEntropy=entropy;
        minValue=value;
    end
end
tree.condition=condition;tree.attribute=attribute(condition);
if(attribute(condition)==0)%nominant
    left=find(X(:,condition)==minValue);
    right=find(X(:,condition)~=minValue);
else%numeric
    left=find(X(:,condition)<minValue);
    right=find(X(:,condition)>minValue);
end
tree.left=train(X(left,:),y(left),attribute,impurity,random);tree.proLeft=(size(left,1))/(size(left,1)+size(right,1));
tree.right=train(X(right,:),y(right),attribute,impurity,random);tree.proRight=1-tree.proLeft;
tree.value=minValue;