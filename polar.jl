tt = 0:0.001:10
@manipulate for z = slider(-2:0.1:2, label=L"\zeta"), w = slider(0.1:0.1:2, label=L"\omega_n"); withfig(fig) do
        y = step_response(z, w, tt)
        s1, s2 = poles(z, w)
        tmax = max_time(z, w)
        ts = settling_time(z, w)
        os = overshoot(z)
        theta = pole_angle(z)
        
        
        pole_area[:set_title]("Poles: $(ptype(s1, s2))")
        pole_plot[:set_data](real([s1;s2]), imag([s1;s2]))
        angle_plot[:set_data]([real(s1);0;real(s2)],[imag(s1);0;imag(s2)])
        
        w_text[:set_position]((real(s1)/2,imag(s1)/2))
        w_text[:set_rotation](-theta)
        ang_text[:set_text](string(L"\theta = \arccos \zeta =",round(theta,2), L"^\circ"))

        step_area[:set_title]("Step response: $(rtype(z))")
        step_plot[:set_data](tt, y)
        tmax_plot[:set_data]([tmax;tmax],[0;1+os])
        if isnan(tmax)
            tmax_text[:set_text]("")
        else
            tmax_text[:set_text](string(L"$t_{max}$ = ", "$(z < 0 ? string(NaN) : round(tmax,1))", " s"))
            tmax_text[:set_position]((tmax-0.8,-0.2))
        end
        if isnan(os)
            os_text[:set_text]("")
        else
            os_text[:set_text]("Overshoot: $(round(os*100,2))%")
            os_text[:set_position]((1, 1+os+0.2))
            os_plot[:set_data]([0;10],[1+os;1+os])
        end
        if isnan(ts)
            ts_text[:set_text]("")
        else
            ts_text[:set_text]("Settling time: $(round(ts, 2)) s")
        end
    end
end