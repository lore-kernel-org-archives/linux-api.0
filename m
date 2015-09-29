From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] kselftest: replace $(RM) with rm -f command
Date: Tue, 29 Sep 2015 10:45:33 -0700
Message-ID: <CAGXu5jKqiKcTAp5GdL02O2hxA7mEqyhGKyEqEJ1afFXyLtCVvw@mail.gmail.com>
References: <20150925154415.GC38748@vmdeb7>
	<1443406217-137773-1-git-send-email-long.wanglong@huawei.com>
	<1201012824.5792.1443410213729.JavaMail.zimbra@efficios.com>
	<1443520665.11041.1.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443520665.11041.1.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Wang Long <long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, bobby prani <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tyler baker <tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Tim Bird <tim.bird-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, andrej skvortzov <andrej.skvortzov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, sjayaram-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, naresh kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, alexey kodanev <alexey.kodanev-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, wanglong-m92B/FuLcaEcWVvVuXF20w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Sep 29, 2015 at 2:57 AM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> On Mon, 2015-09-28 at 03:16 +0000, Mathieu Desnoyers wrote:
>> ----- On Sep 27, 2015, at 10:10 PM, Wang Long long.wanglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org wrote:
>>
>> > Some test's Makefile using "$(RM)" while the other's
>> > using "rm -f". It is better to use one of them in all
>> > tests.
>>
>> I agree that this disparity appears to be unwanted. We
>> should settle on one or the other.
>>
>> > "rm -f" is better, because it is less magic, and everyone
>> > konws what is does.
>>
>> "$(RM)" is clearly defined as a Makefile implicit variable
>> which defaults to "rm -f".
>> Ref. https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
>
> Sure, but you had to look it up didn't you :) - I did.
>
>> Leaving it as a variable is more flexible because then the
>> default behavior can be overridden if need be, which is
>> not the case of a hardcoded "rm -f".
>
> But I don't think anyone actually wants to do that. Do they?
>
> Anyway I don't really care either way, so I'm happy for you to do a patch that
> uses $(RM). Or maybe Wang Long will be happy to respin his patch to use $(RM).

Yes, please. $(RM) is preferred, as that is the existing standard and
gives us flexibility.

-Kees

-- 
Kees Cook
Chrome OS Security
