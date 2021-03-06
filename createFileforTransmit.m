function message2send=createFileforTransmit(sizeOfBox, header, footer, message, imagmessage)

%tx_samples_from_file ??freq 2478e6 ??rate 2e5 ??type float ??ant �TX/RX� ??subdev �A:A� ??gain 40 ??file
%tx.dat

%C:\Program Files\UHD\lib\uhd\examples


%pad with 1000 zeros


%initializing message2send for speed
    message2send=zeros(2000+sizeOfBox+length(header)*sizeOfBox+length(message)*sizeOfBox+length(footer)*sizeOfBox,1);
   
    for i=1:sizeOfBox
       message2send(1000+i)=0.25+0.25j; 
    end
    
    %adding header to beginning
    for i=1:length(header)
        for k=1:sizeOfBox
            message2send(1000+sizeOfBox+((i-1)*sizeOfBox)+k)= header(i)/4.0;
        end
    end
    
    %adding message, where every bit is repeated 100 times
    for i=1:length(message)
        for k=1:sizeOfBox
            message2send(1000+sizeOfBox+length(header)*sizeOfBox+((i-1)*sizeOfBox)+k)= (message(i)/4.0)+((imagmessage(i)/4.0)*j);
        end
    end
    
    %adding footer to end
    for i=1:length(footer)
        for k=1:sizeOfBox
            message2send(1000+sizeOfBox+length(header)*sizeOfBox+length(message)*sizeOfBox+((i-1)*sizeOfBox)+k)= footer(i)/4.0;
        end
    end
    title('real message')
    plot(real(message2send));
    
    figure;
    title('imaginary message')
    plot(imag(message2send));
    write_usrp_data_file(message2send);
end