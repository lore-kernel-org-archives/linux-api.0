From: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/3] vfs: Define new syscall umask2 [formerly getumask]
Date: Wed, 13 Apr 2016 20:05:33 +0100
Message-ID: <1460574336-18930-1-git-send-email-rjones@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org, walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

v3 -> v4:

 - Rename the syscall: getumask becomes umask2.

 - Add flags parameter, with one flag (UMASK_GET_MASK).

 - Expand the rationale for this change in the first commit message.

 - Add a selftest.

 - Retest everything.

--------------------

It's not possible to read the process umask without also modifying it,
which is what umask(2) does.  A library cannot read umask safely,
especially if the main program might be multithreaded.

This patch series adds a new system call "umask2".  This adds a flags
parameter.  Specifying flags=UMASK_GET_MASK allows the umask of the
current process to be read without modifying it.

This leaves open the possibility in future of adding a per-thread
umask, set or read with other flags.  This is not implemented.

Another approach to this has been attempted before, adding something
to /proc, although it didn't go anywhere.  See:

  http://comments.gmane.org/gmane.linux.kernel/1292109

Another way to solve this would be to add a thread-safe getumask to
glibc.  Since glibc could own the mutex, this would permit libraries
linked to this glibc to read umask safely.  I should also note that
man-pages documents getumask(3), but no version of glibc has ever
implemented it.

Rich.
