% Startup stuff

fprintf('[gvmat startup] Initialising gvmat\n');

global gvmat_root;
gvmat_root = fileparts(mfilename('fullpath')); % directory containing this file
addpath(gvmat_root);
fprintf('[gvmat startup] Added path %s\n',gvmat_root);

fprintf('[gvmat startup] Initialised (you may re-run `startup'' at any time)\n');
