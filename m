From: Dmitry Safonov <0x7f454c46@gmail.com>
Subject: Re: [PATCHv8 00/34] kernel: Introduce Time Namespace
Date: Wed, 11 Dec 2019 20:38:30 +0000
Message-ID: <CAJwJo6ahGVHHgwFsPyjbY1PgmHs+D+A2Cma03ogvQGr+mPqYAw@mail.gmail.com>
References: <20191112012724.250792-1-dima@arista.com> <20191121180555.GA440967@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191121180555.GA440967@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>
Cc: Dmitry Safonov <dima@arista.com>, Andrei Vagin <avagin@gmail.com>, open list <linux-kernel@vger.kernel.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, crml <criu@openvz.org>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

Gentle ping, in case you have time to look at this.

On Thu, 21 Nov 2019 at 18:05, Andrei Vagin <avagin@gmail.com> wrote:
>
> Hi Thomas,
>
> What is your plan on this series? We know you are probably busy with
> the next merge window. We just want to check that this is still in your
> TODO list.
>
> On Tue, Nov 12, 2019 at 01:26:49AM +0000, Dmitry Safonov wrote:
> >
> > v7..v8 Changes:
> > * Fix compile-time errors:
> >   - on architectures without the support of time namespaces.
> >   - when CONFIG_POSIX_TIMERS isn't set.
> > * Added checks in selftests for CONFIG_POSIX_TIMERS.
> > * Inline do_hres and do_coarse.
> >   (And added Tested-by Vincenzo - thanks!)
> > * Make TIME_NS depends on GENERIC_VDSO_TIME_NS and set it per-arch.
> >
> > [v1..v7 Changelogs is at the very bottom here]
> >
> > Our performance measurements show that the price of VDSO's clock_gettime()
> > in a child time namespace is about 8% with a hot CPU cache and about 90%
>
> Here is a typo. The price of VDSO's clock_gettime() in a child time
> namespace is about 12% with a cold CPU cache. The table with
> measurements for a cold CPU cache contains correct data.
>
> > with a cold CPU cache. There is no performance regression for host
> > processes outside time namespace on those tests.
> >
>
> ....
>
> >
> > Cold CPU cache (lesser tsc per cycle - the better):
> >
> >            | before    | CONFIG_TIME_NS=n | host      | inside timens
> > --------------------------------------------------------------
> > tsc        | 476       | 480              | 487       | 531
> > stdev(tsc) | 0.6       | 1.3              | 4.3       | 5.7
> > diff (%)   | 100       | 100.9            | 102       | 112
> >

Thanks,
             Dmitry
