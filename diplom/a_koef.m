function [result] = a_koef(r, rm)
    result = (r - rm).*my_log(abs(r-rm))+(r+rm).*my_log(abs(r+rm))-2*r;
end