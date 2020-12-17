function Fr = getFrame(this, t)

Fr = double(this.map.data.Data(t).frame);
Fr = Fr/mean(Fr(:));