From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv5 28/37] x86/vdso: Enable static branches for the timens
 vdso
Date: Thu, 1 Aug 2019 08:48:10 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1908010841500.1788@nanos.tec.linutronix.de>
References: <20190729215758.28405-1-dima@arista.com> <20190729215758.28405-29-dima@arista.com> <CALCETrXL6pzDoHfn9Niw_CxNX-_W3=yotDYuqK+kxPhOLofmNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXL6pzDoHfn9Niw_CxNX-_W3=yotDYuqK+kxPhOLofmNA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Dmitry Safonov <dima@arista.com>, LKML <linux-kernel@vger.kernel.org>, Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Linux Containers <containers@lists.linux-foundation.org>, criu@openvz.org, Linux API <linux-api@vger.kernel.o>
List-Id: linux-api@vger.kernel.org

On Wed, 31 Jul 2019, Andy Lutomirski wrote:
> On Mon, Jul 29, 2019 at 2:58 PM Dmitry Safonov <dima@arista.com> wrote:
> > As it has been discussed on timens RFC, adding a new conditional branch
> > `if (inside_time_ns)` on VDSO for all processes is undesirable.
> >
> > Addressing those problems, there are two versions of VDSO's .so:
> > for host tasks (without any penalty) and for processes inside of time
> > namespace with clk_to_ns() that subtracts offsets from host's time.
> >
> > The timens code in vdso looks like this:
> >
> > if (timens_static_branch_unlikely()) {
> >        clk_to_ns(clk, ts);
> > }
> 
> I'm confused.  Now we effectively have *three* versions: the vDSO
> without timens, and vDSO with timens but with it switched off, and the
> vDSO with timens on.  This seems like too much.

The problem is that if you have a single VDSO, then omce one process joins
a time namespace _ALL_ other processes get an extra conditional with at
least one extra  cache line as a bonus.

This has been discussed at Plumbers last year and the agreement was to
create VDSO plain (no namespace support) and VDSO extra (namespace
support).

The performance hit of the conditional + one etra cache line for tasks
which do not use a time name space is measurable.

That also avoids the whole mess of dealing with the static branch being
flipped. The time name space property is determined on fork/exec _before_
anything can touch the VDSO and depending on it the approriate version of
the VDSO is loaded.

Thanks,

	tglx
