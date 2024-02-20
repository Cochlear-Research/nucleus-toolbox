%CMP	to compare two files byte by byte
%
%	CMP compares two files byte by byte.
%	if the files do not match, it prints the
%	position and the numerical and ASCII char
%	representation of the first differing
%	byte and its ten neighbors.
%
%SYNTAX
%--------------------------------------------------------------------------------
%	    CMP FILE1 FILE2 OPT
%	R = CMP(FILE1,FILE2,OPT)
%
%INPUT
%--------------------------------------------------------------------------------
% FILEn		file names including(!) extension
%
% OPT		description
% -------------------------------------------------
% -s		do NOT show runtime output
% -b		do NOT show waitbar for files > 1mb
%
%OUTPUT
%--------------------------------------------------------------------------------
% R		structure with (selected) fields
%		.runtime	time to compare files
%		.error		false if ran without error,
%				   true otherwise
%		.errormsg	empty if ran without error,
%				   last error message otherwise
%
%EXAMPLE
%--------------------------------------------------------------------------------
%%	save 80mb of data in a temporary file and compare it to itself
%%	wintel system: c2.2*2.4ghz/ram.2gb/winvista/r2007a
%
%		fnam='cmp_test.mat';
%		tmat=rand(1,10*2^20);
%		save(fnam,'tmat');
%		clear tmat;
%		r=cmp(fnam,fnam,'-b');
%%	CMP>   83886272B   81920KB    80MB   0GB  28-Mar-2007 10:29:49  cmp_test.mat
%%	CMP>   83886272B   81920KB    80MB   0GB  28-Mar-2007 10:29:49  cmp_test.mat
%%	CMP> done     1.0171s
%		delete(fnam);

% created:
%	us	03-Nov-1989
% modified:
%	us	28-Mar-2007 10:29:49	/ FEX

%--------------------------------------------------------------------------------
function	r=cmp(varargin)

		magic='CMP';
		ver='28-Mar-2007 10:29:49';

% check input args
	if	nargin < 2
		help(mfilename);
	if	nargout
		r=[];
	end
		return;
	end

		[r,par]=ini_engine([],[],ver,magic,varargin{:});
		[r,par]=get_files(r,par);
	if	r.error
	if	~nargout
		clear r;
	end
		return;
	end

	if	par.bflg				&&...
		par.bm > par.ss
		[fpat,frot1,fext1]=fileparts(par.flst{1});
		[fpat,frot2,fext2]=fileparts(par.flst{2});
		par.wh=waitbar(0,sprintf('%-1db   %-1dk   %-1dm   %-1dg',round(par.bm./1024.^(0:3))));
		set(par.wh,'name',sprintf('CMP>   %s   :   %s',[frot1,fext1],[frot2,fext2]));
		wc=findall(par.wh,'type','text');
		set(wc,'interpreter','none');
	else
		par.wh=0;
	end

		t1=clock;
	for	b=0:par.bs:par.bm
	if	par.wh
		waitbar(b/par.bm,par.wh);
	end
		[par.r1,par.c1]=fread(par.fp(1),[1,par.bs],'char=>char');
		[par.r2,par.c2]=fread(par.fp(2),[1,par.bs],'char=>char');
	if	par.c1==0				&&...
		par.c2==0
		break;
	end
		ie=cmp_str(par);
	if	~ie					||...
		par.c1==0				||...
		par.c2==0
		[r,par]=get_bytes(r,par);
		break;
	end
		par.ro=par.rs;
	end
		r.runtime=etime(clock,t1);
		aclose(par);

	if	par.wh
		delete(par.wh);
	end
	if	~par.sflg
		disp(sprintf('CMP> done %10.4fs',r.runtime));
	end
	if	~nargout
		clear r;
	end
		return;
%--------------------------------------------------------------------------------
function	[r,par]=ini_engine(r,par,ver,magic,varargin)


