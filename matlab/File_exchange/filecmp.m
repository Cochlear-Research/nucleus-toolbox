function t = filecmp(file1, file2)

% filecmp: Compare two files (binary comparison).
%
% t = filecmp(file1, file2)
%
% file1:  first file name
% file2:  second file name
% t:      1 if both files file1 and file2 exist and are identical,
%         0 otherwise.
%
% The two files are read and compared as binary files.

%   Author:      Peter J. Acklam
%   $Date: 2023/06/06 $
%   E-mail:      jacklam@math.uio.no
%   URL:         http://www.math.uio.no/~jacklam

   % check number of input arguments
   error(nargchk(2, 2, nargin));

   % see if first file exists
   if ~exist(file1, 'file')
      error([file1 ': No such file.']);
   end

   % see if second file exists
   if ~exist(file2, 'file')
      error([file2 ': No such file.']);
   end

   % try to open first file for reading
   fid1 = fopen(file1, 'rb');
   if fid1 < 0
      error([file1 ': Can''t open file for reading.']);
   end

   % try to open second file for reading
   fid2 = fopen(file2, 'rb');
   if fid2 < 0
      fclose(fid1);
      error([file2 ': Can''t open file for reading.']);
   end

   % See if the two files are actually the same file.
   if fid1 == fid2
      fclose(fid1);
      error('The two file names refer to the same file.');
   end

   % Quick exit if the file sizes differ.
   dir1 = dir(fopen(fid1));
   dir2 = dir(fopen(fid2));
   if dir1.bytes ~= dir2.bytes
      t = 0;
      return
   end

   blocksize = 128;     % number of bytes to read at a time
   t = 1;               % assume files are identical

   while t

      % read a block of data from each file
      [data1, count1] = fread(fid1, blocksize, 'uchar');
      [data2, count2] = fread(fid2, blocksize, 'uchar');

      % compare number of bytes read and then the actual bytes
      if count1 ~= count2 | any(data1 ~= data2)
         t = 0;
      end

      % see of we have reached the end of one or both files
      if count1 == 0 | count2 == 0;
         break
      end

   end

   % close the files
   fclose(fid1);
   fclose(fid2);
