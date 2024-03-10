function Draw_radar(DAT,lim,labels,color)%雷达图的轴数是由数据DAT的个数来确定的
    n=length(DAT);
    %数据维度
    adj_DAT=zeros(n,1);
    point=zeros(n,2);
    axis off
    hold on
    theta_last=pi/2;
    for i=1:n
        theta=2*pi/n*i+pi/2;
        plot([0,500*cos(theta)],[0,500*sin(theta)],'o','linewidth',2);
        for j=1:5
           plot([j*100*cos(theta_last),j*100*cos(theta)],[j*100*sin(theta_last),j*100*sin(theta)],'b--o','linewidth',0.75,'color',[0.5,0.5,0.5]);
        end
        
        theta_last=theta;
        if DAT(i)<lim(i,1)
            adj_DAT(i)=0;
        elseif DAT(i)>lim(i,2)
            adj_DAT(i)=500;
        else
            adj_DAT(i)=(DAT(i)-lim(i,1))/(lim(i,2)-lim(i,1))*500;
        end
        point(i,1:2)=[adj_DAT(i)*cos(theta);adj_DAT(i)*sin(theta)];
        text_around(510*cos(theta),510*sin(theta),labels{i},theta);
    end
    
    for i=1:n
        theta=2*pi/n*i+pi/2;
        for j=1:5
            text_around(j*100*cos(theta),j*100*sin(theta),num2str(lim(i,1)+(lim(i,2)-lim(i,1))/5*j),theta+pi/2,5);
        end
    end
    plot([point(:,1);point(1,1)],[point(:,2);point(1,2)],'k-','linewidth',0.8);
    fill(point(:,1),point(:,2),color)
    alpha(0.5);
    texts=findobj(gca,'Type','Text');
    minx=-300;
    maxx=300;
    miny=-300;
    maxy=300;
    for i=1:length(texts)
        rect=get(texts(i),'Extent');
        x=rect(1);
        y=rect(2);
        dx=rect(3);
        dy=rect(4);
        if x<minx
            minx=x;
        elseif x+dx>maxx
            maxx=x+dx;
        end
        if y<miny
            miny=y;
        elseif y+dy>maxy
            maxy=y+dy;
        end
    end
    axis([minx-50,maxx+50,miny-20,maxy+20]);
end
 
function text_around(x,y,txt,theta,fontsize)
    if nargin==4
        fontsize=10;
    end
    section=mod(theta+pi/12,2*pi);
    if section>pi+pi/6
        if section>1.5*pi+pi/6
            text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','left','Fontsize',fontsize);
        elseif section>1.5*pi
            text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','center','Fontsize',fontsize);
        else
            text(x,y,txt,'VerticalAlignment','cap','HorizontalAlignment','right','Fontsize',fontsize);
        end
    elseif section>pi
        text(x,y,txt,'VerticalAlignment','middle','HorizontalAlignment','right','Fontsize',fontsize);
    elseif section>pi/6
        if section>0.5*pi+pi/6
            text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','right','Fontsize',fontsize);
        elseif section>0.5*pi
            text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','center','Fontsize',fontsize);
        else
            text(x,y,txt,'VerticalAlignment','bottom','HorizontalAlignment','left','Fontsize',fontsize);
        end
    else
        text(x,y,txt,'VerticalAlignment','middle','HorizontalAlignment','left','Fontsize',fontsize);
    end
end