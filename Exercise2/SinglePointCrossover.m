function [y1, y2] = SinglePointCrossover(x1, x2)

    % Binary Conversion
    [bin1, bin2] = DecToBin([x1, x2]);

    [nSlices, nVar] = size(bin1);
    sliceP = randi([1, nVar-1]); % Slicing point

    % Offspring init
    offS1 = repmat(' ', nSlices, nVar);
    offS2 = repmat(' ', nSlices, nVar);

    for i = 1:nSlices
    offS1(i,:) = [bin1(i, 1:sliceP) bin2(i, sliceP+1: end)];
    offS2(i,:) = [bin2(i, 1:sliceP) bin1(i, sliceP+1: end)];

    end

    signedOffspringDec1 = repmat(nan, nSlices,1);
    signedOffspringDec2 = repmat(nan, nSlices,1);
    
    for i = 1:nSlices 
        signedOffspringDec1(i) = BinToDec(offS1(i,:));
        signedOffspringDec2(i) = BinToDec(offS2(i,:));
    end

    y1 = signedOffspringDec1;
    y2 = signedOffspringDec2;

end