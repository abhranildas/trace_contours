function contours=trace_contours(binary_image)
% TRACE_CONTOURS traces contours from a binary image
%
% Abhranil Das <abhranil.das@utexas.edu>
% Center for Perceptual Systems, University of Texas at Austin
% If you use this code, please cite:
% <a href="matlab:web('http://dx.doi.org/10.13140/RG.2.2.10585.80487')"
% >Camouflage Detection & Signal Discrimination: Theory, Methods & Experiments</a>.
%
%
% Example:
% img=imread('circuit.tif');
% edge_pixels=edge(img);
% contours=trace_contours(edge_pixels);
%
% Input:
% binary_image      binary image of contour pixels
%
% Output:
% contours          cell array, whose each element is a list of the
%                   sequential pixel coordinates of a connected contour

[row,col]=find(binary_image);
coords=[row,col];
contours={};
n_px=size(coords,1);

% create link map of the different pixels
links=false(n_px);
for i=1:n_px
    for j=i+1:n_px
        if norm(coords(i,:)-coords(j,:))<=2
            links(i,j)=true; links(j,i)=true;
        end
    end
end

while nnz(links(:)) % while there are pixels left in link map

    % find first pixel in link map with only one link (end point)
    idx=find(sum(links,2)==1,1);
    if isempty(idx) % if no endpoint found
        idx=find(sum(links,2),1); % pick the first pixel with any link
    end

    % trace contour starting from this pixel
    contour=zeros(1,2);
    i=1;
    while true
        contour(i,:)=coords(idx,:); % store this pixel
        idx_next=find(links(idx,:),1); % find the next pixel
        if isempty(idx_next)
            break
        end
        links(idx,:)=false; links(:,idx)=false; % remove this pixel
        idx=idx_next; % move to the next pixel
        i=i+1;
    end

    contours{end+1,1}=contour; % add contour to the list of contours
end
end

