function bode_immerse(sys, w, ymin, ymax)
  mag, phase, _ = bode(sys, w)
  I = find(y-> ymin .<= y .<= ymax, mag) # Filter out from range
  mag = mag[I]
  ws = w[I]
  xmajor, xminor, xmajorText, xminorText = get_log_ticks(w)
  ymajor, yminor, ymajorText, yminorText = get_log_ticks([ymin;mag;ymax])
  Immerse.plot(
        major_lines(log10(ws), log10(mag), log10(xmajor), log10(ymajor)),
        layer(x=log10(ws), y=log10(mag), Geom.line),
        Stat.xticks(ticks = log10([xmajor;xminor])),
        Stat.yticks(ticks = log10([ymajor;yminor])),
        Scale.x_continuous(labels= x -> labelf(x), maxvalue=log10(maximum(w))),
        Scale.y_continuous(labels= x -> labelf(x), minvalue=log10(ymin), maxvalue=log10(ymax)),
        Guide.xlabel("Frequency (rad/s)"),
        Guide.ylabel("Magnitude (abs)", orientation=:vertical),
        default_theme)
end
function nyquist_immerse(sys, w, xmin, xmax, ymin, ymax)
  re, im, _ = nyquist(sys, w)
  I = (ymin .<= im .<= ymax) & (xmin .<= re .<= xmax)
  re = re[I]
  im = im[I]
  Immerse.plot(
        major_lines(re, im, [0.0], [0.0]),
        layer(x=[-1], y=[0], Geom.point, Theme(default_color=Colors.RGB(.8,.0,.0), default_point_size=5pt)),
        layer(x=re, y = im, Geom.line(preserve_order=true)),
        Scale.x_continuous(minvalue = xmin, maxvalue=xmax),
        Scale.y_continuous(minvalue = ymin, maxvalue=ymax),
        Guide.xlabel("Real"),
        Guide.ylabel("Imaginary", orientation=:vertical),
        default_theme)
end

function pzmap_immerse(sys, xmin, xmax, ymin, ymax)
  z, p, k = zpkdata(sys)
  z = z[1]; p = p[1];
  I(x) = (ymin .<= imag(x) .<= ymax) & (xmin .<= real(x) .<= xmax)
  zx = real(z[I(z)])
  zy = imag(z[I(z)])
  px = real(p[I(p)])
  py = imag(p[I(p)])
  shapes = xcross(px, py, fill(3mm,length(px)))
  theme = copy(default_theme)
  theme.default_color = Colors.RGB(0,0,1)
  theme.default_point_size = 6pt
  Immerse.plot(
        layer(x=zx, y=zy, Geom.point),
        x = px,
        y = py,
        Scale.x_continuous(minvalue = xmin, maxvalue=xmax),
        Scale.y_continuous(minvalue = ymin, maxvalue=ymax),
        Guide.xlabel("Real"),
        Guide.ylabel("Imaginary", orientation=:vertical),
        theme,
        Guide.annotation(Compose.compose!(Compose.context(), Gadfly.fill(Colors.RGB(1,0,0)), shapes)))
end

function timeplot_immerse(t, y, ymin, ymax)
  Immerse.plot(
        x = t,
        y = y,
        Scale.y_continuous(minvalue = ymin, maxvalue=ymax),
        Guide.xlabel("Time"),
        Guide.ylabel("Output", orientation=:vertical),
        default_theme,
        Geom.line)
end

function xcross(xs::AbstractArray, ys::AbstractArray, rs::AbstractArray)
  n = max(length(xs), length(ys), length(rs))
  polys = Vector{Vector{Tuple{Measures.Measure, Measures.Measure}}}(n)
  s = 1/sqrt(5)
  for i in 1:n
    x = Compose.x_measure(xs[i])
    y = Compose.y_measure(ys[i])
    r = rs[i]
    u = s*r
    polys[i] = Tuple{Measures.Measure, Measures.Measure}[
      (x, y - u), (x + u, y - 2u), (x + 2u, y - u),
      (x + u, y), (x + 2u, y + u), (x + u, y + 2u),
      (x, y + u), (x - u, y + 2u), (x - 2u, y + u),
      (x - u, y), (x - 2u, y - u), (x - u, y - 2u)
    ]
  end
  return Gadfly.polygon(polys)
end
