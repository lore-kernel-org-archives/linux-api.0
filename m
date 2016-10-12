From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH v3 08/11] powerpc/tracing: fix compat syscall handling
Date: Wed, 12 Oct 2016 20:59:42 +1100
Message-ID: <87zim951m9.fsf@concordia.ellerman.id.au>
References: <1476182576-15247-1-git-send-email-marcin.nowakowski@imgtec.com> <1476182576-15247-9-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476182576-15247-9-git-send-email-marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org> writes:

> Adapt the code to make use of new syscall handling interface
>
> Signed-off-by: Marcin Nowakowski <marcin.nowakowski-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
> Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
> Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> Cc: linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
> ---
>  arch/powerpc/include/asm/ftrace.h | 11 +++++++++++
>  arch/powerpc/kernel/ftrace.c      |  4 ++++

I went to test this and noticed the exit and enter events appear to be
reversed in time? (your series on top of 24532f768121)

  ls-4221  [003] ....    83.766113: compat_sys_rt_sigprocmask -> 0x2
  ls-4221  [003] ....    83.766137: compat_sys_rt_sigprocmask(how: 2, nset: 1010db30, oset: 0, sigsetsize: 8)
  ls-4221  [003] ....    83.766175: compat_sys_rt_sigaction -> 0x14
  ls-4221  [003] ....    83.766175: compat_sys_rt_sigaction(sig: 14, act: ffbd33c4, oact: ffbd3338, sigsetsize: 8)
  ls-4221  [003] ....    83.766177: compat_sys_rt_sigaction -> 0x15
  ls-4221  [003] ....    83.766177: compat_sys_rt_sigaction(sig: 15, act: ffbd33c4, oact: ffbd3338, sigsetsize: 8)
  ls-4221  [003] ....    83.766178: compat_sys_rt_sigaction -> 0x16
  ls-4221  [003] ....    83.766178: compat_sys_rt_sigaction(sig: 16, act: ffbd33d4, oact: ffbd3348, sigsetsize: 8)
  ls-4221  [003] ....    83.766179: sys_setpgid -> 0x107d
  ls-4221  [003] ....    83.766179: sys_setpgid(pid: 107d, pgid: 107d)
  ls-4221  [003] ....    83.766180: compat_sys_rt_sigprocmask -> 0x0
  ls-4221  [003] ....    83.766181: compat_sys_rt_sigprocmask(how: 0, nset: ffbd34b0, oset: ffbd3530, sigsetsize: 8)
  ls-4221  [003] ....    83.766186: compat_sys_ioctl -> 0xff
  ls-4221  [003] ....    83.766187: compat_sys_ioctl(fd: ff, cmd: 80047476, arg32: ffbd3488)
  ls-4221  [003] ....    83.766188: compat_sys_rt_sigprocmask -> 0x2
  ls-4221  [003] ....    83.766189: compat_sys_rt_sigprocmask(how: 2, nset: ffbd3530, oset: 0, sigsetsize: 8)
  ls-4221  [003] ....    83.766189: sys_close -> 0x4
  ls-4221  [003] ....    83.766190: sys_close(fd: 4)
  ls-4221  [003] ....    83.766191: sys_read -> 0x3
  ls-4221  [003] ....    83.766191: sys_read(fd: 3, buf: ffbd35dc, count: 1)
  ls-4221  [003] ....    83.766235: sys_close -> 0x3
  ls-4221  [003] ....    83.766235: sys_close(fd: 3)

cheers
