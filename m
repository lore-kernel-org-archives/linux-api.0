From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: + prctl-add-pr_set_proctitle_area-option-for-prctl.patch added to -mm tree
Date: Mon, 18 Jan 2010 09:56:46 +0900 (JST)
Message-ID: <20100118093413.AE1C.A69D9226@jp.fujitsu.com>
References: <200912302323.nBUNNsGv008033@imap1.linux-foundation.org> <4B50F74F.2060608@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B50F74F.2060608-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mm-commits-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On 12/30/2009 03:23 PM, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> > ------------------------------------------------------
> > Subject: prctl: add PR_SET_PROCTITLE_AREA option for prctl()
> > From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > 
> > Currently glibc2 doesn't have setproctitle(3), so several userland daemons
> > attempt to emulate it by doing some brutal stack modifications.  This
> > works most of the time, but it has problems.  For example:
> > 
> >  % ps -ef |grep avahi-daemon
> >  avahi     1679     1  0 09:20 ?        00:00:00 avahi-daemon: running [kosadesk.local]
> > 
> >  # cat /proc/1679/cmdline
> >  avahi-daemon: running [kosadesk.local]
> > 
> > This looks good, but the process has also overwritten its environment area
> > and made the environ file useless:
> > 
> >  # cat /proc/1679/environ
> >  adesk.local]
> > 
> > Another problem is that the process title length is limited by the size of
> > the environment.  Security conscious people try to avoid potential
> > information leaks by clearing most of the environment before running a
> > daemon:
> > 
> >  # env - MINIMUM_NEEDED_VAR=foo /path/to/daemon
> > 
> > The resulting environment size may be too small to fit the wanted process
> > titles.
> > 
> > This patch makes it possible for userspace to implement setproctitle()
> > cleanly.  It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
> > updates task's mm_struct->arg_start and arg_end to the given area.
> > 
> 
> Sorry for the late feedback...
> 
> On the subject of this patch: would it also make sense to have a prctl()
> to give the kernel the address of the "environ" variable, so that
> /proc/*/environ can give the *current* environment inside the process
> (which is otherwise strictly a user-space matter) as opposed to the
> initial environment passed by the kernel (unless modified in-place)?

Thank you good comments! 
I have two comments.

1 Yes, to change /proc/*/environ makes lots sense. probably.
  My last worry is, If security aware daemon want to hide environment intentionally,
  it should be able to do. iow, automatical environ area finding seems bad. 
  probably we need new prctl or new syscall.
2 this prctl is intend to the base of implement setproctitle() libc function. libc5 had it, but glibc2
   lost it.  few month ago, imap daemon devepler wanted to implement its function in
   libc-alpha. and I've hear similar requreiment sometimes. then I added this. correct 
  setproctitle() require this patch.
   plus, lots application have #ifdef HAVE_SETPROCTITLE configuration already. iow, 
   this patch don't require application change. it only require libc change.
