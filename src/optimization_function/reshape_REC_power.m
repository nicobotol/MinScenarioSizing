function [REC_obj, Pload] = reshape_REC_power(REC_obj, Pload, T, W)

  if ~isempty(REC_obj)
    for r = 1:size(REC_obj, 2)
      REC_obj{r}.Power = reshape(REC_obj{r}.Power, T, W);
    end
  end

  Pload = reshape(Pload, T, W);
end