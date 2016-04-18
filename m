From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Sun, 17 Apr 2016 19:15:31 -0700
Message-ID: <57144343.4090402@zytor.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <2143735451.55767.1460561962122.JavaMail.zimbra@efficios.com>
 <1736004700.56566.1460581285951.JavaMail.zimbra@efficios.com>
 <20160414021348.GB16656@thunk.org> <57142C80.6070005@zytor.com>
 <20160418010925.GA7800@kroah.com> <20160418021259.GB16600@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160418021259.GB16600@x>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "Richard W.M. Jones" <rjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zab <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, Milosz Tanski <milosz-B5zB6C1i6pkAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, iulia manda21 <iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dave hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, mguzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, fw-d32yF4oPJVt0XxTmqZlbVQ@public.gmane.org, Linus
List-Id: linux-api@vger.kernel.org

On 04/17/16 19:12, Josh Triplett wrote:
>>
>> I really like the 'libinux' idea, did anyone every hack up a first-pass
>> at this?  And I'm guessing we have more syscalls now that would need to
>> be added (like getrandom(), but that shouldn't be too difficult.
> 
> Personally, I'd suggest that libinux should wire up *all* (non-obsolete)
> syscalls, not just those that haven't already been exposed via any
> particular libc implementation.  Each such syscall function would have
> minimal overhead, since unlike libc these wrappers would not have any
> special handling (other than use of the vdso) and would directly map to
> the kernel syscall signature.  Given a standard prefix like sys_ or
> linux_, that would provide a clear distinction between direct-syscall
> functions and libc functions, and avoid any future conflict if libc adds
> a function named the same as the syscall.
> 
> As a random example, sys_getpid() would *always* call the getpid
> syscall, rather than reading a cache within the library.  (And
> sys_gettid would call the gettid syscall, rather than failing to exist.)
> 

I'm not so sure this is a good idea.  It has definite pros and cons.  In
some ways it pushes it more to be like syscall(3).

	-hpa
