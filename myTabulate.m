function tbl=myTabulate(fhx)
fhx2 = tabulate(num2str(fhx(:))) ;
           % ���� tabulate �ܽyӋ�ַ������� �Ȍ������D�Q���ַ� ���M�нyӋ
           % ��� �@�� tabulate ֻ���yӋ�г��F���ַ� ���� 10 �Ͳ����yӋ����

fhx2(:,1) = cellfun(@str2num, fhx2(:,1), 'UniformOutput', false);
           % �� �yӋ��ɵ��Y���D�Qһ���� ����ַ��yӋ�ľ��� ��һ�Е�׃�� �ַ�
           % �����Ҍ���һ�����D�Q������

tbl = cell2mat(fhx2);