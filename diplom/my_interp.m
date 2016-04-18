function result = my_interp(f,x1,x2,y1,y2,x,y)
    dif = (x2-x1)/(y2-y1);
    coef1 = f(x1,y1)/dif;
    coef2 = f(x2,y1)/dif;
    coef3 = f(x1,y2)/dif;
    coef4 = f(x2,y2)/dif;
    result = coef1*(x2-x)*(y2-y)+coef2*(x-x1)*(y2-y)+...
             coef3*(x2-x)*(y-y1)+coef4*(x-x1)*(y-y1);
end