ubuntu  字体渲染

sudo add-apt-repository ppa:no1wantdthisname/ppa

sudo apt-get update

再到.profile中设置

export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=1 autofitter:warping=1 pcf:no-long-family-names=1" 
