From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 11:52:19 -0400
Message-ID: <20170705115219.02370220@gandalf.local.home>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
        <20170703123025.7479702e@gandalf.local.home>
        <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
        <20170705084528.67499f8c@gandalf.local.home>
        <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
        <20170705092757.63dc2328@gandalf.local.home>
        <20170705140607.GA30187@kroah.com>
        <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
        <20170705153259.GA7265@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705153259.GA7265-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 5 Jul 2017 17:32:59 +0200
Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Jul 05, 2017 at 08:16:33AM -0700, Guenter Roeck wrote:
> > If we start shaming people for not providing unit tests, all we'll accomplish is
> > that people will stop providing bug fixes.  
> 
> Yes, this is the key!

And I mentioned this in my initial email.

> 
> Steven, just look at everything marked with a "Fixes:" or "stable@" tag
> from 4.12-rc1..4.12 and try to determine how you would write a test for
> the majority of them.

It only makes sense if there's a reproducible case. For cases where
stress testing is required and you hope to hit the bug, well, that's
never an easy answer, and this is not something that will fix it.

> 
> Yes, for some subsystems this can work (look at xfstests as one great
> example for filesystems, same for the i915 tests), but for the majority
> of the kernel, at this point in time, it doesn't make sense.

I already do. Actually, I have just fixed a bug that I need to add a
selftest for. Yes, it is easier for non hardware, but for cases which
has specs on hardware behavior, why can't we have tests to test if the
hardware matches the spec?

Everyone is focusing on that "shaming" comment and not looking at the
rest of what I wrote. My main point is, there's a lot of reproducers in
change logs or emails that are not in selftests. There's no excuse for
that. Lets fix that issue, and not go into a bike shedding fight about
the entire approach.

> 
> So take Carlos's advice, start small, do it for your subsystem if you

Yes, lets start small. What do you think about all reproducers getting
into selftests? If it's not 100% reproducing, then it's up to the
individual, but any test that can trigger a bug 100% should be added.

I'd like to expand selftests to include configs too. If there's a
config that triggers a bug, that should be added to a list of "configs"
to be tested as well.

> don't touch hardware (easy peasy, right?), and let's see how it goes,
> and see if we have the infrastructure to do it even today.  Right now,
> kselftests is finally getting a unified output format, which is great,
> it shows that people are starting to use and rely on it.  What else will
> we need to make this more widely used, we don't know yet...

I've been using selftests for ftrace for some time. I have my own tests
that I run (which do test any config that has failed me in the past),
and I'm slowing getting those into the selftests directory as well.

-- Steve
