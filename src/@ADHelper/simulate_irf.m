function [output, time] = simulate_irf(obj, T, N, shock_loc, value_loc)
  % Simulate impulse response functions
  %
  % Args:
  %   T (double): time length for simulation
  %   N (double): number of steps
  %   shock_loc (int): which shock to compute impulse response of
  %   value_loc (vector): location of variables to save
  %
  % Returns:
  %   : [output, time]
  %
  %   * output (matrix): simulated path
  %   * time (vector): time vector
  %
  % See also:
  %   - :attr:`shock2loc <ADHelper.shock2loc>`
  %

  if nargin < 4
    shock_loc = 1;
  end

  if nargin < 5
    if ~isempty(obj.inv_reduction)
      value_loc = (1:size(obj.inv_reduction,1))';
    else
      value_loc = (1:size(obj.G1, 1))';
    end
  end

  if obj.is_cont_time
    time = linspace(0,T,N);
    dt = T/N;
    v = zeros(size(obj.G1,1),N);
    v(:,1) = obj.impact(:, shock_loc);

    iden = speye(size(obj.G1,1));
    for i = 1:N-1
      if obj.verbose
        if ~mod(i,floor(N/10))
          disp(i/N);
        end
      end
      v(:,i+1) = (iden - obj.G1*dt)\v(:,i);
      % v(:,i+1) = (iden + obj.G1./dt)*v(:,i) ;
    end
  else
    v = zeros(size(obj.G1,1), N);
    v(:,1) = obj.impact(:, shock_loc);
    time = 1:N;
    for i = 1:N-1
      v(:, i+1) = obj.G1*v(:,i);
    end
  end
  if ~isempty(obj.inv_reduction)
    output = obj.inv_reduction(value_loc, :)*v;
  else
    output = v(value_loc, :);
  end
end
