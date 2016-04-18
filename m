From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Sun, 17 Apr 2016 18:42:12 -0700
Message-ID: <57143B74.3070302@zytor.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <1460562105.353100.577697153.013DF466@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460562105.353100.577697153.013DF466-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 04/13/16 08:41, Colin Walters wrote:
> On Wed, Apr 13, 2016, at 08:57 AM, Richard W.M. Jones wrote:
> 
>> It's not possible to read the process umask without also modifying it,
>> which is what umask(2) does.  A library cannot read umask safely,
>> especially if the main program might be multithreaded.
> 
> I assume you just want to do this from a shared library so you can
> determine whether or not you need to call fchown() after making files
> and the like?  If that's the case it'd be good to note it in the commit
> message.
> 
> BTW...it might be a good idea to add a flags argument:
> https://lwn.net/Articles/585415/
> 
> Did you consider calling this `umask2`, having the initial version only support
> retrieving it via a UMASK_GET flag, and lay the groundwork to support
> setting a threadsafe umask with a UMASK_SET_THREAD flag?
> 

The comments on that article also list a number of problems with this
approach, related to how undefined flags are handled.

In fact, if it wasn't for this exact problem then umask(-1) would have
been the logical way to deal with this, but because umask(2) is defined
to have an internal & 07777 it becomes infeasible at least in theory.
In practice it might work...

However, see previous discussions about making this available in /proc.
 Also, I really think there is something to be said for a O_NOUMASK
option...

	-hpa
