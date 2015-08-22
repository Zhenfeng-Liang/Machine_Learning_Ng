function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


% Part 1
a1 = [ones(m, 1) X];
z2 = a1 * Theta1';
a2 = h1 = [ones(m, 1) sigmoid(z2)];
z3 = a2 * Theta2';
a3 = h2 = sigmoid(z3);
log_h = log(h2);
log_1_minus_h = log(1 - h2);


y_eye = eye(num_labels);
y_1_minus_eye = 1 - y_eye;

tmp_sum = 0;
for i = 1:m
    flag = y(i);
    tmp_sum = tmp_sum - log_h(i,:) * y_eye(:,flag)  - log_1_minus_h(i,:) * y_1_minus_eye(:,flag);
end

J = tmp_sum / m;

tmp_theta1 = Theta1;
tmp_theta2 = Theta2;
tmp_theta1(:,1) = 0;
tmp_theta2(:,1) = 0;

regularization_term_cost = lambda / (2 * m) * (sum(sum(tmp_theta1.^2)) + sum(sum(tmp_theta2.^2)));
J = J + regularization_term_cost;



% Part 2
for t = 1:m
    flag = y(t);
    delta_3 = a3(t,:)' - y_eye(:,flag);
    delta_2 = Theta2' * delta_3 .* [0 ; sigmoidGradient(z2(t,:))'];
    Theta2_grad = Theta2_grad + delta_3 * a2(t, :);
    Theta1_grad = Theta1_grad + delta_2(2:end) * a1(t, :);
end

Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;


% Part 3
Theta1_grad = Theta1_grad + lambda / m * tmp_theta1;
Theta2_grad = Theta2_grad + lambda / m * tmp_theta2;






% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
