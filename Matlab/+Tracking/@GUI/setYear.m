function setYear(this, varargin)

DS = DataSource;

year = this.ui.year.String{this.ui.year.Value};

D = dir([DS.Data year filesep]);
this.ui.month.String = {D(3:end).name};
this.ui.month.Value = 1;