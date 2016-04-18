From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Sun, 17 Apr 2016 19:37:22 -0700
Message-ID: <20160418023721.GA17282@x>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <2143735451.55767.1460561962122.JavaMail.zimbra@efficios.com>
 <1736004700.56566.1460581285951.JavaMail.zimbra@efficios.com>
 <20160414021348.GB16656@thunk.org>
 <57142C80.6070005@zytor.com>
 <20160418010925.GA7800@kroah.com>
 <20160418021259.GB16600@x>
 <57144343.4090402@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57144343.4090402@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Theodore Ts'o <tytso@mit.edu>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>, luto@kernel.org, viro@zeniv.linux.org.uk, zab <zab@redhat.com>, emunson@akamai.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, sfr@canb.auug.org.au, Milosz Tanski <milosz@adfin.com>, rostedt <rostedt@goodmis.org>, arnd@arndb.de, ebiederm@xmission.com, gorcunov <gorcunov@openvz.org>, iulia manda21 <iulia.manda21@gmail.com>, dave hansen <dave.hansen@linux.intel.com>, mguzik <mguzik@redhat.com>, adobriyan@gmail.com, Davidlohr Bueso <dave@stgolabs.net>, linux-api <linux-api@vger.kernel.org>gorcunov
List-Id: linux-api@vger.kernel.org

On Sun, Apr 17, 2016 at 07:15:31PM -0700, H. Peter Anvin wrote:
> On 04/17/16 19:12, Josh Triplett wrote:
> >>
> >> I really like the 'libinux' idea, did anyone every hack up a first-pass
> >> at this?  And I'm guessing we have more syscalls now that would need to
> >> be added (like getrandom(), but that shouldn't be too difficult.
> > 
> > Personally, I'd suggest that libinux should wire up *all* (non-obsolete)
> > syscalls, not just those that haven't already been exposed via any
> > particular libc implementation.  Each such syscall function would have
> > minimal overhead, since unlike libc these wrappers would not have any
> > special handling (other than use of the vdso) and would directly map to
> > the kernel syscall signature.  Given a standard prefix like sys_ or
> > linux_, that would provide a clear distinction between direct-syscall
> > functions and libc functions, and avoid any future conflict if libc adds
> > a function named the same as the syscall.
> > 
> > As a random example, sys_getpid() would *always* call the getpid
> > syscall, rather than reading a cache within the library.  (And
> > sys_gettid would call the gettid syscall, rather than failing to exist.)
> 
> I'm not so sure this is a good idea.  It has definite pros and cons.  In
> some ways it pushes it more to be like syscall(3).

It seems like one of the main problems with syscall() is that it forces
userspace to handle weird ABI issues, such as syscall numbers varying by
architecture, encoding of 64-bit arguments on 32-bit platforms (see the
example in the syscall manpage), and other subtleties that will break on
architectures other than the one the developer is most likely to be
running.  libinux bindings would eliminate those issues.

What cases do you have in mind where the libinux binding should look
different than the C API of the SYSCALL_DEFINE'd function in the kernel?

Users can still call the libc syscall when they want libc's behavior;
for syscalls that have a libc binding, most users will want that
version.  But I've often needed to call the underlying syscall even for
syscalls that *do* have a libc binding, for various purposes, and having
a standard way to do that while still having safe type signatures seems
helpful.

This would also make it much easier to write an alternative libc, or a
language standard library that doesn't want to depend on libc.

- Josh Triplett
