% M/M/1/10 simulation. We will find the probabilities of the first states.
% Note: Due to ergodicity, every state has a probability >0.

clc;
clear all;
close all;

rand('seed',1);
counter = 1;
lambdas = [1,5,10];

for i = lambdas
  
  clear to_plot;
  
  arrivals = [0,0,0,0,0,0,0,0,0,0,0];
  total_arrivals = 0; % to measure the total number of arrivals
  current_state = 0;  % holds the current state of the system
  previous_mean_clients = 0; % will help in the convergence test
  index = 0;
  mu = 5;
  threshold = i/(i + mu); % the threshold used to calculate probabilities
  transitions = 0; % holds the transitions of the simulation in transitions steps
  %debug_matrix = [];
  
  while transitions >= 0 %&& transitions < 30
    transitions++; % one more transitions step
    %debug_matrix(debug_i,1) = debug_i;
    %debug_matrix(debug_i,2) = current_state;
    
    if mod(transitions,1000) == 0 % check for convergence every 1000 transitions steps
      index++;
      for j=1:1:length(arrivals)
          P(j) = arrivals(j)/total_arrivals; % calculate the probability of every state in the system
      endfor
      
      mean_clients = 0; % calculate the mean number of clients in the system
      for j=1:1:length(arrivals)
         mean_clients = mean_clients + (j-1).*P(j);
      endfor
      
      to_plot(index) = mean_clients;
          
      if abs(mean_clients - previous_mean_clients) < 0.00001 || transitions > 1000000 % convergence test
        break;
      endif
      
      previous_mean_clients = mean_clients;
    endif
    
    random_number = rand(1); % generate a random number (Uniform distribution)
    
    if current_state == 0 || random_number < threshold % arrival
      total_arrivals++;
      arrivals(current_state + 1)++; % increase the number of arrivals in the current state
      %debug_matrix(transitions,3) = 1;
      %debug_matrix(transitions,4) = arrivals(current_state + 1);
      
      if(current_state != 10)
        current_state++;
      endif
      
    else % departure
      %debug_matrix(transitions,3) = -1;
      %debug_matrix(transitions,4) = arrivals(current_state + 1);
    
      if current_state != 0 % no departure from an empty system
        current_state--;
      endif
    endif
  endwhile

  %printf(sprintf("The debug matrix for tracing the first 30 transitions\n(transition number, current state, next transition\nequal to arrival (1) or departure (-1) and total number\nof arrivals on current state) for Lambda = %d is:\n", i));
  %disp(debug_matrix);
  
  printf(sprintf("The Blocking Probability is equal to: %d\n", P(length(arrivals))));

  figure(counter++);
  bar(0:1:(length(arrivals)-1),P,0.5);
  grid on;
  title(sprintf("Probabilities for Lambda = %d", i));
  
  figure(counter++);
  plot(to_plot);
  grid on;
  title(sprintf("Average number of clients in a M/M/1/10 queue: Convergence for Lambda = %d", i));
  xlabel("Transitions in thousands");
  ylabel("Average number of clients");
endfor