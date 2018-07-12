From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 7/7] timex: change syscalls to use struct __kernel_timex
Date: Thu, 12 Jul 2018 16:40:42 +0200
Message-ID: <CAK8P3a0CHHTg+ccQc1VViRW8pmd7Rx+BsnGX8FWDQd3CK1BY1g@mail.gmail.com>
References: <20180707054247.19802-1-deepa.kernel@gmail.com>
 <20180707054247.19802-8-deepa.kernel@gmail.com> <20180712082956.GD8802@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712082956.GD8802@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Deepa Dinamani <deepa.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 12, 2018 at 10:29 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jul 06, 2018 at 10:42:47PM -0700, Deepa Dinamani wrote:
>
>> -#ifdef CONFIG_COMPAT
>> -
>>  COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
>>                      struct compat_timex __user *, utp)
>>  {
>> @@ -1187,10 +1183,6 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, clockid_t, which_clock,
>>       return err;
>>  }
>>
>> -#endif
>
> And this unconditionally defines clock_adjtime, but doesn't actually
> seem to add callers, which looks rather odd.  Same for other bits
> in the patch.

It really just moves compat_sys_clock_adjtime() into the same
#ifdef CONFIG_COMPAT_32BIT_TIME that hides the surrounding
functions.

Currently CONFIG_COMPAT_32BIT_TIME is used only as a subset
of CONFIG_COMPAT, and the plan was to have 32-bit architectures
enable it later so they could get access to all the functions
implementing 32-bit time with a patch similar to what I'm testing
with, see https://pastebin.com/F3QZdyin for the current draft that
I use for testing.

We already spent several review rounds coming just discussing the
naming of the macros etc before we decided on the
CONFIG_64BIT_TIME and CONFIG_COMPAT_32BIT_TIME
symbol, but if you have a better suggestion (as part of moving
away from the compat_ naming), we can change all that again.

      Arnd
