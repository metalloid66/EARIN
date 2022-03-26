function B = BinToDec(A)


% A='10000';
N=length(A);

if(A(1)=='1')

for k=1:N
   
    if(A(k)=='0')
       B(k)='1';
    else
        B(k)='0';
    end
    
end


temp2=0;

Z=num2str(zeros(1,N-1));
Z= Z(find(~isspace(Z)));
Z=strcat(Z,'1');

for i=1:N
  
 C(N-i+2)=temp2&str2num(B(N-i+1))&str2num(Z(N-i+1));
 
 if((temp2&&str2num(B(N-i+1))&&str2num(Z(N-i+1)))==0)
     
     if((temp2==1)||(str2num(Z(N-i+1))==1)||(str2num(B(N-i+1))==1))
    C(N-i+2)=1;
     end
     
    if((temp2==0)&&(str2num(Z(N-i+1))==0)&&(str2num(B(N-i+1))==0))
    C(N-i+2)=0;
    end 
 
     if((temp2&&str2num(B(N-i+1))==1)||(temp2&&str2num(Z(N-i+1))==1)||(str2num(Z(N-i+1))&&str2num(B(N-i+1))==1))
         
     C(N-i+2)=0;
 
     end
 end
 temp2=((temp2&str2num(B(N-i+1)))|(temp2&str2num(Z(N-i+1)))|(str2num(B(N-i+1))&str2num(Z(N-i+1))));
C(1)=temp2;
end


 B=num2str(C);
 B= B(find(~isspace(B)));
 B=B(2:N+1);
 
 B=bin2dec(B);
 if(A(1)=='1')
    B=-B;
 end
else
    B=bin2dec(A);
end

 end
 