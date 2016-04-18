From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Sun, 17 Apr 2016 19:12:59 -0700
Message-ID: <20160418021259.GB16600@x>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <2143735451.55767.1460561962122.JavaMail.zimbra@efficios.com>
 <1736004700.56566.1460581285951.JavaMail.zimbra@efficios.com>
 <20160414021348.GB16656@thunk.org>
 <57142C80.6070005@zytor.com>
 <20160418010925.GA7800@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418010925.GA7800-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zab <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, iulia manda21 <iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, mguzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gorcunov@gmai
List-Id: linux-api@vger.kernel.org

On Mon, Apr 18, 2016 at 10:09:25AM +0900, Greg KH wrote:
> On Sun, Apr 17, 2016 at 05:38:24PM -0700, H. Peter Anvin wrote:
> > On 04/13/16 19:13, Theodore Ts'o wrote:
> > > 
> > > One other reason to suggest using a /proc file is that you're not at
> > > the mercy of the glibc folks to wire up a new system call.  (Glibc has
> > > been refusing to wire up getrandom(2), for example.   Grrrr.....)
> > > 
> > 
> > This brings right back up the libinux idea.  There are continued
> > concerns about type compatibility, but saying "oh, use syscall(3)
> > instead" has worse properties than a Linux-kernel-team maintained
> > libinux.  Last I heard the glibc team had (reluctantly?) agreed to do
> > something to deal with linux-specific system calls, but last I heard
> > nothing had happened.  The last discussion I see on the glibc mailing
> > list dates back to November, and that thread seems to have died from
> > bikeshedding, again.
> > 
> > There aren't a *lot* of such system calls, but even in that thread the
> > "oh, only two applications need this, let them use syscall(3)" seems to
> > remain.
> 
> And only 2 applications will continue to use it because no one wants to
> write syscall() wrappers for their individual applications, so it's a
> vicious cycle :(
> 
> I really like the 'libinux' idea, did anyone every hack up a first-pass
> at this?  And I'm guessing we have more syscalls now that would need to
> be added (like getrandom(), but that shouldn't be too difficult.

Personally, I'd suggest that libinux should wire up *all* (non-obsolete)
syscalls, not just those that haven't already been exposed via any
particular libc implementation.  Each such syscall function would have
minimal overhead, since unlike libc these wrappers would not have any
special handling (other than use of the vdso) and would directly map to
the kernel syscall signature.  Given a standard prefix like sys_ or
linux_, that would provide a clear distinction between direct-syscall
functions and libc functions, and avoid any future conflict if libc adds
a function named the same as the syscall.

As a random example, sys_getpid() would *always* call the getpid
syscall, rather than reading a cache within the library.  (And
sys_gettid would call the gettid syscall, rather than failing to exist.)
