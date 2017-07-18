From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH 7/7] signal: Remove kernel interal si_code magic
Date: Tue, 18 Jul 2017 12:27:26 -0500
Message-ID: <878tjlbqpt.fsf@xmission.com>
References: <87o9shg7t7.fsf_-_@xmission.com>
	<20170718140651.15973-7-ebiederm@xmission.com>
	<CA+55aFyKsmf+BpYjcH30MGpHTDJ=zgYPx6kwyEB9CXXFxj_xsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CA+55aFyKsmf+BpYjcH30MGpHTDJ=zgYPx6kwyEB9CXXFxj_xsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Linus Torvalds's message of "Tue, 18 Jul 2017 09:57:09 -0700")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Willy Tarreau <w@1wt.eu>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

> On Tue, Jul 18, 2017 at 7:06 AM, Eric W. Biederman
> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> struct siginfo is a union and the kernel since 2.4 has been hiding a union
>> tag in the high 16bits of si_code using the values:
>> __SI_KILL
>> __SI_TIMER
>> __SI_POLL
>> __SI_FAULT
>> __SI_CHLD
>> __SI_RT
>> __SI_MESGQ
>> __SI_SYS
>>
>> While this looks plausible on the surface, in practice this situation has
>> not worked well.
>
> So on the whole I think we just need to do this, but the part I really
> hate about this series is still this the siginfo_layout() part.
>
> I can well believe that it is needed for the compat case. siginfo is a
> piece of crap crazy type, and re-ordering fields for compat is
> something we are always going to have to do.
>
> But for the native case, the *only* reason we do not just copy the
> siginfo as-is seems to be that it's just too big, due to other bad
> design decisions in siginfo ("let's make sure it's big enough by
> allocating 512 bytes for it).
>
> And afaik, absolutely nobody uses more than about 36 bytes of that
> 512-byte _sifields union (and that one use is SIGILL with three
> pointers and three integers and some padding.
>
> So why don't we just say "screw this idiotic layout crap, and just
> unconditionally copy that much smaller maximum of bytes"?
>
> Leave that layout thing purely for compat handling.

I completely agree.

> Yes, yes, there's a couple of small gotchas's:
>
>  - "_sys_private" for posix timers, and it would have to be moved to
> the end of the structure so that it doesn't get copied.

I don't think we actually need _sys_private at all.

I think the best solution would involve embedding struct siginfo
into struct k_itimer (as we always allocate one).   Then we can just
perform container_of on the siginfo and look at the k_itimer instead.

>  - make sure those 36 bytes are cleared when allocating the siginfo
> (this should be trivial) so that we don't leak any other memory.
>
> But on the whole, it looks pretty straightforward to just get rid of
> those stupid layout things, and make them purely about compat stuff.
>
> Please?
>
> The si_code stuff clearly needs to be done regardless, so much of this
> patch series looks good to me.  But if we're doign this cleanup, can't
> we please go that one extra step and get rid of the crazy "let's treat
> the union as different types", and just treat it as a largely opaque
> thing.
>
> Pretty please?

That is my next step.

I have started on it but it is a big additional patch.  I have to insert
a bunch of memsets to ensure we are not copying unitialized stack
contents to userspace.

I have been convinced not to expect any performance issues:
  - Worst case two reads from memory 60ns*2 = 120ns.
  - 650ns time to send a signal.
  - 350ns time to receive a signal.
  So that is maybe a 10% change, and more likely lost completely
  in the noise.

I intend to measure the performance change just copying it all to see if
I even need to optimize to just copy the needed 36 bytes.

The diffstat for introducing a clear_siginfo to ensure we have made
those memsets is huge so I am worried about introducing bugs along
the way or missing something.

 arch/alpha/kernel/osf_sys.c               |  1 +
 arch/alpha/kernel/signal.c                |  2 ++
 arch/alpha/kernel/traps.c                 |  5 ++++
 arch/alpha/mm/fault.c                     |  2 ++
 arch/arc/kernel/traps.c                   | 14 ++++++----
 arch/arc/mm/fault.c                       |  1 +
 arch/arm/kernel/ptrace.c                  |  2 ++
 arch/arm/kernel/swp_emulate.c             |  1 +
 arch/arm/kernel/traps.c                   |  5 ++++
 arch/arm/mm/alignment.c                   |  1 +
 arch/arm/mm/fault.c                       |  3 ++
 arch/arm/vfp/vfpmodule.c                  |  2 +-
 arch/arm64/kernel/debug-monitors.c        | 13 +++++----
 arch/arm64/kernel/fpsimd.c                |  2 +-
 arch/arm64/kernel/ptrace.c                | 13 +++++----
 arch/arm64/kernel/traps.c                 |  2 ++
 arch/arm64/mm/fault.c                     |  4 +++
 arch/blackfin/kernel/traps.c              |  1 +
 arch/c6x/kernel/traps.c                   |  1 +
 arch/cris/mm/fault.c                      |  1 +
 arch/frv/kernel/traps.c                   |  7 +++++
 arch/frv/mm/fault.c                       |  1 +
 arch/hexagon/kernel/traps.c               |  1 +
 arch/hexagon/mm/vm_fault.c                |  2 ++
 arch/ia64/kernel/brl_emu.c                |  3 ++
 arch/ia64/kernel/signal.c                 |  2 ++
 arch/ia64/kernel/traps.c                  |  3 +-
 arch/ia64/kernel/unaligned.c              |  1 +
 arch/ia64/mm/fault.c                      |  1 +
 arch/m32r/kernel/traps.c                  |  1 +
 arch/m32r/mm/fault.c                      |  1 +
 arch/m68k/kernel/traps.c                  |  2 ++
 arch/m68k/mm/fault.c                      |  3 +-
 arch/metag/kernel/traps.c                 |  2 ++
 arch/metag/mm/fault.c                     |  2 ++
 arch/microblaze/kernel/exceptions.c       |  1 +
 arch/microblaze/mm/fault.c                |  1 +
 arch/mips/kernel/traps.c                  | 29 +++++++++++++------
 arch/mips/mm/fault.c                      |  1 +
 arch/mn10300/kernel/fpu.c                 |  1 +
 arch/mn10300/kernel/traps.c               |  1 +
 arch/mn10300/mm/fault.c                   |  1 +
 arch/mn10300/mm/misalignment.c            |  2 ++
 arch/nios2/kernel/traps.c                 |  1 +
 arch/openrisc/kernel/traps.c              |  5 +++-
 arch/openrisc/mm/fault.c                  |  1 +
 arch/parisc/kernel/ptrace.c               |  1 +
 arch/parisc/kernel/traps.c                |  2 ++
 arch/parisc/kernel/unaligned.c            |  2 ++
 arch/parisc/math-emu/driver.c             |  1 +
 arch/parisc/mm/fault.c                    |  1 +
 arch/powerpc/kernel/process.c             |  2 ++
 arch/powerpc/kernel/traps.c               |  4 +--
 arch/powerpc/mm/fault.c                   |  1 +
 arch/powerpc/platforms/cell/spufs/fault.c |  2 +-
 arch/s390/kernel/traps.c                  |  3 ++
 arch/s390/mm/fault.c                      |  2 ++
 arch/score/kernel/traps.c                 |  1 +
 arch/score/mm/fault.c                     |  1 +
 arch/sh/kernel/hw_breakpoint.c            |  1 +
 arch/sh/kernel/traps_32.c                 |  4 +++
 arch/sh/math-emu/math.c                   |  1 +
 arch/sh/mm/fault.c                        |  1 +
 arch/sparc/kernel/process_64.c            |  1 +
 arch/sparc/kernel/sys_sparc_32.c          |  1 +
 arch/sparc/kernel/sys_sparc_64.c          |  1 +
 arch/sparc/kernel/traps_32.c              | 10 +++++++
 arch/sparc/kernel/traps_64.c              | 15 ++++++++++
 arch/sparc/kernel/unaligned_32.c          |  1 +
 arch/sparc/mm/fault_32.c                  |  1 +
 arch/sparc/mm/fault_64.c                  |  1 +
 arch/tile/kernel/hardwall.c               |  1 +
 arch/tile/kernel/ptrace.c                 |  2 +-
 arch/tile/kernel/single_step.c            | 24 +++++++++-------
 arch/tile/kernel/traps.c                  |  4 ++-
 arch/tile/kernel/unaligned.c              | 46 +++++++++++++++++--------------
 arch/tile/mm/fault.c                      |  1 +
 arch/um/kernel/ptrace.c                   |  2 +-
 arch/um/kernel/trap.c                     |  4 ++-
 arch/unicore32/kernel/fpu-ucf64.c         |  3 +-
 arch/unicore32/mm/fault.c                 |  3 ++
 arch/x86/entry/vsyscall/vsyscall_64.c     |  2 +-
 arch/x86/kernel/ptrace.c                  |  2 +-
 arch/x86/kernel/traps.c                   |  3 ++
 arch/x86/kvm/mmu.c                        |  1 +
 arch/x86/mm/fault.c                       |  1 +
 arch/xtensa/kernel/ptrace.c               |  1 +
 arch/xtensa/kernel/traps.c                |  1 +
 arch/xtensa/mm/fault.c                    |  1 +
 drivers/usb/core/devio.c                  |  4 +--
 fs/fcntl.c                                |  1 +
 include/linux/ptrace.h                    |  2 +-
 include/linux/signal.h                    |  5 ++++
 ipc/mqueue.c                              |  1 +
 kernel/debug/kdb/kdb_main.c               |  1 +
 kernel/ptrace.c                           |  2 +-
 kernel/seccomp.c                          |  2 +-
 kernel/signal.c                           | 21 ++++++++++----
 kernel/time/posix-timers.c                |  2 +-
 mm/memory-failure.c                       |  1 +
 100 files changed, 272 insertions(+), 85 deletions(-)

Eric
