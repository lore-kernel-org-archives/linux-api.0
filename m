From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 07:02:00 -0700
Message-ID: <20160413140200.GA29387@infradead.org>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <1460552272-15985-2-git-send-email-rjones@redhat.com>
 <20160413132031.GJ2000@uranus.lan>
 <20160413135708.GG11600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160413135708.GG11600-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 13, 2016 at 02:57:08PM +0100, Richard W.M. Jones wrote:
> On Wed, Apr 13, 2016 at 04:20:32PM +0300, Cyrill Gorcunov wrote:
> > On Wed, Apr 13, 2016 at 01:57:51PM +0100, Richard W.M. Jones wrote:
> > > Define a system call for reading the current umask value.
> > > 
> > > Signed-off-by: Richard W.M. Jones <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > Btw don't we have to declare it in include/uapi/asm-generic/unistd.h as well?
> 
> Yes, I think I do.  I was following pwritev2 which wasn't added
> to this file, but other recent system calls (mlock2, copy_file_range)
> were added.

Indeed.  I'll send a patch to wire up pread/writev2, sorry for causing
your conflicts, but adding syscalls is a bit of a mess.
