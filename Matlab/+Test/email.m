% parameters
mail = 'danionella.translucida@gmail.com';
password = 'Da@LJP@SU';
host = 'smtp.gmail.com';
sendto = 'raphael.candelier.ljp@gmail.com';
Subject = '[MonitoRack] Test';
Message = 'Ceci est un message de test.';

% preferences
setpref('Internet','SMTP_Server', host);
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% execute
sendmail(sendto,Subject,Message)