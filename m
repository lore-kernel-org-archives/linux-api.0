From: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Wed, 08 Mar 2017 19:18:31 +0100
Message-ID: <1488997111.5155.10.camel@quad>
References: <1488897868.5178.3.camel@quad>
         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f7f9f60b-0f39-7dce-1778-3aa40ba198ef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2017-03-08 at 12:54 -0500, Carlos O'Donell wrote:
> The most demanding application I've ever seen when playing with this is the
> compiler because it has to pass some very large strings from the driver
> to a subprocess. So much so that we have `@file` to use intermediate file
> storage to workaround kernel limits on various operating systems.

So a value that would satisfy glibc would suffice. Any problem with that
limit of 4096 arguments? The size of each individual argument is still
the old limit of 128KiB.

By the way, my kernel build example seems to already catch your
scenario. Kernel build uses a compiler.

> In glibc we limit setuid applications, for example sanitizing their
> environment where it would cause problems or alter behaviour in 
> unintended ways.
> 
> Can we avoid imposing a limit on all applications?

Not imposing a limit - btw, 0x7FFFFFFF *is* a limit albeit a ridiculous
and dangerously large limit - is a bad idea, because it allows the
aforementioned "heap-spraying" which is a serious attack vector.

Note that 128KiB * 4096 arguments still adds up to 512MiB!!!

If you don't feel the limit of 4096 arguments is sufficient please
provide us with an example where that limit is insufficient.

Regards,
Leonard.

-- 
mount -t life -o ro /dev/dna /genetic/research
