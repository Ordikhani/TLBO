format short;


% We have a optimization function:   min y= x1 ^2 - x2^2 +3
% and Problem constraints is:            x1,x2 in [-1,1]
%we solve this problem with TLBO (Theaching Learning Based Optimization
%Algorithm)
%Producter: Fateme Ordikhani  : https://github.com/Ordikhani

clc;
clear;
close all;

%% 
% I defined the function for calculating optimization, 
% There is in  current path  the folder  


%%   Definition public parameters of problem

max_iter=100;     % number of max iteration
N=50;             %poplation size
lb=[-1,-1];      %lower bound variables 
ub=[1,1];         %upper bound variables
D=2;              %number of variables in the problem , for this problem we have x1 ,x2


%% Section of simulation Algorithm TLBO


    
for i=1:N  
   
    %step 1  
  %  use this formulla:  x= lb + rand.*(ub-lb) 
  for j=1:D 
     ge_pop_ran(i,j)=lb(:,j)+rand.*(ub(:,j)-lb(:,j));    % generation  poplation random   
  end
 
end  % end of poplution    
  
for iter=1:max_iter
  for i=1:N  
% comput y_best, y_mean, y_min,  tf : in x_new=min +r*(Max - tf*mean) for TLBO Algorithm

fx=func(ge_pop_ran);  %value poplation pass to function
%tf=round(1+rand);
tf=round(1+rand);
[val,ind]=min(fx);
best=ge_pop_ran(ind,:);  %best value for each parameters in function
Mean=mean(ge_pop_ran);     %comput mean value

%% theacher phase

% comput   x_new=min +r*(Max - tf*mean) in TLBO Algorithm
new=ge_pop_ran(i,:)+rand.*(best -tf.*Mean); %function: costinvGncc.m

% check the bound for teacher  
for h=1:D  %function: 
  if new(h) >ub(h)
      new(h)=ub(h);
  elseif new(h)<lb(h)
      new(h)=lb(h);
  end 
end

%perform selection function value 
fnew=func(new);
if fnew <fx(i,:)
    ge_pop_ran(i,:)=new;
    fx(i,:)=fnew;
end

%% learn phase  (select partner )
  
%y_new = x+r*(x-x_p) if func(ge_pop_ran) < f_p(xp)
%y_new = x-r*(x-x_p) if func(ge_pop_ran) > f_p (xp)


%select partner  investment, 
par=1:N;
par(i)=[];
partner=par(randi(length(par)));

% generation the new soulotion
xp=ge_pop_ran(partner,:);
fp=func(xp);
x=ge_pop_ran(i,:);

if fx(i,:)<fp
  new=x+rand.*(x-xp);
else
  new=x-rand.*(x-xp);
end
  
% check the bound for teacher  
for h=1:D  %function: 
  if new(h) >ub(h)
      new(h)=ub(h);
  elseif new(h)<lb(h)
      new(h)=lb(h);
  end 
end

 %  selection
new_func=func(new);
if new_func <fx(i,:)
    ge_pop_ran(i,:)=new;
    fx(i,:)=new_func;
end

  end  %the end of poplation
  
%%  save the best value 
     
% cost 
[optval,optind]=min(fx);
best_func(iter)=optval;
best_x(iter,:)=ge_pop_ran(optind,:);

%result 
disp([ 'Iteration  =   ' num2str(iter) ' ----->  Best Value  parametrs' num2str(best_x(iter,:)) ' ----->   Best Value function  '  num2str(best_func(iter)) ] );


end %end of iterration
disp( '====================================' );

disp([ ' ----->  Best Value for Variable is :  ' num2str(best_x(iter,:)) ] );
disp([ ' ----->  Best Value function  ' num2str(func(best_x(iter,:))) ] );
% result
figure;
plot(best_func, 'LineWidth',2);
xlabel('iteration');
ylabel('fitness value');
grid on;
