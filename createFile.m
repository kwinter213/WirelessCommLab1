function message2send=createFile(header, footer, message)

%initializing message2send for speed
    message2send=zeros(length(header)+length(message)*1000+length(footer));
    
    %adding header to beginning
    for i=1:length(header)
       message2send(i)=header(i); 
    end
    
    %adding message, where every bit is repeated 1000 times
    for i=1:length(message)
        for j=1:1000
            message2send(length(header)+i+j)=message(i);
        end
    end
    
    %adding footer to end
    for i=1:length(footer)
       message2send(length(header)+length(message)*1000+i)=footer(i);
    end
    
    write_usrp_data_file(message2send);
end