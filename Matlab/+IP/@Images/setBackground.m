function setBackground(this)

this.Bkg = IP.Detection.(this.Proc.IP.name).background(this.map.data, 'step', 100, 'number', 10, 'verbose', true);