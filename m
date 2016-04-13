From: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 17:03:20 +0100
Message-ID: <20160413160320.GI11600@redhat.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <1460562105.353100.577697153.013DF466@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460562105.353100.577697153.013DF466-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 13, 2016 at 11:41:45AM -0400, Colin Walters wrote:
> On Wed, Apr 13, 2016, at 08:57 AM, Richard W.M. Jones wrote:
> 
> > It's not possible to read the process umask without also modifying it,
> > which is what umask(2) does.  A library cannot read umask safely,
> > especially if the main program might be multithreaded.
> 
> I assume you just want to do this from a shared library so you can
> determine whether or not you need to call fchown() after making files
> and the like?  If that's the case it'd be good to note it in the commit
> message.

Yes, the use case is something like that.  I write a shared library
(libguestfs) and we get bug reports that turn out to be caused by odd
umask settings.  Of course we fix these on a case-by-case basis, but
we also want to include the current umask in debug output so that we
can identify the problem quickly in future reports.

Actually I wrote a rather involved getumask substitute:

  https://github.com/libguestfs/libguestfs/blob/master/src/launch.c#L477

It works by creating a temporary directory, writing a file inside that
directory with mode 0777, then calling fstat(2) to work out what mode
the kernel gave it.

It turns out this code is not even correct.  It was pointed out to me
that there is a filesystem umask mount option (and fmask, dmask too)
which stops this from working properly.

So it's a lot of work to read umask safely inside a shared library.

I will update the commit comment with a brief summary of the above.

> BTW...it might be a good idea to add a flags argument:
> https://lwn.net/Articles/585415/
>
> Did you consider calling this `umask2`, having the initial version
> only support retrieving it via a UMASK_GET flag, and lay the
> groundwork to support setting a threadsafe umask with a
> UMASK_SET_THREAD flag?

Can certainly do it like this if that is preferable.

For my needs, getumask as implemented now is sufficient.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
