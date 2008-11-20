From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [patch 05/35] reintroduce accept4
Date: Thu, 20 Nov 2008 17:41:04 -0500
Message-ID: <cfd18e0f0811201441i3801ad3blb9f142a7a0381634@mail.gmail.com>
References: <200811192336.mAJNaE3R030021@imap1.linux-foundation.org>
	 <Pine.LNX.4.64.0811202259360.12975@anakin>
	 <alpine.LFD.2.00.0811201412040.21698@nehalem.linux-foundation.org>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0811201412040.21698-nfNrOhbfy2R17+2ddN/4kux8cNe9sq/dYPYVAmT7z5s@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2008 at 5:14 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
>
> On Thu, 20 Nov 2008, Geert Uytterhoeven wrote:
>
>> On Wed, 19 Nov 2008, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
>> > From: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>> > Introduce a new accept4() system call.  The addition of this system call
>>
>> > /* test_accept4.c
>>
>> > #ifdef __x86_64__
>> > #define SYS_accept4 288
>> > #elif __i386__
>>         ^^^^^^^^
>>       defined(__i386__)

Whoops.

>> > #define USE_SOCKETCALL 1
>> > #define SYS_ACCEPT4 18
>> > #else
>> > #error "Sorry -- don't know the syscall # on this architecture"
>> > #endif
>>
>> Anyway, it's just a test program. Succeeded on m68k using socketcall.
>
> It _should_ work even without the 'defined()'. Didn't it?

It did.  I successfully used it for testing on i386.

> Unknown symbols should expand to '0' in preprocessor value evaluation. Of
> course, the compiler may warn about the practice, but it shouldn't be
> technically wrong.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
