%T1measure_remyelination
%script for processing all data points into a map of each slice
%see bottom for processing tubes individually to give histograms

%if you go to the experiment number directory and open the method file
%these values can be found as
%PVM_Matrix = [rown coln]
%PVM_SPackArrNSlices=( 1 ) = slicen
%PVM_FairTIR_Arr=( 16 ) = InvTs with the value of milliseconds


InvTs=[20 100 500 1000 2000 3000 4000 5000]/1000;  %convert to seconds
rown=192;
coln=128;
slicen=1;

%this needs to be guessed but 2500 is a good value
threshold=2500;

%setup parameters
TIRno=length(InvTs);
tris=2*TIRno;
bigmask=zeros(rown, coln, slicen);

%change this to the path where you have this data file or number 6
T1set=open2dseq('/Users/brechb01/Documents/Imaging_remyelination/Data/MRI_9.4T/20220419_113908_14_EB_22_24_MBP_LVV_bilateral_Oatp_left_GFP_right_2_1_2/11/pdata/1',[rown coln slicen tris]);
 
% %% Generate R1 map of whole image
% % make the mask of data to process
for a=1:rown
    for b=1:coln
        for c=1:slicen
            if T1set(a,b,c,tris)>threshold
                bigmask(a,b,c)=1;
            end
        end
    end
end
%
%
%
R1maps=zeros(rown, coln, slicen);
%
for c=1:slicen
    ts=T1set(:,:,c,1:2:(tris-1));
    ts2=permute(ts,[1 2 4 3]);
    [ r10map, fit_map,r10list ] = r1mapper4( ts2, InvTs, bigmask(:,:,c) );
    R1maps(:,:,c)=r10map;
end
clims = [0 1]; %display any value above 1 as yellow and any value below 0 as dark blue.
% %this is to see the lesions on the map.
imagesc(r10map, clims) %to see the map
colorbar %to display colorbar on the image


% draw a maks for an individual region
%%X=slice number
%
% % comment this section after first ROI is drawn to keep it
X=1;
% imagesc(T1set(:,:,X,tris-1)); % where X is the slice you want
% h =drawellipse;
% BW=createMask(h);
% maskt=ones(rown,coln).*BW;
% %
%then run the r1mapper4
ts=T1set(:,:,X,1:2:(tris-1)); %remember to set X the same as the mask was drawn for
ts2=permute(ts,[1 2 4 3]);
[ r10map, fit_map,r10list ] = r1mapper4( ts2, InvTs, maskt );
%From this you can
mean(r10list) %gives the mean R1 for that ROI
histogram(r10list) %gives a histogram showing the distribution of measured R1
% %values in that ROI
