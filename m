From: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for
	prctl()
Date: Sun, 7 Mar 2010 15:24:30 -0500
Message-ID: <3e8340491003071224o5ea1c01cl73132e7c2cc6046f@mail.gmail.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org>
	<alpine.LFD.2.00.1003061100170.4530@localhost.localdomain>
	<20100307192826.GA18616@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100307192826.GA18616-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Mar 7, 2010 at 14:28, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/06, Linus Torvalds wrote:
>>
>> On Fri, 5 Mar 2010, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
>> >
>> > This patch makes it possible for userspace to implement setproctit=
le()
>> > cleanly. =A0It adds a new PR_SET_PROCTITLE_AREA option for prctl()=
, which
>> > updates task's mm_struct->arg_start and arg_end to the given area.
>>
>> This looks overly complicated. Why do you change the whole locking r=
ules,
>> instead of protecting _only_ the "arg_start/arg_end" case?
>>
>> The thing is, there's no reason to hold the mmap_sem over the whole =
thing,
>> and I don't think this is important enough to be a valid reason for
>> exposing a whole new "locked" access variant, when a simple "protect=
 just
>> the arg_start/end" would handle it.
>
> It was me who suggested to re-use mm->mmap_sem instead of adding the =
new
> lock, but looking at this patch again I do not understand the reason =
this
> lock should be held throughout in proc_pid_cmdline(). If there is no =
such
> a reason, then the new access_process_vm_locked (cough, also suggeste=
d by
> me ;) is not needed.

Consider:

Process A is reading /proc/pidB/cmdline. As it enters
proc_pid_cmdline, the compiler stashes mm->arg_end and mm->arg_start
in a register or something, and then the process is preempted.
Process B now changes the location of its cmdline buffer. After
changing it, it free()s the buffer. Then it malloc()s a buffer for
sensitive data. Unfortunately, this happens to be at the same address.
Eventually control returns to process A, which reads sensitive data
out of process B's address space using the stale values for arg_end
and arg_start. Process A did not have to be a privileged process or
the same uid to do this.

Note that B cannot defend against this, as it has no idea how long a
hypothetical process A may be preempted. If B is a high-priority or
real-time process, A may be preempted for a very long time indeed.
Alternately process A may be interrupted by a slow interrupt handler.

Since B cannot determine when it may be safe to re-use the buffer, the
conclusion is that without a lock of some sort in the kernel, B must
never re-use any memory used for its cmdline buffer, which is a very
undesirable result.
