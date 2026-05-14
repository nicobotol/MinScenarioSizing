classdef HSSX < handle
  % DataX class can perform the following operations on its objects:
  % 1) DoWindPower: computes the mechanical output power given the wind speed
  %
  % Static Methods:
  % 
  %-------------------------------------------------------
  % Example of creating an onject (test1) of this class:
  % test1 = DataX(GFA.P_Active_Total);
  %
  % DataX Properties:
  %   iniVec      - Initial "vector" of data
  %   V_in        - cut-in wind speed [m/s]
  %   V_out       - cut-out wind speed [m/s]
  %   V_rated     - rated wind speed [m/s]
  %   Pm_rated    - rated mechanical power [W]
  %   Pe_rated    - rated electrical power [W]
  %
  % DataX Methods:
  %   GroupSamplesBy
  
 
  
%   ____                            _   _           
%  |  _ \ _ __ ___  _ __   ___ _ __| |_(_) ___  ___ 
%  | |_) | '__/ _ \| '_ \ / _ \ '__| __| |/ _ \/ __|
%  |  __/| | | (_) | |_) |  __/ |  | |_| |  __/\__ \
%  |_|   |_|  \___/| .__/ \___|_|   \__|_|\___||___/
%                  |_|                              
  properties
    C_storage_kg             % [kg] energy capacity
    C_storage_u              % [Wh] energy capacity
    C_unitaryP_el            % Unitary power of the electrolyzer 
    C_unitaryP_fc            % Unitary power of the fuel cell
    SOC_init     = 0.5;      % percentage of energy stored
    SOC_max      = 1;        % maximum energy stored
    SOC_min;      % minimum energy stored
    eta_conv     = 0.999999; % conversion efficiency
    eta_ch       = 1;        % charging efficiency
    eta_dc       = 1;        % discharging efficiency
    C_CAPEX_el               % capital cost electrolyzer
    C_OPEX_el                % operational cost electrolyzer
    C_CAPEX_fc               % capital cost fuel cell
    C_OPEX_fc                % operational cost fuel cell
    C_CAPEX_st               % capital cost tank storage
    C_OPEX_st                % operational cost tank storage
    C_CAPEX_rev_FC            % capital cost reversible fuel cell
    C_OPEX_rev_FC             % operational cost reversible fuel cell
    C_DECOM      = 0.0;      % [€/W] operational cost
    Pfc_max                  % [W] maximum charging power
    Pel_max                  % [W] maximum discharging power
    E_H_max                  % [kg] maximum hydrogen mass stored in the tank
    eta_H                    % amount of energy per kilogram hydrogen
    eta_el                   % electrolyzer efficiency
    eta_fc                   % fuel cell efficiency
  end % properties
 

  methods

  end % normal methods

%   ____  _        _   _                       _   _               _     
%  / ___|| |_ __ _| |_(_) ___   _ __ ___   ___| |_| |__   ___   __| |___ 
%  \___ \| __/ _` | __| |/ __| | '_ ` _ \ / _ \ __| '_ \ / _ \ / _` / __|
%   ___) | || (_| | |_| | (__  | | | | | |  __/ |_| | | | (_) | (_| \__ \
%  |____/ \__\__,_|\__|_|\___| |_| |_| |_|\___|\__|_| |_|\___/ \__,_|___/
                                                                       
  methods(Static = true)
    % static methods

  end	% static methods
  
%   __  __      _   _               _     
%  |  \/  | ___| |_| |__   ___   __| |___ 
%  | |\/| |/ _ \ __| '_ \ / _ \ / _` / __|
%  | |  | |  __/ |_| | | | (_) | (_| \__ \
%  |_|  |_|\___|\__|_| |_|\___/ \__,_|___/
                                        
  methods
  
  end
  %    
  %
end % classdef

