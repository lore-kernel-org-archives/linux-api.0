From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC v2 PATCH] futex: extend set_robust_list to allow 2 locking ABIs at the same time.
Date: Tue, 05 Nov 2019 15:33:38 +0100
Message-ID: <87k18eqtod.fsf@oldenburg2.str.redhat.com>
References: <20191104002909.25783-1-shawn@git.icu>
        <87woceslfs.fsf@oldenburg2.str.redhat.com>
        <alpine.DEB.2.21.1911051053470.17054@nanos.tec.linutronix.de>
        <87sgn2skm6.fsf@oldenburg2.str.redhat.com>
        <alpine.DEB.2.21.1911051253430.17054@nanos.tec.linutronix.de>
        <f11d82f1-1e81-e344-3ad2-76e4cb488a3d@redhat.com>
        <alpine.DEB.2.21.1911051520090.17054@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911051520090.17054@nanos.tec.linutronix.de>
        (Thomas Gleixner's message of "Tue, 5 Nov 2019 15:27:54 +0100 (CET)")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Carlos O'Donell <carlos@redhat.com>, Shawn Landden <shawn@git.icu>, libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

* Thomas Gleixner:

> On Tue, 5 Nov 2019, Carlos O'Donell wrote:
>> On 11/5/19 6:56 AM, Thomas Gleixner wrote:
>> The other issue is this:
>>=20
>> "Robust mutexes do not take ROBUST_LIST_LIMIT into account"
>> https://sourceware.org/bugzilla/show_bug.cgi?id=3D19089
>
>   "The kernel limits the length of the robust mutex list to 2048 entries.
>    This constant does not seem to be exported to user space."
>
> FWIW, the constant is defined in the UAPI futex header.
>
> The main concern here is not the actual number of futexes held by a task.
>
> The real issue is that the robust list could be circular by incident or
> malice and there is no way for the kernel to figure that out. That would
> prevent the task from exiting and make it iterate over the list until
> doomsday, i.e. a nice unpriviledged DoS.
>
> So I fear the kernel cannot really help with this one.

I'm actually fine with treating ROBUST_LIST_LIMIT as an ABI constant.
It's just not clear to me if the constant has this status today.  I
suspect it was just split from the implementation headers at one point.

Thanks,
Florian
