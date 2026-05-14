% % This function converts the dataset into converter power

% % if use_generate_dataseries == 0
% %   do_power_from_datasets
% % elseif use_generate_dataseries == 1
% %   do_power_from_scenarios
% % end


% if use_generate_dataseries == 0
%   WT.WindValue = wind.iniVec;

%   PV.RadiationValue = irradiance.iniVec;
  
%   WEC.iniVec    = met_data_swh;
%   WEC.SWH       = reshape(WEC.iniVec, [], 1);
%   WEC.iniVec    = met_data_mwp;
%   WEC.W_period  = reshape(WEC.iniVec, [], 1);

% elseif use_generate_dataseries == 1
%   % WT.iniVec               = ResselScens_N{1};
%   WT.WindValue            = ResselScens_N{1};

%   % PV.iniVec               = ResselScens_N{2};
%   PV.RadiationValue       = ResselScens_N{2};

%   % WEC.iniVec              = ResselScens_N{3};
%   WEC.SWH                 = ResselScens_N{3};
%   % WEC.iniVec              = ResselScens_N{4};
%   WEC.W_period            = ResselScens_N{4};
%   % WT.iniVec               = ResselScens_N{1};
%   % WT.WindValue            = WT.GroupSamplesBy();

%   % PV.iniVec               = ResselScens_N{2};
%   % PV.RadiationValue       = PV.GroupSamplesBy();

%   % WEC.iniVec              = ResselScens_N{3};
%   % WEC.SWH                 = WEC.GroupSamplesBy();
%   % WEC.iniVec              = ResselScens_N{4};
%   % WEC.W_period            = WEC.GroupSamplesBy();

% end


function [REC_tmp] = do_power(REC_tmp, ResselScens_N)
  % This function computes the power of the converters based on the environmental data
  REC_tmp.WT.WindValue            = ResselScens_N{1};
  REC_tmp.PV.RadiationValue       = ResselScens_N{2};
  REC_tmp.WEC.SWH                 = ResselScens_N{3};
  REC_tmp.WEC.W_period            = ResselScens_N{4};

  REC_tmp.WT.DoWindPower;
  REC_tmp.WT.Power(REC_tmp.WT.Power < 1e-5) = 1e-5;
  
  REC_tmp.PV.DoPVPower;
  REC_tmp.PV.Power(REC_tmp.PV.Power<=1e-8) = 1e-8;
  
  REC_tmp.WEC.PowRated  = REC_tmp.WEC.WEC_coefficient*max(REC_tmp.WEC.PowerMatrix, [], 'all');
  REC_tmp.WEC.DoWECPowerCorpower; 
  
end