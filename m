From: josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org
Subject: Re: [PATCHv2 1/2] clone: Support passing tls argument via C rather
 than pt_regs magic
Date: Tue, 12 May 2015 17:53:37 -0700
Message-ID: <20150513005337.GB14292@cloud>
References: <20150511192918.GA11361@jtriplet-mobl1>
 <20150512142250.dcb053da81855ae1b5861173@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512142250.dcb053da81855ae1b5861173-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 02:22:50PM -0700, Andrew Morton wrote:
> On Mon, 11 May 2015 12:29:19 -0700 Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> wrote:
> 
> > Introduce a new CONFIG_HAVE_COPY_THREAD_TLS for architectures to opt
> > into, and a new copy_thread_tls that accepts the tls parameter as an
> > additional unsigned long (syscall-argument-sized) argument.
> > Change sys_clone's tls argument to an unsigned long (which does
> > not change the ABI), and pass that down to copy_thread_tls.
> > 
> > Architectures that don't opt into copy_thread_tls will continue to
> > ignore the C argument to sys_clone in favor of the pt_regs captured at
> > kernel entry, and thus will be unable to introduce new versions of the
> > clone syscall.
> 
> What happens quite frequently is that we do something for x86 with the
> expectation that other architectures will follow along, but this
> doesn't happen.  The arch maintainers simply didn't know about it or
> nobody nags them.  Nothing happens and inconsistencies hang around for
> years.  eg, http://lkml.iu.edu/hypermail/linux/kernel/1504.2/04993.html

In this case, there will be a very clear incentive to switch to
CONFIG_HAVE_COPY_THREAD_TLS: if you don't, you can't enable new
syscalls.

- Josh Triplett
