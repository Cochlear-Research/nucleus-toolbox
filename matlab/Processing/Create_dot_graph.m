function Create_dot_graph(p, file_name)
% Create_dot_graph: Create a block diagram of the processing chain.
% Uses the GraphViz dot language.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright: Cochlear Ltd
%   Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p = Ensure_field(p, 'map_name', 'map');
if nargin < 2
    file_name = p.map_name;
end
fid = fopen([file_name, '.gv'], 'w');

fprintf(fid, 'digraph %s {', p.map_name);
fprintf(fid, 'node [shape=box, width=3];\n');

N = length(p.processes);
for n = 1:N
    edge = '->';
    if n == N
        edge = '';
    end
    fprintf(fid, '%s %s\n', p.processes{n}, edge);    
end

fprintf(fid, '}\n');
