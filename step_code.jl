using PyPlot, Interact
PyPlot.svg(true)

function poles(z, w)
    s1 = -z*w + w*sqrt(complex(1-z^2))*im
    s2 = -z*w - w*sqrt(complex(1-z^2))*im
    return s1, s2
end

function step_response(z, w, tt)
    if z > 1
        # overdamped
        s1, s2 = poles(z, w)
        return real(1 - exp(s1*tt).*s2/(s2 - s1) - exp(s2*tt).*s1/(s1-s2))
    elseif z == 1
        # critically damped
        return real(1 - exp(-w.*tt) - w.*tt.*exp(-w.*tt))
    else
        # underdamped
        return real(1 - (exp(-z*w.*tt)./sqrt(complex(1-z^2))).*sin(w*sqrt(complex(1-z^2)).*tt + acos(complex(z))))
    end
end

function overshoot(z)
    z < 0 ? NaN : z < 1 ? real(exp(-pi*z/sqrt(complex(1-z^2)))) : 0
end

function max_time(z, w)
    z < 1 ? real(pi/(w*sqrt(complex(1-z^2)))) : NaN
end

function rtype(z)
    z < 0 ? "unstable!" : 
        z < 1 ? "underdamped" : 
        z == 1 ? "critically damped" : "overdamped"
end

function ptype(s1, s2)
    x = max(real(s1), real(s2))
    x < 0 ? "stable" : x == 0 ? "marginally stable" : "unstable"
end

"""
GK (5-111)
"""
function settling_time(z, w, cts=0.05)
    z < 0 ? 
        NaN : z < 0.69 ? 
    real(-log(cts*sqrt(complex(1-z^2)))/(z*w)) : real(4.5*z/w)
end

function pole_angle(z)
    z < -1 ? 180 : z < 1 ? real(acosd(z)) : 0
end


fig = figure(figsize=(11,5))
pole_area = subplot2grid((1,2),(0,0))
pole_plot = pole_area[:plot]([0;0],[0;0], marker="o", lw=0)[1]
angle_plot = pole_area[:plot]([0;0;0],[0;0;0], ls="--", color="k", alpha=0.5)[1]
grid(true, alpha=0.4)

w_text = text(0,0,L"\omega_n")
ang_text = text(-1.6, 0.1, "")

pole_area[:axis]([-2.1;2.1;-2.1;2.1])
title("Poles")
xlabel(L"Real ($\alpha$)")
ylabel(L"Imaginary ($\omega$)")

step_area = subplot2grid((1,2),(0,1))
step_plot = step_area[:plot]([0;0],[0,0])[1]
tmax_plot = step_area[:plot]([0;0],[0;0],ls="--",color="k", alpha=0.5)[1]
os_plot = step_area[:plot]([0;0],[0;0], ls="--", color="k", alpha=0.5)[1]
step_area[:axis]([0;10;-1;3])
grid(true, alpha=0.4)

tmax_text = text(0, 0, "")
os_text = text(0, 0, "")
ts_text = text(0.5, -0.8, "")

title("Step response")
xlabel("time (s)")
ylabel("amplitude")