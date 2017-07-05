From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 17:32:59 +0200
Message-ID: <20170705153259.GA7265@kroah.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a462fb3b-a6d4-e969-b301-b404981de224-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 05, 2017 at 08:16:33AM -0700, Guenter Roeck wrote:
> If we start shaming people for not providing unit tests, all we'll accomplish is
> that people will stop providing bug fixes.

Yes, this is the key!

Steven, just look at everything marked with a "Fixes:" or "stable@" tag
from 4.12-rc1..4.12 and try to determine how you would write a test for
the majority of them.

Yes, for some subsystems this can work (look at xfstests as one great
example for filesystems, same for the i915 tests), but for the majority
of the kernel, at this point in time, it doesn't make sense.

So take Carlos's advice, start small, do it for your subsystem if you
don't touch hardware (easy peasy, right?), and let's see how it goes,
and see if we have the infrastructure to do it even today.  Right now,
kselftests is finally getting a unified output format, which is great,
it shows that people are starting to use and rely on it.  What else will
we need to make this more widely used, we don't know yet...

thanks,

greg k-h
