From: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Mon, 18 Apr 2016 10:14:12 +0100
Message-ID: <20160418091412.GD11600@redhat.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <1460562105.353100.577697153.013DF466@webmail.messagingengine.com>
 <57143B74.3070302@zytor.com>
 <20160418015736.GA16600@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160418015736.GA16600@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Apr 17, 2016 at 06:57:36PM -0700, Josh Triplett wrote:
> O_NOUMASK seems potentially useful to support implementation of umask
> entirely in userspace, which also addresses thread-safety.  A program
> could read its process umask out at startup, handle umask entirely in
> userspace (including for threads), and only interact with the system
> umask after fork and before exec.

I had a look at O_NOUMASK and there are a few problems:

It's relatively easy to implement for open(2).  A few filesystems
implement their own open so I had to go into those filesystems and
modify how they handle current_umask too.  And FUSE support is tricky
so I passed on that.

The real problem is that mkdir/mkdirat/mknod/mknodat are affected by
umask, but there is no convenient flags parameter to pass the
O_NOUMASK flag.  So I think the patch only half-solves the problem.

I have a patch which needs a bit more testing, which I can post if you
think that's helpful, but I don't think it would be acceptable in its
current state.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org
