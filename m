From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 17/23] y2038: time: avoid timespec usage in settimeofday()
Date: Fri, 15 Nov 2019 11:27:41 +0100
Message-ID: <73a56955-552a-3a95-a410-3064401913f7@rasmusvillemoes.dk>
References: <20191108210236.1296047-1-arnd@arndb.de>
 <20191108211323.1806194-8-arnd@arndb.de> <20191114230127.GA3580@ryzen.lan>
 <CAK8P3a3jn8GcedX=HaTFiPY+fyHPoyVUnpcX19nMZqmuUA1RzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a3jn8GcedX=HaTFiPY+fyHPoyVUnpcX19nMZqmuUA1RzA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Abel Vesa <abelvesa@linux.com>
Cc: y2038 Mailman List <y2038@lists.linaro.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Deepa Dinamani <deepa.kernel@gmail.com>, Christian Brauner <christian@brauner.io>, Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>, Corey Minyard <cminyard@mvista.com>, zhengbin <zhengbin13@huawei.com>, Li RongQing <lirongqing@baidu.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 15/11/2019 08.58, Arnd Bergmann wrote:
> On Fri, Nov 15, 2019 at 12:01 AM Abel Vesa <abelvesa@linux.com> wrote:
>>
>> On 19-11-08 22:12:16, Arnd Bergmann wrote:
>>> The compat_get_timeval() and timeval_valid() interfaces
>>> are deprecated and getting removed along with the definition
>>> of struct timeval itself.
>>>
>>> Change the two implementations of the settimeofday()
>>> system call to open-code these helpers and completely
>>> avoid references to timeval.
>>>
> 
> I'm not sure how we get to the RCU stall, but this is almost certainly another
> symptom of a typo I had introduced in the patch, which others have also
> reported. This is the the fix in today's linux-next:
> 
> --- a/kernel/time/time.c
> +++ b/kernel/time/time.c
> @@ -207,7 +207,7 @@ SYSCALL_DEFINE2(settimeofday, struct
> __kernel_old_timeval __user *, tv,
>                     get_user(new_ts.tv_nsec, &tv->tv_usec))
>                         return -EFAULT;
> 
> -               if (tv->tv_usec > USEC_PER_SEC)
> +               if (new_ts->tv_usec > USEC_PER_SEC)
>                         return -EINVAL;

Hopefully not :)

>                 new_ts.tv_nsec *= NSEC_PER_USEC;

So the actual patch in next-20191115 does

-               if (copy_from_user(&user_tv, tv, sizeof(*tv)))
+               if (get_user(new_ts.tv_sec, &tv->tv_sec) ||
+                   get_user(new_ts.tv_nsec, &tv->tv_usec))
                        return -EFAULT;

-               if (!timeval_valid(&user_tv))
+               if (new_ts.tv_nsec > USEC_PER_SEC)
                        return -EINVAL;

-               new_ts.tv_sec = user_tv.tv_sec;
-               new_ts.tv_nsec = user_tv.tv_usec * NSEC_PER_USEC;
+               new_ts.tv_nsec *= NSEC_PER_USEC;

But removing the "user value is < 0" check, relying on the timespec
value being rejected later, is wrong: 1000=8*125. Multiplying by 8
always gives a value with the low three bits clear, multiplying by 125
is reversible. So you can take any target value with the three low bits
clear, logic shift right by 3, multiply by 0x1cac083126e978d5 , and flip
the top three bits as you wish to generate 8 pre-images of that target
value. Four of those will be negative. A trivial example is 0x80..000
(aka LONG_MIN) and its cousins 0xa0..000, 0xc0..000, 0xe0..000 which all
become 0 and thus accepted after multiplying by NSEC_PER_USEC. But also
-858989233 (or -3689348814741906097 if long is 64 bit) become 4226200
which isn't even a multiple of 1000 - there's 500M examples to choose
from :)

I'm pretty sure it doesn't generate worse code, gcc is smart enough to
compile "foo > BAR || foo < 0" as if it was written "(unsigned version
of foo)foo > BAR". And while a value of USEC_PER_SEC itself will not
overflow and then be rejeted because the real comparison done later is
">= NSEC_PER_SEC", I think it's clearer to say "foo >= USEC_PER_SEC ||
foo < 0) just so the same pattern is used.

Rasmus
