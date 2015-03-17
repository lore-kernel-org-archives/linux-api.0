From: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file descriptor
Date: Mon, 16 Mar 2015 17:49:52 -0700
Message-ID: <4157103.KzTpXff0QK@tjmaciei-mobl4>
References: <cover.1426376419.git.josh@joshtriplett.org> <2381173.VxaIO6vGG3@tjmaciei-mobl4> <20150316232949.GB31751@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150316232949.GB31751@cloud>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Monday 16 March 2015 16:29:49 josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org wrote:
> > A child without CLONE_AUTOREAP should be wait()able. If it gets wait()ed 
> > before the clonefd is read, the clonefd() will return a 0 read. If it
> > gets 
> > read before wait, then wait() reaps another child or returns -ECHILD.
> > That's  no different than two threads doing simultaneous wait() on the
> > same child.
> Hrm?  That isn't the semantics we implemented; you'll *always* get an
> exit notification via the clonefd if you have it open, with or without
> autoreap and whether or not a wait has occurred yet.  And reading from
> the clonefd does not serve as a wait; if you don't pass CLONE_AUTOREAP,
> you'll still need to wait on the process.

Ah, I see what you're saying. Ok, I stand corrected: a child without 
CLONE_AUTOREAP must be wait()ed on and whoever waits on it will get 
information. In addition to that, the information is available on the clonefd 
and it can happen at any time, before or after the wait().

In the case of an orphaned child, the file descriptor will close, that's all. 
No modification is necessary to init.

-- 
Thiago Macieira - thiago.macieira (AT) intel.com
  Software Architect - Intel Open Source Technology Center
