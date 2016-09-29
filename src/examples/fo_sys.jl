# load init commands
using InteractiveControlPlots, ControlSystems, GtkInteract

# create sliders etc
x = linspace(-1,1,2)
ws = logspace(-2,2,1000)
k=slider(1:0.1:3, label="K")
logT = slider(-1:0.01:1, label="T")
f1 = checkbox(false,label="Bode plot  ")
f2 = checkbox(false,label="Nyquist plot  ")
f3 = checkbox(false,label="PZ map  ")
f4 = checkbox(false,label="Step plot  ")


# create window
cg1 = cairographic(width=200,height=150)
cg2 = cairographic(width=200,height=150)
cg3 = cairographic(width=200,height=150)
cg4 = cairographic(width=200,height=150)
lT = label("T: ")

vbl(w, len) = vbox(label(w.label),hbox(hskip(len),w))
vbl(w) = vbox(label(w.label),w)

w = window(vbox(hbox(vbl(k),
    vbox(lT,logT),
    vbox(vbl(f1,25),vbl(f3,15)),
    vbox(vbl(f2,35),vbl(f4,22))),
    hbox(grow(cg1), grow(cg2)),
    hbox(grow(cg3), grow(cg4))),
    title="Example")

# loop over parameters
Reactive.preserve(map(k,logT,f1,f2,f3,f4) do k,logT,f1,f2,f3,f4
  T = 10^logT

  #Create the 2nd order system
  sys = tf(k*[1,1],[1, T, 1])

  #Create the plots
  fig1 = bode_immerse(sys, ws, 1e-2, 1e2) #Ylims = (1e-2, 1e2)
  fig2 = nyquist_immerse(sys, ws, -2, 2, -2, 2) #x and ylims
  fig3 = pzmap_immerse(sys,-4,4,-4,4) # x and ylims
  y,t,x = step(sys, 10)
  fig4 = timeplot_immerse(t, y, 0, 4) #ylims

  #Update the text
  push!(lT, "T: " * string(round(T,2)))

  #Push figures
  push!(cg1, f1 ? fig1 : nothing)
  push!(cg2, f2 ? fig2 : nothing)
  push!(cg3, f3 ? fig3 : nothing)
  push!(cg4, f4 ? fig4 : nothing)

end)

# output window for display
w
