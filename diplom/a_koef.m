function [result] = a_koef(r, rm)
    result = (r-rm).*log(abs(r-rm))+(r+rm).*log(abs(r+rm))-2*r;
end