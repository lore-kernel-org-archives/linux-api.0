From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 11:27:07 -0400
Message-ID: <20170705112707.54d7f345@gandalf.local.home>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
        <20170703123025.7479702e@gandalf.local.home>
        <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
        <20170705084528.67499f8c@gandalf.local.home>
        <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
        <20170705092757.63dc2328@gandalf.local.home>
        <20170705140607.GA30187@kroah.com>
        <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a462fb3b-a6d4-e969-b301-b404981de224-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 5 Jul 2017 08:16:33 -0700
Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org> wrote:

> The reproducers for several of the usb fixes I submitted recently took hours of
> stress test to reproduce the underlying problems. I have one more to fix which
> takes days to reproduce, if at all (I have seen that problem only two or three
> times during weeks of stress test). Due to the nature of the problems, reproducing
> them heavily depended on the underlying hardware. None of the reproducers can
> guarantee that the problem is fixed; they are intended to show the problem,
> not that it is fixed. This happens a lot with race conditions - in many cases
> it is impossible to prove that the problem is fixed; one can only prove that
> it still exists.
> 
> Echoing what you said, I have no idea how it would even be possible to write
> unit tests to verify if the problems I fixed are really fixed.
> 
> Several of the fixes I have submitted are based on single-instance error logs with
> no reproducer. Many others are compile time fixes or fix problems found with code
> inspection (manual or automatic).
> 
> If we start shaming people for not providing unit tests, all we'll accomplish is
> that people will stop providing bug fixes.

I need to be clearer on this. What I meant was, if there's a bug
where someone has a test that easily reproduces the bug, then if
there's not a test added to selftests for said bug, then we should
shame those into doing so.

A bug that is found by inspection or hard to reproduce test cases are
not applicable, as they don't have tests that can show a regression.

And I'm betting that those bugs are NOT REGRESSIONS! Most likely are
bugs that always existed, but because of the unpredictable hitting of
the bug (as you said, it required hours of stress tests to reproduce),
the bug was not previously hit during development. That's not a
regression, that's a feature.

Are we tracking regressions or just simply bugs?

-- Steve