% common defines
		par.ss=1e6;				% buffer size
		par.flst=varargin(1:2);
		par.fp=nan(2,1);
		par.sflg=false;
		par.bflg=true;
		par.fmt=sprintf('CMP> %%10dB%%8dKB%%6dMB%%4dGB  %%s  %%s');
		par.bf=zeros(2,1);
		par.r1=[];
		par.r2=[];
		par.c1=[];
		par.c2=[];
		par.ro=0;
		par.rs=0;

		r.magic=magic;
		r.([magic,'ver'])=ver;
		r.MLver=version;
		r.rundate=datestr(clock);
		r.runtime=0;
		r.f1='';
		r.f2='';
		r.size=[];
		r.error=false;
		r.errorid=0;
		r.emsg='';

	if	any(strcmp(varargin(3:end),'-s'))
		par.sflg=true;
	end
	if	any(strcmp(varargin(3:end),'-b'))
		par.bflg=false;
	end

		r.f1=varargin{1};
		r.f2=varargin{2};
	if	~ischar(r.f1)				||...
		~ischar(r.f2)
		r=get_error(par,r,-1,'CMP> input(s) not a char string');
	if	~par.sflg
		disp(r.emsg);
	end
	end
		return;
%--------------------------------------------------------------------------------
function	par=aclose(par)

		par.fp=par.fp(par.fp==par.fp&par.fp>0);
	for	i=1:numel(par.fp)
		fclose(par.fp(i));
	end
		par.fp=[];
		return;
%--------------------------------------------------------------------------------
function	[r,par]=get_error(par,r,id,txt)

		r.error=true;
		r.errorid=id;
		r.emsg=txt;

		par=aclose(par);
	if	~par.sflg
		disp(txt);
	end
		return;
%--------------------------------------------------------------------------------
function	[r,par]=get_files(r,par)

	if	r.error
		return;
	end

	for	i=1:2
		d=dir(par.flst{i});
	if	isempty(d)				||...
		numel(d) > 1
		r=get_error(par,r,1,sprintf('CMP> file missing or too many files %-1d: <%s>',i,par.flst{i}));
		return;
	end
		par.bf(i,1)=d.bytes;
		txt=sprintf(par.fmt,...
			round(d.bytes./1024.^(0:3)),...
			d.date,...
			par.flst{i});
	if	~par.sflg
		disp(txt);
	end
		[par.fp(i),msg]=fopen(par.flst{i},'rb');
	if	par.fp(i) < 0
		r=get_error(par,r,2,sprintf('CMP> cannot open file <%s>\nCMP> %s',par.flst{i},msg));
	if	~nargout
		clear r;
	end
		return;
	end
	end
		par.bm=max(par.bf);
		par.bs=min([par.bf;par.ss]);
		r.size=par.bf;

		return;
%--------------------------------------------------------------------------------
function	ie=cmp_str(par)

% note: STRFIND is much(!) faster than any other possible comparator
%		any(par.r1~=par.r2);
%		all(par.r1==par.r2);
%		isequal(par.r1,par.r2);
%		strmatch(par.r1,par.r2);
%		for-loop

		par.rs=par.rs+par.c1;
	if	par.c1==par.c2
		ie=strfind(par.r1,par.r2);
	if	isempty(ie)
		ie=false;
	else
		ie=true;
	end
	else
		ie=false;
	end

		return;
%--------------------------------------------------------------------------------
function	[r,par]=get_bytes(r,par)

		ci=min([par.c1,par.c2]);
	for	j=1:ci
		ix=par.r1(j)~=par.r2(j);
	if	ix
		jb=max([1,j-5]);
		je=min([j+10,ci]);
		ix=jb:je;
		b1=sprintf('%3.3d-',par.r1(ix));
		b2=sprintf('%3.3d-',par.r2(ix));
		l1=repmat(char(2),1,numel(ix));
		l2=repmat(char(2),1,numel(ix));
		ix1=~isstrprop(par.r1(ix),'cntrl');
		ix2=~isstrprop(par.r2(ix),'cntrl');
		l1(ix1)=par.r1(ix(ix1));
		l2(ix2)=par.r2(ix(ix2));
		b1(end)='';
		b2(end)='';
		txt=char({
			sprintf('CMP> files differ at byte :  %-1d',par.ro+j)
			sprintf('CMP> file  1         bytes:  %s',b1)
			sprintf('CMP> file  2         bytes:  %s',b2)
			sprintf('CMP> file  1         chars: <%s>',l1)
			sprintf('CMP> file  2         chars: <%s>',l2)
		});
		[r,par]=get_error(par,r,3,txt);
		break;
	end
	end
		return;
%--------------------------------------------------------------------------------

