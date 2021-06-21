clc
clear
%%File Input.%%
[FileName,Path] = uigetfile('*.xlsx');
if isequal(FileName,0)
   disp('User selected Cancel');
else 
   disp(['User selected ', fullfile(Path,FileName)]);
   FilePath = strcat(Path,FileName);
   num = xlsread(FilePath,1, 'A1:C11');
end
%%%%%
[m,n] = size(num);
fitting = input('enter 1 for line fitting and 2 for plane fitting:');
if fitting ==1 
  type = input('enter 1 for plonomyal,2 for exponential,3 for power,4 for saturation,and 5 for plalne sinusoidal:');
  if type == 1 %%polonomyal
      degree = input('Which degree of polonomyal?');
      Y = num(:,2);
      X = ones(m,1);
      for j = 2:(degree+1)
        X(:,j) = num(:,1).^j;
      end
      XT = transpose(X);
      XI = inv(XT*X);
      A = XI*XT*Y;
      CY = X*A;
      plot(num(:,1),num(:,2),'*b',num(:,1),CY);
      for j=0:degree
          fprintf(strcat(num2str(A(j+1)),"x^",num2str(j),"+"));
      end    
  elseif type == 2 %% exponential
      Y = log(num(:,2));
      X = ones(m,1);
      X(:,2) = num(:,1);
      XT = transpose(X);
      XI = inv(XT*X);
      A = XI*XT*Y;
      A(1) = exp(A(1));
      x = [num(1,1):0.1:num(m,1)];
      CY = A(1)*exp(A(2)*x(:));
      plot(num(:,1),num(:,2),'*b',x,CY);
      fprintf(strcat(num2str(A(1)),"e^(",num2str(A(2)),"x)"));    
  elseif  type == 3 %power
      Y = log(num(:,2));
      X = ones(m,1);
      X(:,2) = log(num(:,1));
      XT = transpose(X);
      XI = inv(XT*X);
      A = XI*XT*Y;
      A(1) = exp(A(1));
      x = [num(1,1):0.1:num(m,1)];
      CY = A(1)*x.^A(2);
      plot(num(:,1),num(:,2),'*b',x,CY);
      fprintf(strcat(num2str(A(1)),"x^(",num2str(A(2)),")"));
  elseif type == 4
      Y = 1./num(:,2);
      X = ones(m,1);
      X(:,2) = 1./num(:,1);
      XT = transpose(X);
      XI = inv(XT*X);
      A = XI*XT*Y;
      A(1) = 1/A(1);
      A(2) = A(2)*A(1);
      x = [num(1,1):0.1:num(m,1)];
      CY = x*A(1);
      CY = CY./(x+A(2));
      plot(num(:,1),num(:,2),'*b',x,CY);
      fprintf(strcat(num2str(A(1)),"*","x/(",num2str(A(2)),"+x)"));  
  else %sinusoidal.
      Y = num(:,2);
      X = ones(m,1);
      X(:,2) = cos(num(:,1));
      X(:,3) = sin(num(:,1));
      XT = transpose(X);
      XI = inv(XT*X);
      A = XI*XT*Y;
      x = [num(1,1):0.1:num(m,1)];
      CY = A(1) + A(2)*cos(x) + A(3)*sin(x);
      plot(num(:,1),num(:,2),'*b',x,CY);
      fprintf(strcat(num2str(A(1)),"+",num2str(A(2)),"cos(x)","+",num2str(A(3)),"sin(x)"));  
  end    
else
   Y = num(:,2);
   X = ones(m,1);
   X(:,2) = num(:,1);
   X(:,3) = num(:,3);
   XT = transpose(X);
   XI = inv(XT*X);
   A = XI*XT*Y;
   %x = [num(1,1):0.1:num(m,1)];
   %z = [num(1,3):(abs(num(1,3))+abs(num(m,3)+0.5))/length(x):num(m,3)];
   %CY = A(1) + A(2).*x + A(3).*z;
   figure(1)
   plot3(num(:,1),num(:,2),num(:,3),'*b');
   %plot3(x,z,CY)
   syms x y 
   z = A(1)+A(2)*x+A(3)*y;
   figure(2)
   ezmesh(A(1,1)+A(2,1)*x+A(3,1)*y);                
end    