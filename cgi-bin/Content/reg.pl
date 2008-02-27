sub reg {
        my $userRegName = param('username');
        $userRegName = ($userRegName =~ /^(\w{3,10})$/) ? $1 : translate('insertname');
        $userRegName = lc $userRegName;
        my $pass = param('password');
        $pass = ($pass =~ /^(\w{3,10})$/) ? $1 : translate('insertpass');
        $pass = lc $pass;
        my $email = param('email');
        print '<div align="center">
	<h1>'
          . translate('register')
          . qq(</h1><form action="$ENV{SCRIPT_NAME}"  method="post"  name="Login" "><label for="username">Name</label><br/><input type="text" name="username"  title="Bitte geben Sie ihren Namen  ein." value="$userRegName" size="20" maxlength="10" alt="Login" align="left"/><br/><label for="email">Email</label><br/><input type="text" name="email" value="$email" size="20" maxlength="200" alt="email" align="left"/><br/><input type="hidden" name="action" value="makeUser"/><br/><input type="submit"  name="submit" value="Registrieren" size="15"  alt="Absenden" align="left"/></form></div>);
}

sub make {
        my $fr          = 0;
        my $fingerprint = param('fingerprint');
        my $userRegName = param('username');
        my $email       = param('email');
        my $imagedir    = $settings->{'cgi'}{'DocumentRoot'} . '/images/';
      SWITCH: {
                if(defined $userRegName) {
                        if($database->isMember($userRegName)) {

                                print translate('userexits');
                                $fr          = 1;
                                $userRegName = undef;
                        }
                } else {
                        print translate('wrongusername');
                        $fr = 1;
                }
                if($database->hasAcount($email)) {
                        print translate('haveacount');
                        $fr          = 1;
                        $userRegName = undef;
                }
                unless (defined $email) {
                        print translate('nomail');
                        $fr = 1;
                }
                &reg()      if($fr);
                last SWITCH if($fr);
                use Mail::Sendmail;
                my $pass = int(rand(1000)+ 1) x 3;
                my %mail = (To => "$email", From => $settings->{'admin'}{'email'}, subject => translate('mailsubject'), Message => translate('regmessage') . translate('username') . ": $userRegName " . translate('password') . ":$pass");
                sendmail(%mail) or warn $Mail::Sendmail::error;
                $database->addUser($userRegName, $pass, $email);
                print translate('mailsendet');
        }
}
1;
