From: ebiederm@xmission.com (Eric W. Biederman)
Subject: [PATCH v2 0/7] signal: Fix sending signals with siginfo
Date: Tue, 18 Jul 2017 09:04:36 -0500
Message-ID: <87o9shg7t7.fsf_-_@xmission.com>
References: <87lgot2loq.fsf@xmission.com> <87zid90vye.fsf_-_@xmission.com>
        <20170615225426.GP31671@ZenIV.linux.org.uk>
        <87poe4zrs1.fsf@xmission.com>
        <CA+55aFxpv+gchzs7AYgSC8feAOV=B6mjFgBVm4Kx+83J2CNE-w@mail.gmail.com>
        <87poe3vsa9.fsf@xmission.com>
        <CALCETrX=SquyR8JZqHDNx=_FQKQo-0u9AxfdUwJs_hujVO2A-g@mail.gmail.com>
        <87h8zfua59.fsf@xmission.com>
        <CALCETrWPBn31Dye=81r2ZMainNOnDy5c_QxbU2uRjnJs0ie=Zg@mail.gmail.com>
        <87r2yjsuwl.fsf@xmission.com> <20170616191602.GA10675@1wt.eu>
        <87bmp5y7nj.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87bmp5y7nj.fsf_-_@xmission.com> (Eric W. Biederman's message of
        "Fri, 30 Jun 2017 07:36:16 -0500")
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <greg@kroah.com>, Andrey Vagin <avagin@openvz.org>, Serge Hallyn <serge@hallyn.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Peter Zijlstra <peterz@infradead.org>, Willy Tarreau <w@1wt.eu>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, Linux Containers <containers@lists.linux-foundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org


Today sending a signal with rt_sigqueueinfo and receving it on
a signalfd does not work reliably.  The issue is that reading
a signalfd instead of returning a siginfo returns a signalfd_siginfo and
the kernel must convert from one to the other.

The kernel does not currently have the code to deduce which union
members of struct siginfo are in use.

In this patchset I fix that by introducing a new function siginfo_layout
that can look at a siginfo and report which union member of struct
siginfo is in use.  Before that I clean up how we populate struct
siginfo.

The siginfo structure has two key members si_signo and si_code.  Some
si_codes are signal specific and for those it takes si_signo and si_code
to indicate the members of siginfo that are valid.  The rest of the
si_code values are signal independent like SI_USER, SI_KERNEL, SI_QUEUE,
and SI_TIMER and only si_code is needed to indicate which members of
siginfo are valid.

At least that is how POSIX documents them, and how common sense would
indicate they should function.  In practice we have been rather sloppy
about maintaining the ABI in linux and we have some exceptions.  We have
a couple of buggy architectures that make SI_USER mean something
different when combined with SIGFPE or SIGTRAP.  Worse we have
fcntl(F_SETSIG) which results in the si_codes POLL_IN, POLL_OUT,
POLL_MSG, POLL_ERR, POLL_PRI, POLL_HUP being sent with any arbitrary
signal, while the values are in a range that overlaps the signal
specific si_codes.

Thankfully the ambiguous cases with the POLL_NNN si_codes are for
things no sane persion would do that so we can rectify the situtation.
AKA no one cares so we won't cause a regression fixing it.

As part of fixing this I stop leaking the __SI_xxxx codes to userspace
and stop storing them in the high 16bits of si_code.  Making the kernel
code fundamentally simpler.  We have already confirmed that the one
application that would see this difference in kernel behavior CRIU won't
be affected by this change as it copies values verbatim from one kernel
interface to another.

v2:
   - Benchmarked the code to confirm no performance changes are visible.
   - Reworked the first couple of patches so that TRAP_FIXME and
     FPE_FIXME are not exported to userspace.
   - Rebased on top of the siginfo cleanup that came in v4.13-rc1
   - Updated alpha to use both TRAP_FIXME and FPE_FIXME

Eric W. Biederman (7):
      signal/alpha: Document a conflict with SI_USER for SIGTRAP
      signal/ia64: Document a conflict with SI_USER with SIGFPE
      signal/sparc: Document a conflict with SI_USER with SIGFPE
      signal/mips: Document a conflict with SI_USER with SIGFPE
      signal/testing: Don't look for __SI_FAULT in userspace
      fcntl: Don't use ambiguous SIG_POLL si_codes
      signal: Remove kernel interal si_code magic

 arch/alpha/include/uapi/asm/siginfo.h         |  14 ++++
 arch/alpha/kernel/traps.c                     |   6 +-
 arch/arm64/kernel/signal32.c                  |  23 ++----
 arch/blackfin/include/uapi/asm/siginfo.h      |  30 ++++---
 arch/frv/include/uapi/asm/siginfo.h           |   2 +-
 arch/ia64/include/uapi/asm/siginfo.h          |  21 +++--
 arch/ia64/kernel/signal.c                     |  17 ++--
 arch/ia64/kernel/traps.c                      |   4 +-
 arch/mips/include/uapi/asm/siginfo.h          |  11 ++-
 arch/mips/kernel/signal32.c                   |  19 ++---
 arch/mips/kernel/traps.c                      |   2 +-
 arch/parisc/kernel/signal32.c                 |  31 ++++---
 arch/powerpc/kernel/signal_32.c               |  20 ++---
 arch/s390/kernel/compat_signal.c              |  32 ++++---
 arch/sparc/include/uapi/asm/siginfo.h         |   9 +-
 arch/sparc/kernel/signal32.c                  |  16 ++--
 arch/sparc/kernel/traps_32.c                  |   2 +-
 arch/sparc/kernel/traps_64.c                  |   2 +-
 arch/tile/include/uapi/asm/siginfo.h          |   4 +-
 arch/tile/kernel/compat_signal.c              |  18 ++--
 arch/tile/kernel/traps.c                      |   2 +-
 arch/x86/kernel/signal_compat.c               |  21 ++---
 fs/fcntl.c                                    |  13 ++-
 fs/signalfd.c                                 |  22 ++---
 include/linux/signal.h                        |  22 +++++
 include/uapi/asm-generic/siginfo.h            | 115 +++++++++++---------------
 kernel/exit.c                                 |   4 +-
 kernel/ptrace.c                               |   6 +-
 kernel/signal.c                               |  72 ++++++++++++----
 tools/testing/selftests/x86/mpx-mini-test.c   |   3 +-
 tools/testing/selftests/x86/protection_keys.c |  13 ++-
 31 files changed, 318 insertions(+), 258 deletions(-)
