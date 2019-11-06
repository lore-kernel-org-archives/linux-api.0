From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] syscalls: Fix references to filenames containing
 syscall defs
Date: Wed, 6 Nov 2019 18:02:41 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911061755060.1869@nanos.tec.linutronix.de>
References: <20191105022928.517526-1-farnasirim@gmail.com> <alpine.DEB.2.21.1911051033050.17054@nanos.tec.linutronix.de> <CAK8P3a0wyw=CwhiU34t1zBiSesf+HGBLeaV+=JVko_TjnvATHQ@mail.gmail.com> <20191106164756.GA558585@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191106164756.GA558585@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mohammad Nasirifar <far.nasiri.m@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Mohammad Nasirifar <farnasirim@gmail.com>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Valdis Kletnieks <valdis.kletnieks@vt.edu>
List-Id: linux-api@vger.kernel.org

On Wed, 6 Nov 2019, Mohammad Nasirifar wrote:

> On Tue, Nov 05, 2019 at 10:49:12AM +0100, Arnd Bergmann wrote:
> > On Tue, Nov 5, 2019 at 10:34 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > > On Mon, 4 Nov 2019, Mohammad Nasirifar wrote:
> > > > Fix stale references to files containing syscall definitions in
> > > > 'include/linux/syscalls.h' and 'include/uapi/asm-generic/unistd.h',
> > > > pointing to 'kernel/itimer.c', 'kernel/hrtimer.c', and 'kernel/time.c'.
> > > > They are now under 'kernel/time'.
> > > >
> > > > Also definitions of 'getpid', 'getppid', 'getuid', 'geteuid', 'getgid',
> > > > 'getegid', 'gettid', and 'sysinfo' are now in 'kernel/sys.c'.
> > > 
> > > Can we please remove these file references completely. They are going
> > > to be stale sooner than later again and they really do not provide
> > > any value.
>
> I actually refer to them a lot when locating syscall implementations,
> which is how I found out that they were stale in the first place.

# git grep -n 'SYSCALL.*(nanosleep'

kernel/time/hrtimer.c:1945:SYSCALL_DEFINE2(nanosleep, struct ...
kernel/time/hrtimer.c:1965:SYSCALL_DEFINE2(nanosleep_time32, struct ...

Gives you the always correct answer including the line number.

So there is really no value in keeping those file references and have them
outdated once a function or a file moves. It's just matter of fact that
nobody ever fixes them up when a function or a file moves. Why? Because
they have no connection. The compiler does not complain and there are no
tools which could ever validate them. So removing them is the right thing
to do.

Thanks,

	tglx
