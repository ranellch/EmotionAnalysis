function [ idx ] = nearest_neighbor( new_vector, all_vectors, n )
%IDX = NEAREST_NEIGHBOR(NEW_VECTOR, ALL_VECTORS, N) returns indices of the
%top N closest matching vectors in all_vectors. IDX is a N x 1
%column vector of indices ranked from best to worst, i.e.
%ALL_VECTORS(IDX(1)) is the best possible match based on closest Euclidean
%distance to NEW_VECTOR

num_tests = size(all_vectors,1);
p_dists = zeros(num_tests, 2);
for i = 1:num_tests
    p_dists(i,2) = pdist([new_vector;all_vectors(i,:)]);
    p_dists(i,1) = i;
end

p_dists = sortrows(p_dists,2); %sort in ascending order (lower distance = closer match)
idx = p_dists(1:n,1);

end

