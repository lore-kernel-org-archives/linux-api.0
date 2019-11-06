From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC v2 PATCH] futex: extend set_robust_list to allow 2 locking ABIs at the same time.
Date: Wed, 06 Nov 2019 15:04:17 +0100
Message-ID: <87a799nlsu.fsf@oldenburg2.str.redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
        <87woceslfs.fsf@oldenburg2.str.redhat.com>
        <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
        <87sgn2skm6.fsf@oldenburg2.str.redhat.com>
        <alpine.DEB.2.21.1911051253430.17054@nanos.tec.linutronix.de>
        <f11d82f1-1e81-e344-3ad2-76e4cb488a3d@redhat.com>
        <alpine.DEB.2.21.1911051520090.17054@nanos.tec.linutronix.de>
        <CAKCAbMjYBpTjwyMJkkENps09o4KFoQAb_KOKp4g0BtWUXjYAzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKCAbMjYBpTjwyMJkkENps09o4KFoQAb_KOKp4g0BtWUXjYAzQ@mail.gmail.com>
        (Zack Weinberg's message of "Wed, 6 Nov 2019 09:00:51 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Zack Weinberg <zackw@panix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carlos O'Donell <carlos@redhat.com>, Shawn Landden <shawn@git.icu>, GNU C Library <libc-alpha@sourceware.org>, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

* Zack Weinberg:

> On Tue, Nov 5, 2019 at 9:28 AM Thomas Gleixner <tglx@linutronix.de> wrote=
:
>>
>> The real issue is that the robust list could be circular by incident or
>> malice and there is no way for the kernel to figure that out. That would
>> prevent the task from exiting and make it iterate over the list until
>> doomsday, i.e. a nice unpriviledged DoS.
>
> Why can't the kernel use the standard tortoise-and-hare algorithm for
> detecting circular linked lists here?

It's not guaranteed to terminate if the list is in shared memory.

Thanks,
Florian
