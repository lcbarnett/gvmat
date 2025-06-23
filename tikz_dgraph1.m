function tikz_dgraph1(texfile,A,pos,csize,psize,ebend)

% A(i,j) is j -> i

[n,n1] = size(A);
assert(ismatrix(A) && n1 == n,'Adjacency matrix must be a square matrix');
[n2,n3] = size(pos);
assert(ismatrix(pos) && n2 == n && n3 == 2,'Positions must be an n x 2 matrix where n is the number of nodes');

[fd,emsg] = fopen(texfile,'w+t');
assert(fd ~= -1,'failed to open tikz LaTeX file ''%'': %s',texfile,emsg);
fprintf(fd,'\\documentclass[border=2pt]{standalone}\n\n');
fprintf(fd,'\\usepackage{tikz}\n');
fprintf(fd,'\\usetikzlibrary{graphs,graphdrawing,arrows.meta}\n');
fprintf(fd,'\\usegdlibrary {force}\n\n');
fprintf(fd,'\\begin{document}\n\n');
fprintf(fd,'\\begin{tikzpicture}[x=%s, y=%s]\n',csize{1},csize{2});

fprintf(fd,'\\begin{scope}[every node/.style={circle,very thick,minimum size=%s,draw}]\n',psize);
for i = 1:n
	fprintf(fd,'\t\\node (%d) at (%g,%g) {$%d$};\n',i,pos(i,1),pos(i,2),i);
end
fprintf(fd,'\\end{scope}\n');

fprintf(fd,'\\begin{scope}[>={Stealth[red]},every node/.style={fill=white,circle},every edge/.style={draw=red,very thick}]\n');
for i = 2:n
	for j = 1:i-1
		if A(i,j) ~= 0
			if A(j,i) ~= 0
				fprintf(fd,'\t\\path [->] (%d) edge[bend right =  %d] node[{rectangle}] {$%4.2f$} (%d);\n',j,ebend,A(i,j),i);
				fprintf(fd,'\t\\path [->] (%d) edge[bend left  = -%d] node[{rectangle}] {$%4.2f$} (%d);\n',i,ebend,A(j,i),j);
			else
				fprintf(fd,'\t\\path [->] (%d) edge node[{rectangle}] {$%4.2f$} (%d);\n',j,A(i,j),i);
			end
		else
			if A(j,i) ~= 0
				fprintf(fd,'\t\\path [->] (%d) edge node[{rectangle}] {$%4.2f$} (%d);\n',i,A(j,i),j);
			end
		end
	end
end
fprintf(fd,'\\end{scope}\n');

fprintf(fd,'\\end{tikzpicture}\n\n');
fprintf(fd,'\\end{document}\n');
fclose(fd);
