From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 10:28:30 -0400
Message-ID: <6401b327-cc2c-5e0a-716b-0b9ea70adcb0@redhat.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705140607.GA30187-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/05/2017 10:06 AM, Greg KH wrote:
> I don't mean to poo-poo the idea, but please realize that around 75% of
> the kernel is hardware/arch support, so that means that 75% of the
> changes/fixes deal with hardware things (yes, change is in direct
> correlation to size of the codebase in the tree, strange but true).

We should distinguish between the reviewer reviewing the regression test
and running the regression test. As long as the submitter ran the 
regression test on their hardware, and it passed, the reviewer need only
review the test for logical consistency and correctness?

Lack of test infrastructure was a serious problem for us in glibc. We are
relying on namespaces for more complex network and filesystem testing.
Without namespaces we would have needed a much more complex setup that
might never have seen developer adoption. When I attended LPC 2016 I
prioritized listening in on namespaces discussions to make sure nothing
was changing that might break our testing framework.

This conversation is going to lead down the path of driver HAL or
emulation in order to provide regression testing for code above the actual
hardware, and that's another hard problem, but one need not go there.

Starting with real hardware tests can have benefit.

In glibc we test SSE, AVX, AVX512, TSX etc. but if you don't have the
extensions you get a bunch of UNSUPPORTED tests. While upstream kernel 
may have a more limited set of available hardware per-person, the
collective set of developers has hardware to cover all configurations,
and they should run the regression tests for hardware they care about
... and *must* do so if they submit a patch to fix a bug! :-)

-- 
Cheers,
Carlos.
