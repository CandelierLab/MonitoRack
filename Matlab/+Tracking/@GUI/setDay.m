function setDay(this, varargin)

DS = DataSource;

year = this.ui.year.String{this.ui.year.Value};
month = this.ui.month.String{this.ui.month.Value};
day = this.ui.day.String{this.ui.day.Value};

D = dir([DS.Data year filesep month filesep day filesep 'video_*']);
this.ui.hour.String = cellfun(@(x) x(7:8), {D(:).name}, 'UniformOutput', false);
this.ui.hour.Value = 1;