module data_repeatrate
function Onetree(df,x1,x2,y1,y2)
    dfm=df[(df.X.>=x1).&(df.X.<=x2).&(df.Y.>=y1).&(df.Y.<=y2).&(df.Close.>0), :]
    return dfm, dfm.Close
end
function Areafruit(df_onetree)
    avgx=sum(df_onetree.X.*df_onetree.Close)/size(df_onetree)[1];
    avgy=sum(df_onetree.Y.*df_onetree.Close)/size(df_onetree)[1];
    index=findmax(df_onetree.Close)[2];
    modex=df_onetree.X[index];#近似的树的中心
    modey=df_onetree.Y[index];
    #xmax=findmax(df.X)[1];
    #ymax=findmax(df.Y)[1];
    distance_x=df_onetree.X.-modex;
    distance_y=df_onetree.Y.-modey;
    R=(distance_x.^2+distance_y.^2).^0.5;
    df_onetree.distance = R;
    c1=df_onetree[df_onetree.distance.<=1,:];
    c11=findmax(c1.Close)[1];
    c2=df_onetree[(df_onetree.distance.<=3).&(df_onetree.distance.>1),:];
    c22=sum(c2.Close)/size(c2)[1]*8;
    c3=df_onetree[(df_onetree.distance.<=5).&(df_onetree.distance.>3),:];
    c33=sum(c3.Close)/size(c3)[1]*16;

    d=sum((df_onetree.X.-avgx).^2+(df_onetree.Y.-avgy).^2)/size(df_onetree)[1];
    #repeatratio=(acos(d/2)/pi-(d*sqrt(1-d^2/4))/2)/pi
    r=sqrt(findmax((df_onetree.X.-avgx).^2+(df_onetree.Y.-avgy).^2)[1]);
    number_fruit=c11+c22+c33;
    #return modex,modey,number_fruit
    return number_fruit
end
end
