#!/usr/bin/perl -I /cygdrive/c/cygwin/home/jbaucom/.cpan/build/ObjectivePerl-0.04-1bEpCb/
use ObjectivePerl;
@implementation BaseClass
{
 @private: $private;
 @protected: $protected;
}

- protectedValue { return $protected; }

- setProtectedValue: $value { $protected = $value; }

- privateValue { return $private; }

- setPrivateValue:$value { $private = $value; } @end

BaseClass

- dumpProtectedValue { print $protected."\n"; }

- dumpPrivateValue { print ~[$self privateValue]."\n"; }

@end 
