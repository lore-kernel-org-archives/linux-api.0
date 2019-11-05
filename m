From: Carlos O'Donell <carlos@redhat.com>
Subject: Re: [RFC v2 PATCH] futex: extend set_robust_list to allow 2 locking
 ABIs at the same time.
Date: Tue, 5 Nov 2019 09:10:38 -0500
Message-ID: <f11d82f1-1e81-e344-3ad2-76e4cb488a3d@redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
 <87woceslfs.fsf@oldenburg2.str.redhat.com>
 <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
 <87sgn2skm6.fsf@oldenburg2.str.redhat.com>
 <alpine.DEB.2.21.1911051253430.17054@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911051253430.17054@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Florian Weimer <fweimer@redhat.com>
Cc: Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

On 11/5/19 6:56 AM, Thomas Gleixner wrote:
> On Tue, 5 Nov 2019, Florian Weimer wrote:
>> * Thomas Gleixner:
>>> On Tue, 5 Nov 2019, Florian Weimer wrote:
>>>> * Shawn Landden:
>>>>> If this new ABI is used, then bit 1 of the *next pointer of the
>>>>> user-space robust_list indicates that the futex_offset2 value should
>>>>> be used in place of the existing futex_offset.
>>>>
>>>> The futex interface currently has some races which can only be fixed by
>>>> API changes.  I'm concerned that we sacrifice the last bit for some
>>>> rather obscure feature.  What if we need that bit for fixing the
>>>> correctness issues?
>>>
>>> That current approach is going nowhere and if we change the ABI ever then
>>> this needs to happen with all *libc folks involved and agreeing.
>>>
>>> Out of curiosity, what's the race issue vs. robust list which you are
>>> trying to solve?
>>
>> Sadly I'm not trying to solve them.  Here's one of the issues:
>>
>>   <https://sourceware.org/bugzilla/show_bug.cgi?id=14485>
> 
> That one seems more a life time problem, i.e. the mutex is destroyed,
> memory freed and map address reused while another thread was not yet out of
> the mutex_unlock() call. Nasty.

It is difficult to fix.

The other issue is this:

"Robust mutexes do not take ROBUST_LIST_LIMIT into account"
https://sourceware.org/bugzilla/show_bug.cgi?id=19089

-- 
Cheers,
Carlos.
