function [pos, Res] = processFrame(this, t)

[pos, Res] = IP.Detection.(this.Proc.IP.name).process(this.getFrame(t), this.Bkg);
