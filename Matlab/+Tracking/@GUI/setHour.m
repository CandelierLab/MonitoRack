function setHour(this, varargin)

DS = DataSource;

year = this.ui.year.String{this.ui.year.Value};
month = this.ui.month.String{this.ui.month.Value};
day = this.ui.day.String{this.ui.day.Value};
hour = this.ui.hour.String{this.ui.hour.Value};

% Update Run
this.Images = IP.Images(year, month, day, hour);