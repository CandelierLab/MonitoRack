function setMonth(this, varargin)

DS = DataSource;

year = this.ui.year.String{this.ui.year.Value};
month = this.ui.month.String{this.ui.month.Value};

D = dir([DS.Data year filesep month filesep]);
this.ui.day.String = {D(3:end).name};
this.ui.day.Value = 1;
