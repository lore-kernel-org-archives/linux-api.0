From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] kselftest: replace $(RM) with rm -f command
Date: Tue, 29 Sep 2015 19:57:45 +1000
Message-ID: <1443520665.11041.1.camel@ellerman.id.au>
References: <20150925154415.GC38748@vmdeb7>
	 <1443406217-137773-1-git-send-email-long.wanglong@huawei.com>
	 <1201012824.5792.1443410213729.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1201012824.5792.1443410213729.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, bobby prani <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tyler baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, andrej skvortzov <andrej.skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, naresh kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, alexey kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wanglong-m92B/FuLcaEcWVvVuXF20w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-09-28 at 03:16 +0000, Mathieu Desnoyers wrote:
> ----- On Sep 27, 2015, at 10:10 PM, Wang Long long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:
> 
> > Some test's Makefile using "$(RM)" while the other's
> > using "rm -f". It is better to use one of them in all
> > tests.
> 
> I agree that this disparity appears to be unwanted. We
> should settle on one or the other.
> 
> > "rm -f" is better, because it is less magic, and everyone
> > konws what is does.
> 
> "$(RM)" is clearly defined as a Makefile implicit variable
> which defaults to "rm -f".
> Ref. https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html

Sure, but you had to look it up didn't you :) - I did.

> Leaving it as a variable is more flexible because then the
> default behavior can be overridden if need be, which is
> not the case of a hardcoded "rm -f".

But I don't think anyone actually wants to do that. Do they?

Anyway I don't really care either way, so I'm happy for you to do a patch that
uses $(RM). Or maybe Wang Long will be happy to respin his patch to use $(RM).

cheers
