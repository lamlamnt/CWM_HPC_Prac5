n = 6
max = 1.5
min = -1.5
width = (max-min)/n
hist(x,width) = width*floor(x/width)+width/2.0
set term png
set output "histogram.png"
set xrange [min:max]
set yrange[0:]
set offset graph 0.05,0.05,0.05,0.0
set xtics min,(max-min)/5,max
set boxwidth width*0.9
set style fill solid 0.5 #fillstyle
set tics out nomirror
set xlabel "Number"
set ylabel "Frequency"
plot "data.dat" u (hist($1,width))
