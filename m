From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC v2 PATCH] futex: extend set_robust_list to allow 2 locking ABIs at the same time.
Date: Tue, 05 Nov 2019 11:06:25 +0100
Message-ID: <87sgn2skm6.fsf@oldenburg2.str.redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
        <87woceslfs.fsf@oldenburg2.str.redhat.com>
        <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
        (Thomas Gleixner's message of "Tue, 5 Nov 2019 10:59:24 +0100 (CET)")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

* Thomas Gleixner:

> On Tue, 5 Nov 2019, Florian Weimer wrote:
>> * Shawn Landden:
>> > If this new ABI is used, then bit 1 of the *next pointer of the
>> > user-space robust_list indicates that the futex_offset2 value should
>> > be used in place of the existing futex_offset.
>>=20
>> The futex interface currently has some races which can only be fixed by
>> API changes.  I'm concerned that we sacrifice the last bit for some
>> rather obscure feature.  What if we need that bit for fixing the
>> correctness issues?
>
> That current approach is going nowhere and if we change the ABI ever then
> this needs to happen with all *libc folks involved and agreeing.
>
> Out of curiosity, what's the race issue vs. robust list which you are
> trying to solve?

Sadly I'm not trying to solve them.  Here's one of the issues:

  <https://sourceware.org/bugzilla/show_bug.cgi?id=3D14485>

I think there are others, but I can't find a reference to them.  If
anyone wants to work on this, I can dig out the details and ask some
folks who have looked at this in the past.

Thanks,
Florian
