From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 20:42:45 +0200
Message-ID: <20170705184245.GA22044@kroah.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
 <20170705153259.GA7265@kroah.com>
 <20170705115219.02370220@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170705115219.02370220-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 05, 2017 at 11:52:19AM -0400, Steven Rostedt wrote:
> > So take Carlos's advice, start small, do it for your subsystem if you
> 
> Yes, lets start small. What do you think about all reproducers getting
> into selftests? If it's not 100% reproducing, then it's up to the
> individual, but any test that can trigger a bug 100% should be added.

That would be great.  One could argue that we should be adding the
"stack guard" testing apps to the selftest tree now, as a number of us
have them floating around in their test directories at the moment.

> I'd like to expand selftests to include configs too. If there's a
> config that triggers a bug, that should be added to a list of "configs"
> to be tested as well.

So a test needs a specific configuration?  We need a way to specify that
in a generic fashion so that all tests don't have to duplicate that
logic.  Time to write a helper function to parse /proc/config.gz :)

thanks,

greg k-h
