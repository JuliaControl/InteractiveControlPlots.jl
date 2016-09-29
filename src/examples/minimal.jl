using ControlSystems, GtkInteract, Immerse

k = slider(1:0.1:10)

cg1 = cairographic(width=200,height=150);

w = window(vbox(k,grow(cg1)))

Reactive.preserve(map(k) do k
  fig1 = Immerse.plot(y=(1:10).^k)
  push!(cg1, fig1)
end)
w
