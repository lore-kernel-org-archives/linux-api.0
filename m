From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] kselftest: replace $(RM) with rm -f command
Date: Fri, 2 Oct 2015 21:38:08 -0700
Message-ID: <20151003043808.GA90454@vmdeb7>
References: <20150925154415.GC38748@vmdeb7>
 <1443406217-137773-1-git-send-email-long.wanglong@huawei.com>
 <1201012824.5792.1443410213729.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1201012824.5792.1443410213729.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, bobby prani <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tyler baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, andrej skvortzov <andrej.skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, naresh kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, alexey kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wanglong-m92B/FuLcaEcWVvVuXF20w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 28, 2015 at 03:16:53AM +0000, Mathieu Desnoyers wrote:
> ----- On Sep 27, 2015, at 10:10 PM, Wang Long long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:
> 
> > Some test's Makefile using "$(RM)" while the other's
> > using "rm -f". It is better to use one of them in all
> > tests.
> 
> I agree that this disparity appears to be unwanted. We
> should settle on one or the other.
> 
> > 
> > "rm -f" is better, because it is less magic, and everyone
> > konws what is does.
> 
> "$(RM)" is clearly defined as a Makefile implicit variable
> which defaults to "rm -f".
> Ref. https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
> 
> Leaving it as a variable is more flexible because then the
> default behavior can be overridden if need be, which is
> not the case of a hardcoded "rm -f".
> 
> Following your line of argumentation, we should then
> invoke "gcc" directly in every Makefile because it is
> less magic than "$(CC)". This makes no sense.

I don't think they can be compared so simply. Specifying a compiler is a common
use case. Customizing the rm command is not, in my experience anyway, and like
Michael, I would definately have to look up what RM means.

That said, I care more about consistency than which is used. Both are valid, but
$(RM), while more flexible, will cost more people time to look up what it does
as it isn't commonly used than any benefit we're likely to see from its use.

Meh. :-)

-- 
Darren Hart
Intel Open Source Technology Center
