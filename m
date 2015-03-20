From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 5/7] clone4: Add a CLONE_AUTOREAP flag to
	automatically reap the child process
Date: Fri, 20 Mar 2015 20:09:14 +0100
Message-ID: <20150320190914.GA28357@redhat.com>
References: <cover.1426376419.git.josh@joshtriplett.org> <20150315233439.GA31890@thin> <20150320181404.GA26343@redhat.com> <1766646.jusoNDOCPE@tjmaciei-mobl4>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1766646.jusoNDOCPE@tjmaciei-mobl4>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thiago Macieira <thiago.macieira-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/20, Thiago Macieira wrote:
>
> On Friday 20 March 2015 19:14:04 Oleg Nesterov wrote:
> > Also. I forgot that the kernel always resets ->exit_signal to SIGCHLD on
> > exec or reparenting. Reparenting is probably fine. But what about exec?
> > Should it keep ->exit_signal == 0 if "autoreap" ? I think it should not, to
> > avoid the strange special case.
>
> Not delivering any signal was the objective of this patch series, so yes
> exit_signal == 0 should survive an exec and even re-exec.

OK, but then perhaps we should never send SIGCHLD (on exit) if "autoreap",
to make the logic simple.

And copy_process() should probably do

	if ((clone_flags & CSIGNAL) && (clone_flags && CLONE_AUTOREAP))
		return -EINVAL;

so that we still can change this behaviour later.

Oleg.
