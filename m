From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 21:01:25 +0000 (UTC)
Message-ID: <1736004700.56566.1460581285951.JavaMail.zimbra@efficios.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com> <2143735451.55767.1460561962122.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2143735451.55767.1460561962122.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zab <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, iulia manda21 <iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, mguzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 13, 2016, at 11:39 AM, Mathieu Desnoyers mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org wrote:

> ----- On Apr 13, 2016, at 8:57 AM, Richard W.M. Jones rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> 
>> v1 -> v2:
>> 
>> - Use current_umask() instead of current->fs->umask.
>> 
>> - Retested it.
>> 
>> ----------------------------------------------------------------------
>> 
>> It's not possible to read the process umask without also modifying it,
>> which is what umask(2) does.  A library cannot read umask safely,
>> especially if the main program might be multithreaded.
>> 
>> This patch series adds a trivial system call "getumask" which returns
>> the umask of the current process.
> 
> In addition to this system call, we could extend a variation of my
> thread_local_abi system call (https://lkml.org/lkml/2016/4/4/455)
> (could be without features flags, or an entirely new system call
> specifically for a umask cache) to register a "current umask" cache
> located in a TLS area.
> 
> Basically, reading the current umask value would be a simple load from
> a TLS variable.

I'm actually discussing 3 separate things here: the umask, sigmask, and
cpu affinity mask.

Not sure if caching the umask in a TLS would be that useful, though.
The caching idea seems to make more sense for signal mask and cpu
affinity mask.

Thanks,

Mathieu

> This could also allow quickly blocking and unblocking
> signal delivery from user-space by storing a mask to this TLS area.
> 
> The kernel could then look into the signal mask in this TLS area whenever
> it needs to deliver a signal (assuming this code path can take
> user-space faults), in addition to the mask kept within the
> task struct.
> 
> This "tls cache" idea could also apply to setting a CPU affinity to the
> currently running CPU for short user-space critical sections.
> 
> The benefit here is to get _very_ fast operations on the thread umask
> and cpu affinity.
> 
> Are those ideas too far-fetched ?
> 
> Thanks,
> 
> Mathieu
> 
>> 
>> Another approach to this has been attempted before, adding something
>> to /proc, although it didn't go anywhere.  See:
>> 
>>  http://comments.gmane.org/gmane.linux.kernel/1292109
>> 
>> Another way to solve this would be to add a thread-safe getumask to
>> glibc.  Since glibc could own the mutex, this would permit libraries
>> linked to this glibc to read umask safely.
>> 
>> I should also note that man-pages documents getumask(3), but no
>> version of glibc has ever implemented it.
>> 
>> Typical test script:
>> 
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <linux/unistd.h>
>> #include <sys/syscall.h>
>> 
>> int main(int argc, char *argv[])
>> {
>>  int r = syscall(329);
>>  if (r == -1) {
>>    perror("getumask");
>>    exit(1);
>>  }
>>  printf("umask = %o\n", r);
>>  exit(0);
>> }
>> 
>> $ ./getumask
>> umask = 22
>> 
>> Rich.
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
