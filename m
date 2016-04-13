From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 15:27:15 +0000 (UTC)
Message-ID: <255131446.55722.1460561235657.JavaMail.zimbra@efficios.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com> <1460552272-15985-2-git-send-email-rjones@redhat.com> <20160413132031.GJ2000@uranus.lan> <20160413135708.GG11600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160413135708.GG11600-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, iulia manda21 <iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

----- On Apr 13, 2016, at 9:57 AM, Richard W.M. Jones rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:

> On Wed, Apr 13, 2016 at 04:20:32PM +0300, Cyrill Gorcunov wrote:
>> On Wed, Apr 13, 2016 at 01:57:51PM +0100, Richard W.M. Jones wrote:
>> > Define a system call for reading the current umask value.
>> > 
>> > Signed-off-by: Richard W.M. Jones <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> 
>> Btw don't we have to declare it in include/uapi/asm-generic/unistd.h as well?
> 
> Yes, I think I do.  I was following pwritev2 which wasn't added
> to this file, but other recent system calls (mlock2, copy_file_range)
> were added.
> 
> TBH the documentation for this file is not very clear...

asm-generic/unistd.h defines the system call for a few
architectures. 

grep -r asm-generic/unistd.h arch/*/include/
arch/arc/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/arc/include/uapi/asm/unistd.h:/* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
arch/arm64/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/c6x/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/h8300/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/hexagon/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/metag/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/nios2/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/openrisc/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/score/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/tile/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>
arch/unicore32/include/uapi/asm/unistd.h:#include <asm-generic/unistd.h>

Wiring up the system call in this header means adding
support for this system call on all those architectures.

Thanks,

Mathieu

> 
> Rich.
> 
> --
> Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
> Read my programming and virtualization blog: http://rwmj.wordpress.com
> virt-df lists disk usage of guests without needing to install any
> software inside the virtual machine.  Supports Linux and Windows.
> http://people.redhat.com/~rjones/virt-df/

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
