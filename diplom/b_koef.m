function [result] = b_koef(r, rm)
    result = (r^2-rm^2)*my_log(abs(r^2-rm^2))-r^2;
end