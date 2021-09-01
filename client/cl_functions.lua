function startmihra(atm)
    TriggerServerEvent('nb_atmrob:server:startedrob')
    TriggerEvent("utk_fingerprint:Start", 4, 2, 2, function(outcome, reason)
        if outcome == true then 
            TriggerServerEvent('nb_atmrob:server:getcash', true, atm)
        elseif outcome == false then
            TriggerServerEvent('nb_atmrob:server:getcash', false, atm)
        end
    end)
end
