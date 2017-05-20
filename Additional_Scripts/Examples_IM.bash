#CONVERT ALL DATA
#egrep to filter out earlier converts!
for filename in $(ls | egrep -v "CONVERT")
do
convert ${filename} -fuzz 50% -fill Green -opaque 'rgb(0, 255, 0)' - |
convert - -crop 4000x2848+0+0 - | convert - -crop 0x0+1400+0  CONVERT_${filename}  
done
beep


for filename in $(ls | egrep -v "CONVERT")
do
convert ${filename} -fuzz 40% -fill Green -opaque 'rgb(0, 255, 0)' - |
convert - -crop 4000x2848+0+0 - | convert - -crop 0x0+1400+0  - |
convert - -fuzz 10% -fill Green -opaque Black CONVERT_${filename}  
done


convert Naturalis_1_2.png -fuzz 50% -fill Green -opaque 'rgb(255, 255, 255)' - | convert - -fuzz 20% -fill Blue -opaque 'rgb(0, 0, 0)' Naturalis_1_2_Blue_Green.png
convert Naturalis_1_2.png -fuzz 20% -fill Blue -opaque 'rgb(0, 0, 0)' Naturalis_1_2_Blue_white.png


for filename in $(ls | egrep -v "CONVERT")
do
convert ${filename} -fuzz 35% -fill Red -opaque 'rgb(255, 0, 0)' - |
convert - -fuzz 12% -fill Red -opaque 'rgb(58, 156, 95)' - |
convert - -fuzz 15% -fill Black -opaque 'rgb(37, 132, 188)' CONVERT_${filename}  
done


for filename in $(ls | egrep -v "CONVERT")
do
convert ${filename} -fuzz 35% -fill Red -opaque 'rgb(255, 0, 0)' - |

convert - -fuzz 5% -fill Black -opaque 'rgb(37, 132, 188)' CONVERT_${filename}  
done

# Duke scale slechte scalebars Round 1
# 1: background to red
# 2: Green-ish of scalebar to red
# 3: Blue of scalebar to black
# 4: Green-sh to red
# 5: Green-ish to red
# 6: pink-red to red
# 7: More green-ish to red
# 8: White green to red
for filename in $(ls | egrep -v "CONVERT")
do
convert ${filename} -fuzz 35% -fill Red -opaque 'rgb(255, 0, 0)' - |
convert - -fuzz 12% -fill Red -opaque 'rgb(58, 156, 95)' - |
convert - -fuzz 15% -fill Black -opaque 'rgb(37, 132, 188)' - |
convert - -fuzz 5% -fill Red -opaque 'rgb(136, 206, 176)' - |
convert - -fuzz 5% -fill Red -opaque 'rgb(140, 210, 176)' - |
convert - -fuzz 5% -fill Red -opaque 'rgb(233, 122, 115)' - |
convert - -fuzz 5% -fill Red -opaque 'rgb(97, 188, 144)' - |
convert - -fuxx 5% -fill Red -opaque 'rgb(180, 232, 210)' CONVERT_${filename}  
done