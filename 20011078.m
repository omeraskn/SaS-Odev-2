clc; 
clear;
clear all;

 telnum = 5511515552; % Telefon numaram :)

dtmfrekans = [697,770,852,941,1209,1336,1477];
duration = 0.35; % Tuşlar arası süre
Fs = 8000; % Örnekleme frekansı
A = 0.1;
numara = [];
t = 0:1/Fs:duration;
telnum2Str = num2str(telnum);

for i = 1 : length(telnum2Str)

    digit = telnum2Str(i);
    
    switch digit    % Her bir numaraya göre frekansları atama
        case '1'
            f = dtmfrekans(1); s = dtmfrekans(5);
        case '2'
            f = dtmfrekans(1); s = dtmfrekans(6);
        case '3'
            f = dtmfrekans(1); s = dtmfrekans(7);
        case '4'
            f = dtmfrekans(2); s = dtmfrekans(5);
        case '5'
            f = dtmfrekans(2); s = dtmfrekans(6);
        case '6'
            f = dtmfrekans(2); s = dtmfrekans(7);
        case '7'
            f = dtmfrekans(3); s = dtmfrekans(5);
        case '8'
            f = dtmfrekans(3); s = dtmfrekans(6);
        case '9'
            f = dtmfrekans(3); s = dtmfrekans(7);
        case '0'
            f = dtmfrekans(4); s = dtmfrekans(6);
        otherwise
            error('Invalid input');
    end

    tone = A*sin(2*pi*f*t) + A*sin(2*pi*s*t);
    tonezero = sin(0*t);
    % Fourier serileri o seriyi oluşturan frekanslardaki sinüslerin toplamıdır.
   
    numara = [numara, tone];
    numara = [numara, tonezero]; % Ses dosyası eğer araya boşluk eklenmezse sürekli bir sinyal üretiyor
end

audiowrite('numara.wav', numara, Fs);
% Sesi dosyaya yazdırma


files(1) = "numara.wav";
files(2) = "ornek.wav";
names = {'Kendi' , 'Ornek'};

for k = 1 : 2

    [tel,fs] = audioread(files(k));
    n = 11; % Digit sayısı
    d = floor(length(tel)/n); 
    %sound(tel);
    tel1 = tel(1:d);    % Bu işlemi her bir tuş için n kez tekrarlayınız.

    T = 100000/fs;
    x = (1:T:100000*(length(tel) / fs)) / 100000;

    subplot(2,2,0+k);
    plot(x , tel);
    title(names(k)+" numaranın plot grafigi");
    xlabel('Süre');
    ylabel('Şiddet');
    hold on
    
    subplot(2,2,2+k);
    stem(x , tel);
    title(names(k)+" numaranın stem grafigi");
    xlabel('Süre');
    ylabel('Şiddet');
    hold on

end
figure
for k = 1 : 2

    [tel,fs] = audioread(files(k));
    n = 10; % Digit sayısı
    d = floor(length(tel)/n); 
    %sound(tel);
    tel1 = tel(1:d);    % Bu işlemi her bir tuş için n kez tekrarlayınız.

    T = 100000/fs;
    x = (1:T:100000*(length(tel) / fs)) / 100000;
    if(k == 2)
        fprintf("\n")
    end
    for i = 1 : n
            partel = abs(fft(tel(1+((i-1)*d):i*d),fs));
            tus=(partel(1:floor(length(partel)/2)+1));
            
        [vals, dtmfx] = maxk(tus, 3);
    if(abs(dtmfx(1) - dtmfx(2))<=5)
       dtmfy(1) = dtmfx(1);
       dtmfy(2) = dtmfx(3);            
         if(dtmfx(3)>dtmfx(1))
             dtmfy(1) = dtmfx(3);
             dtmfy(2) = dtmfx(1);
         end
            
         else
             dtmfy(1) = dtmfx(1);
             dtmfy(2) = dtmfx(2);
                
         if(dtmfx(2)>dtmfx(1))
             dtmfy(1) = dtmfx(2);
             dtmfy(2) = dtmfx(1);
         end
     end
        
            if(abs(dtmfx(2) - dtmfx(1))<=5) 
                if(dtmfx(3)>dtmfx(1))
                    dtmfy(1) = dtmfx(3);
                    dtmfy(2) = dtmfx(1);
                end
            else
                if(dtmfx(2)>dtmfx(1))
                    dtmfy(1) = dtmfx(2);
                    dtmfy(2) = dtmfx(1);
                end
            end
            if(abs(dtmfy(1)-1209)<=5)
                if(abs(dtmfy(2)-697)<=5)
                    tussay = "1";
                elseif(abs(dtmfy(2)-770)<=5)
                    tussay = "4";
                elseif(abs(dtmfy(2)-852)<=5)
                    tussay = "7";
                end
            
            elseif(abs(dtmfy(1)-1336)<=5)
                if(abs(dtmfy(2)-697)<=5)
                    tussay = "2";
                elseif(abs(dtmfy(2)-770)<=5)
                    tussay = "5";
                elseif(abs(dtmfy(2)-852)<=5)
                    tussay = "8";
                elseif(abs(dtmfy(2)-941)<=5)
                    tussay = "0";
                end
                 
            elseif(abs(dtmfy(1)-1477)<=5)
                if(abs(dtmfy(2)-697)<=5)
                    tussay = "3";
                elseif(abs(dtmfy(2)-770)<=5)
                    tussay = "6";
                elseif(abs(dtmfy(2)-852)<=7)
                    tussay = "9";
                end
            end
            if(str2num(tussay)>11 && str2num(tussay)<-1)
            else
                figure
                fprintf("%s",tussay);           
                nexttile
                %subplot(4,3,i)  % tek bir numaradaki tüm sayıları tek figure üzerine yazdırmaya çalıştım
                plot(tus);
                title(tussay+" Tuşunun Grafiği");
                xlabel("Frekans");
                ylabel("Büyüklük");
                hold on
            end
    end

end
