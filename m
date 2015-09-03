From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests: add membarrier syscall test
Date: Thu, 3 Sep 2015 15:47:13 +0000 (UTC)
Message-ID: <1734164155.35899.1441295233847.JavaMail.zimbra@efficios.com>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com> <1436561912-24365-3-git-send-email-mathieu.desnoyers@efficios.com> <1441004040.5735.7.camel@ellerman.id.au> <1071313434.33305.1441127478843.JavaMail.zimbra@efficios.com> <CALCETrWpSErLUES1Wgs5+Ov8F0c-ohUwkSHFMRMZPhx-E4o2cQ@mail.gmail.com> <1441272839.26379.2.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441272839.26379.2.camel-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 3, 2015, at 5:33 AM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:

> On Tue, 2015-09-01 at 11:32 -0700, Andy Lutomirski wrote:
>> On Tue, Sep 1, 2015 at 10:11 AM, Mathieu Desnoyers
>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> > Just to make sure I understand: should we expect that
>> > everyone will issue "make headers_install" on their system
>> > before doing a make kselftest ?
>> >
>> > I see that a few selftests (e.g. memfd) are adding the
>> > source tree include paths to the compiler include paths,
>> > which I guess is to ensure that the kselftest will
>> > work even if the system headers are not up to date.
>> 
>> It would be really nice if there were a clean way for selftests to
>> include the kernel headers.
> 
> What's wrong with make headers_install?
> 
> Or do you mean when writing the tests? That we could fix by adding the
> ../../../../usr/include path to CFLAGS in lib.mk. And fixing all the tests that
> overwrite CFLAGS to append to CFLAGS.
> 
>> Perhaps make should build the exportable headers somewhere as a dependency of
>> kselftests.
> 
> Yeah the top-level kselftest target could do that I think.
> 
> Folks who don't want the headers installed can just run the selftests Makefile
> directly.
> 
> Does this work for you?
> 
> diff --git a/Makefile b/Makefile
> index c361593..c8841d3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1080,7 +1080,7 @@ headers_check: headers_install
> # Kernel selftest
> 
> PHONY += kselftest
> -kselftest:
> +kselftest: headers_install
>        $(Q)$(MAKE) -C tools/testing/selftests run_tests

My personal experience is that make headers_install
does not necessarily play well with the distribution
header file hierarchy, which requires some tweaks
to be done by the users (e.g. asm vs x86_64-linux-gnu).
Also, headers_install typically expects a INSTALL_HDR_PATH.
It would be interesting if we could install the kernel
headers into a specific location that is then re-used by
kselftest, so using it without too much manual configuration
does not require to overwrite the distribution header files
to run tests.

Thoughts ?

Thanks,

Mathieu

> 
> # ---------------------------------------------------------------------------
> 
> cheers

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
