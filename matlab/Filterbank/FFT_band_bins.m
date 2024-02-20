function widths = FFT_band_bins(num_bands)
% FFT_band_bins: calculate number of bins per band vector for FFT filterbanks.
% function widths = FFT_band_bins(num_bands)
% Uses the same frequency boundaries as WinDPS ACE & CIS.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Copyright: Cochlear Ltd
%      Authors: Brett Swanson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch num_bands
case 22
   widths = [ 1, 1, 1, 1, 1, 1, 1,    1, 1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8 ];% 7+15 = 22
case 21
   widths = [ 1, 1, 1, 1, 1, 1, 1,    1, 2, 2, 2, 2, 3, 3, 4, 4, 5, 6, 6, 7, 8 ];   % 7+14 = 21
case 20
   widths = [ 1, 1, 1, 1, 1, 1, 1,    1, 2, 2, 2, 3, 3, 4, 4, 5, 6, 7, 8, 8 ];      % 7+13 = 20
case 19
   widths = [ 1, 1, 1, 1, 1, 1, 1,    2, 2, 2, 3, 3, 4, 4, 5, 6, 7, 8, 9 ];         % 7+12 = 19
case 18
      widths = [ 1, 1, 1, 1, 1, 2,    2, 2, 2, 3, 3, 4, 4, 5, 6, 7, 8, 9 ];         % 6+12 = 18
case 17
         widths = [ 1, 1, 1, 2, 2,    2, 2, 2, 3, 3, 4, 4, 5, 6, 7, 8, 9 ];         % 5+12 = 17
case 16
         widths = [ 1, 1, 1, 2, 2,    2, 2, 2, 3, 4, 4, 5, 6, 7, 9,11 ];         % 5+11 = 16
case 15
         widths = [ 1, 1, 1, 2, 2,    2, 2, 3, 3, 4, 5, 6, 8, 9,13 ];            % 5+10 = 15
case 14
            widths = [ 1, 2, 2, 2,    2, 2, 3, 3, 4, 5, 6, 8, 9,13 ];            % 4+10 = 14
case 13
            widths = [ 1, 2, 2, 2,    2, 3, 3, 4, 5, 7, 8,10,13 ];               % 4+ 9 = 13
case 12
            widths = [ 1, 2, 2, 2,    2, 3, 4, 5, 7, 9,11,14 ];                  % 4+ 8 = 12
case 11
            widths = [ 1, 2, 2, 2,    3, 4, 5, 7, 9,12,15 ];                  % 4+ 7 = 11
case 10
               widths = [ 2, 2, 3,    3, 4, 5, 7, 9,12,15 ];                  % 3+ 7 = 10
case  9
               widths = [ 2, 2, 3,    3, 5, 7, 9,13,18 ];                     % 3+ 6 =  9
case  8
               widths = [ 2, 2, 3,    4, 6, 9,14,22 ];                        % 3+ 5 =  8
case  7
                  widths = [ 3, 4,    4, 6, 9,14,22 ];                        % 2+ 5 =  7
case  6
                  widths = [ 3, 4,    6, 9,15,25 ];                           % 2+ 4 =  6
case  5
                  widths = [ 3, 4,    8,16,31 ];                           % 2+ 3 =  5
case  4
                     widths = [ 7,    8,16,31 ];                           % 1+ 3 =  4
case  3
                     widths = [ 7,   15,40 ];                              % 1+ 2 =  3
case  2
                     widths = [ 7,   55 ];                                 % 1+ 1 =  2
case  1
                        widths = [ 62 ];                                %         1
otherwise
	error('illegal number of bands');
end
