function message2send=createFileforTransmit(header, footer, message, imagmessage)

%tx_samples_from_file ??freq 2478e6 ??rate 2e6 ??type float ??ant “TX/RX” ??subdev ”A:A” ??gain 40 ??file
%tx.dat

%C:\Program Files\UHD\lib\uhd\examples

%initializing message2send for speed
    message2send=zeros(length(header)+length(message)*1000+length(footer),1);
    
    %adding header to beginning
    for i=1:length(header)
       message2send(i)=header(i)+header(i)*j;
    end
    
    %adding message, where every bit is repeated 1000 times
    for i=1:length(message)
        for k=1:1000
            message2send(length(header)+i+k)=message(i) +message(i)*j;
        end
    end
    
    %adding footer to end
    for i=1:length(footer)
       message2send(length(header)+length(message)*1000+i)=footer(i) + footer(i)*j;
    end
    
    write_usrp_data_file(message2send);
end