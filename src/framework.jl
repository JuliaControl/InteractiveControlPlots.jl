null_theme = Theme(
              minor_label_font_size=0pt, #Size of ticks
              major_label_font_size=0pt, #Size of axis text
              line_width=0pt, #Plot line
              panel_fill=Colors.RGB(.95,.95,.95),
              background_color=Colors.RGB(.95,.95,.95)
              )
default_theme = Theme(
              minor_label_font_size=16pt, #Size of ticks
              major_label_font_size=26pt, #Size of axis text
              line_width=5pt, #Plot line
              panel_fill=Colors.RGB(.99,.99,.99),
              background_color=Colors.RGB(.99,.99,.99)
              )

#Almost empty plot
na_plot = Immerse.plot(x=[0.0], y=[0.0], Geom.line, null_theme)

function Base.push!(obj::GtkInteract.CairoGraphic, p::Void)
    push!(obj, na_plot)
end

function Base.push!(obj::GtkInteract.CairoGraphic, p::Gadfly.Plot)
    if obj.obj != nothing
      push!(obj.obj, p)
    end
end

function get_log_ticks(x)
    min = ceil(log10(minimum(x)))
    max = floor(log10(maximum(x)))
    major = 10.^collect(min:max)
    majorText = ["\$10^{$(round(Int64,i))}\$" for i=min:max]
    if length(major) < 7
      minor = [j*10^i for i=(min-1):(max+1) for j=2:9]
      minor = minor[find(minimum(x) .<= minor .<= maximum(x))]
    else
      minor = Float64[]
    end
    if length(major) < 2
      minorText = ["\$j*10^\{$i\}\$" for i=(min-1):(max+1) for j=2:9]
    else
      minorText = fill("", length(minor))
    end
    major, minor, majorText, minorText
end

function labelf(x)
  if abs(round(Int64, x) - x) < 1e-5
    @sprintf("10<sup>%1.0f</sup>", x)
  else
    ""
  end
end

function major_lines(x, y, xticks, yticks)
  layer(
    x=x, y=y,
    yintercept=yticks, xintercept=xticks, Geom.nil,
    Geom.hline, Geom.vline, Theme(line_width=0.2pt, default_color=Colors.RGB(.1,.1,.1))
  )
end
