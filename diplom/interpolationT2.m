function [result] = interpolationT2(row,F,r,h_r,arg,N_phi)
     result = zeros(N_phi,1,'double');
     for k = 1:length(row)
         if (row(k) == -1) 
             continue;
         end
         result(k,1) = F(k,row(k))+(arg(k)-r(row(k)))*(F(k,row(k))-F(k,row(k)+1))/h_r;
     end
    %result = transpose(sum(F(:,row),2))+(arg-r).*transpose(sum((F(:,row+1)-F(:,row)),2))./h_r;
end