
%% Randomize 70/30 Training/Testing Data
clear;
x = .1; 
y = sin(x);
count = 1;
for i = 2:100
    
    x = [x;i/10];
    y = [y;sin(x(i))];
    count = [count; i];
end

% Randomize numbers 1-100
r = datasample(count,100, 'Replace',false);

training_count = sort(r(1:70)); % 70% goes to training
testing_count = sort(r(71:100)); % 30% goes to testing

training = y(training_count); % Assign first 70% to training
testing = y(testing_count); % Assign last 30% to testing

%% Discrete CMAC and train it on a 1-D function

%Program a Discrete CMAC and train it on a 1-D function (ref: Albus1975, Fig. 5)
%Explore effect of overlap area on generalization and time to convergence.
%Use only 35 weights weights for your CMAC, and sample your function at 100
%evenly spaced points.  Use 70 for training and 30 for testing. Report the
%accuracy of your CMAC network using only the 30 test points.
for cells = 1:35 % Cycle through 35 weights
    tic
    output = testing;
    
    for i = 1:(length(output)-cells) % For all inputs
        sum = 0; % Inialize summation of weights x test output
        weight = 0; % Inialize summation of weights
        
        for j = 0:(cells-1) % Averaging # of cells together
            d = (1 - (output(i+j) - y(i))^2)^2;
            sum = sum + d*training(i);
            weight = weight + d;
        end
        
        output(i) = sum/weight; % summation of weights x test output x summation of weights
        errors(i) = 100 * abs ((output(i) - y(i)) / y(i)); %error formula
    end
    
     % Calculate error for each # of cells used
    errors = errors(1:(30-cells));
    error(cells) = mean(errors);
    
    % Plot the output versus the actual output
    figure(1);
    plot(x(1:length(output)),output,'b');
    hold on;
    plot(x(1:length(output)),y(1:length(output)),'r');
    
    % Get performance time
    perf_time(cells) = toc;
    
end

% Print best time and number of cells to use
[min_error, best_cells] = min(error);
min_time = perf_time(best_cells);
fprintf('%f%% Error\n %d Cells\n Time elapsed: %f \n',min_error,best_cells,min_time);


%% Continuous

for cells = 1:35 % Cycle through 35 weights
    tic
    output = testing;
    
    for i = 1:(length(output)-cells) % For all inputs
        sum = 0; % Inialize summation of weights x test output
        weight = 0; % Inialize summation of weights
        
        for j = 0:(cells) % Averaging # of cells together  
            if j==0 
                d = (1 - (output(i+j) - y(i))^2)^2 * .5; % Used for making the system continuous
            elseif j==cells
                d = (1 - (output(i+j) - y(i))^2)^2 * .5; % Used for making the system continuous
            end
            d = (1 - (output(i+j) - y(i))^2)^2; % Normal weight function
            sum = sum + d*training(i); % Summation of numerator
            weight = weight + d; % Summation of denominator
        end
        
        output(i) = sum/weight; % summation of weights x test output x summation of weights
        errors(i) = 100 * abs ((output(i) - y(i)) / y(i)); %error formula
    end
    
    % Calculate error for each # of cells used
    errors = errors(1:(30-cells));
    error(cells) = mean(errors);
    
    % Plot the output versus the actual output
    figure(1);
    plot(x(1:length(output)),output,'b');
    hold on;
    plot(x(1:length(output)),y(1:length(output)),'r');
    
    % Get performance time
    perf_time(cells) = toc;
    
end

% Print best time and number of cells to use
[min_error, best_cells] = min(error);
min_time = perf_time(best_cells);
fprintf('%f%% Error\n %d Cells\n Time elapsed: %f \n',min_error,best_cells,min_time);

