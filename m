From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Thu, 14 Apr 2016 10:56:38 -0700
Message-ID: <CALCETrX20sVXEQruJXy=uet4e-vnc3NeWYHe3Cm6TOqn772-Bg@mail.gmail.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <2143735451.55767.1460561962122.JavaMail.zimbra@efficios.com> <1736004700.56566.1460581285951.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1736004700.56566.1460581285951.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Florian Weimer <fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, iulia manda21 <iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, mguzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, zab <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>li
List-Id: linux-api@vger.kernel.org

On Apr 13, 2016 2:01 PM, "Mathieu Desnoyers"
<mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>
> ----- On Apr 13, 2016, at 11:39 AM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:
>
> > ----- On Apr 13, 2016, at 8:57 AM, Richard W.M. Jones rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> >
> >> v1 -> v2:
> >>
> >> - Use current_umask() instead of current->fs->umask.
> >>
> >> - Retested it.
> >>
> >> ----------------------------------------------------------------------
> >>
> >> It's not possible to read the process umask without also modifying it,
> >> which is what umask(2) does.  A library cannot read umask safely,
> >> especially if the main program might be multithreaded.
> >>
> >> This patch series adds a trivial system call "getumask" which returns
> >> the umask of the current process.
> >
> > In addition to this system call, we could extend a variation of my
> > thread_local_abi system call (https://lkml.org/lkml/2016/4/4/455)
> > (could be without features flags, or an entirely new system call
> > specifically for a umask cache) to register a "current umask" cache
> > located in a TLS area.
> >
> > Basically, reading the current umask value would be a simple load from
> > a TLS variable.
>
> I'm actually discussing 3 separate things here: the umask, sigmask, and
> cpu affinity mask.
>
> Not sure if caching the umask in a TLS would be that useful, though.
> The caching idea seems to make more sense for signal mask and cpu
> affinity mask.
>

I think this is of questionable value.

Keep in mind that every feature like this adds overhead to lots of
code paths as well as additional complexity.  Such features should be
justified by big performance benefits.

Given that processes can easily track their own umasks and signal
masks if they care, I don't see why the kernel would want to help.

--Andy
