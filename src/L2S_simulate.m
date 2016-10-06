function L2S_simulate(L2SStruct,parameters)

global c_sim;

simNum = 1;

for chMult = 1:length(L2SStruct.chan_multipath)
    
    c_sim.chan_multipath = L2SStruct.chan_multipath{chMult};
    
    for ver = 1:length(L2SStruct.version)
        
        c_sim.version = L2SStruct.version{ver};
        
        for wChan = L2SStruct.w_channel
            
            c_sim.w_channel = wChan;
            
            for cyPre = 1:length(L2SStruct.cyclic_prefix)
                
                c_sim.cyclic_prefix = ...
                    L2SStruct.cyclic_prefix{cyPre};
                
                for data_len = L2SStruct.data_len
                    
                    c_sim.data_len = data_len;
                    
                    for numChannRea = 1:L2SStruct.maxChannRea
                        
                        if L2SStruct.display
                            disp(['Channel model: '...
                                L2SStruct.chan_multipath{chMult}]);
                            disp(['Standard: '...
                                L2SStruct.version{ver}]);
                            disp(['Bandwidth: ' num2str(wChan)]);
                            disp(['Cyclic prefix: '...
                                L2SStruct.cyclic_prefix{cyPre}]);
                            disp(['Data length: ' num2str(data_len)]);
                            disp(['Channel realization: '...
                                num2str(numChannRea)]);
                        end
                        
                        [per,~,C_channel] = hsr_sim(parameters);
                        SNRp = L2S_SNRp(c_sim,C_channel);
                        
                        filename = ['L2S_results_' num2str(simNum) '.mat'];
                        save(filename,'c_sim','SNRp','per')
                        simNum = simNum + 1;
                        
                    end % SNRps loop
                    
                end % data_len loop
                
            end % cyclic_prefix loop
            
        end % w_channel loop
        
    end % version loop
    
end % chan_multipath loop

end