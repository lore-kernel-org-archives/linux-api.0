From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH v4 0/2] make sigaltstack() compatible with swapcontext()
Date: Sun, 6 Mar 2016 23:27:26 +0300
Message-ID: <56DC92AE.3070707@list.ru>
References: <1456781345-8243-1-git-send-email-stsp@list.ru>
 <20160306200207.GT29662@port70.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160306200207.GT29662-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Szabolcs Nagy <nsz-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

06.03.2016 23:02, Szabolcs Nagy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> * Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> [2016-03-01 00:29:03 +0300]:
>> The following patches make it possible to use swapcontext()
>> in a sighandler that works on sigaltstack.
> i don't think that's possible, the (obsolete) userspace
> *context functions cannot operate on kernel provided
> ucontext_t structs,
It doesn't have to.
It does the normal getcontext()/swapcontext() sequences,
as if it would be switching from any casual code place.
Kernel-provided context structs are completely irrelevant.
=46or more details please see the test-case I posted in that patch seri=
es.
It shows what can be done and how.

>   so they are not usable in signal
> handlers.
Please note the fact that swapcontext() also replaces the
signal mask as part of the context switching. This is a very
strong hint that it was intended to work with signal handlers.
And in fact it perfectly does.
What I want is only to make it friendly to sigaltstack.
I am not making it friendly to signal handlers in general,
because it already is.

> at least not on most target archs.
>
> so i don't understand how the tests can work portably.
If you apply my patch series, you can immediately test
it on any arch you want, thanks to the test-case my patch
adds to the kernel. Please let me know on what arch it fails.
