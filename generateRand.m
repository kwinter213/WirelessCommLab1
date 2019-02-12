function message=generateRand(number)
    message=2*rand(number,1);
    
    for i=1:length(message)
       message(i)=message(i)-1;
       if(message(i)<=0)
          message(i)=-1; 
       end
       if(message(i)>0)
          message(i)=1; 
       end
    end
end