spectrum  <- read.csv("~/Downloads/2022-440512-fixed_tilt.csv")
#all data is from a 90 degree south facing wall

wavelength=c()
#ggplot(oneset,aes(1:601,oneset))+
 # geom_point()

startn = 280.0
for (i in 1:2002){
  wavelength[i] = startn
  if (startn<400){
    startn = startn + 0.5
  } else if (startn<1700) {
      startn = startn + 1.0
  } else if (startn<1702) {
    startn = startn + 2.0
  } else if (startn<1705) {
    startn = startn + 3.0
  } else {
    startn = startn + 5.0
  }
}

integration = function(wavelengths,spectraldata) {
  #returns total intensity in W/m^2
  total = 0
  for (i in 1:(length(wavelengths)-1)) {
    difference = (wavelengths[i+1] - wavelengths[i])/1000
    total = total+ spectraldata[i] * difference
  }
  return (total)
}

spectrumonly = spectrum[,33:2034]
intensities = c()
## super long run time in order to determine day/time in 2022 with highest
## intensity. determined to be row 1268 ie. feb 22, 2022 @ 7pm
#for (n in 1:8760){
#  temp = c()
#  for (i in 1:2002){
#    temp[i] = spectrumonly[n,i]
#  }
#  intensities[n]=integration(wavelength,temp)
#}
##
#which(intensities[]==max(intensities,na.rm=TRUE))
spectrum[1268,1:10]

#oneset = spectrum[5533,33:2034]
oneset = spectrum[1268,33:2034]

intensity = c()
for (i in 1:2002){
  intensity[i] = oneset[,i]
}

newspectrum = data.frame(wavelength,intensity)

ggplot(newspectrum)+
  aes(wavelength,intensity)+
  geom_line()

#filtered to photodiode responsivity
reducedspectrum = newspectrum[341:1552,]

ggplot(reducedspectrum)+
  aes(wavelength,intensity)+
  geom_line()

integration(reducedspectrum$wavelength,reducedspectrum$intensity)

#filtered to 840-860nm bandpass filter
filteredspectrum = newspectrum[681:701,]

ggplot(filteredspectrum)+
  aes(wavelength,intensity)+
  geom_line()

integration(filteredspectrum$wavelength,filteredspectrum$intensity)



##monte carlo ray tracing
N = 1000000 #iterations
D = 50 #m
#PDDim = 0.0003 #m
PDDim = 0.3
radius = 1 #m

x2 = c()
y2 = c()

PDHitCount = 0
for (i in 1:N) {
  ##sample a uniform random point on a circular lambertian reflector
  r = (runif(1)*radius)^(1/2) #distance from center in m (inverse transform fo uniform distribution)
  theta = runif(1)*2*pi-pi #angle for polar coordinate [-pi,pi]
  x = r*cos(theta)
  y = r*sin(theta)
  
  ##sample reflection angles based on lambert's cosine law
  thetax = asin((runif(1)))*sample(c(-1,1),1) #[-pi/2,pi/2]
  thetaradial=runif(1)*2*pi-pi #uniform azimuthal angle [-pi,pi]

  ##determine final photon landing position
  x2[i] = D*tan(thetax)*cos(thetaradial) + x
  y2[i] = D*tan(thetax)*sin(thetaradial) + y
  
  ##determine if photon landed on photodetector
  if (abs(x2[i])<=PDDim && abs(y2[i])<=PDDim) {
    PDHitCount = PDHitCount + 1
  }
  
}
PDHitCount/N

ggplot()+
  aes(x2,y2)+
  geom_point(size=0.5)+
  xlim(-0100,0100)+
  ylim(-0100,0100)

##Cosine weighted distribution visual
test = c()
for (i in 1:10000){
  #test[i]=asin(1-(runif(1)))*sample(c(-1,1),1)
  test[i]=asin(runif(1))*sample(c(-1,1),1)
}
hist(test,breaks=50)







