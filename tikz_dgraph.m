function tikz_dgraph(texfile,A,pos,csize,psize,ebend,csp)

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
fprintf(fd,'\\begin{document}\n\n');
fprintf(fd,'\\begin{tikzpicture}[x=%s, y=%s]\n',csize{1},csize{2});

fprintf(fd,'\\begin{scope}[every node/.style={circle,very thick,minimum size=%s,draw}]\n',psize);
for i = 1:n
	fprintf(fd,'\t\\node (%d) at (%8.4f,%8.4f) {$%d$};\n',i,pos(i,1),pos(i,2),i);
end
fprintf(fd,'\\end{scope}\n');

fprintf(fd,'\\begin{scope}[>={Stealth},every node/.style={fill=white,circle},every edge/.style={draw,very thick}]\n');
for i = 2:n
	for j = 1:i-1
		cij = cs_cubic_red(A(i,j),0,1,csp);
		cji = cs_cubic_red(A(j,i),0,1,csp);
		if A(i,j) ~= 0
			if A(j,i) ~= 0
				fprintf(fd,'\t\\path[color={rgb,255:red,%3d;green,%3d;blue,%3d},->] (%d) edge[bend right =  %d] (%d);\n',cij(1),cij(2),cij(3),j,ebend,i);
				fprintf(fd,'\t\\path[color={rgb,255:red,%3d;green,%3d;blue,%3d},->] (%d) edge[bend left  = -%d] (%d);\n',cji(1),cji(2),cji(3),i,ebend,j);
			else
				fprintf(fd,'\t\\path[color={rgb,255:red,%3d;green,%3d;blue,%3d},->] (%d) edge (%d);\n',cij(1),cij(2),cij(3),j,i);
			end
		else
			if A(j,i) ~= 0
				fprintf(fd,'\t\\path[color={rgb,255:red,%3d;green,%3d;blue,%3d},->] (%d) edge (%d);\n',cji(1),cji(2),cji(3),i,j);
			end
		end
	end
end
fprintf(fd,'\\end{scope}\n');

fprintf(fd,'\\end{tikzpicture}\n\n');
fprintf(fd,'\\end{document}\n');
fclose(fd);

end

function i = mapcol(x,N)

	i = floor(N*x)+1;
	if i > N
		i = N;
	end
end

function rgb = cs_linear_red(x,xlo,xhi,~)

	y = (x-xlo)./(xhi-xlo);
	rgb = ones(length(x),3);
	rgb(:,1) = 1;
	rgb(:,2) = 1-y;
	rgb(:,3) = 1-y;
	rgb = round(255*rgb);

end

function rgb = cs_cubic_red(x,xlo,xhi,p)

	a = 1+2*(1-p);
	b = 3*(1-a);
	c = 1-a-b;
	y = (x-xlo)./(xhi-xlo);
	y = a*y + b*y.^2 + c*y.^3;
	rgb = ones(length(x),3);
	rgb(:,1) = 1;
	rgb(:,2) = 1-y;
	rgb(:,3) = 1-y;
	rgb = round(255*rgb);

end
