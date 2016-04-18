From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] vfs: Define new syscall getumask.
Date: Sun, 17 Apr 2016 20:00:54 -0700
Message-ID: <57144DE6.9050409@zytor.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <2143735451.55767.1460561962122.JavaMail.zimbra@efficios.com>
 <1736004700.56566.1460581285951.JavaMail.zimbra@efficios.com>
 <20160414021348.GB16656@thunk.org> <57142C80.6070005@zytor.com>
 <20160418010925.GA7800@kroah.com> <20160418021259.GB16600@x>
 <57144343.4090402@zytor.com> <20160418023721.GA17282@x>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160418023721.GA17282@x>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Theodore Ts'o <tytso@mit.edu>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Richard W.M. Jones" <rjones@redhat.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>, luto@kernel.org, viro@zeniv.linux.org.uk, zab <zab@redhat.com>, emunson@akamai.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>, Pavel Emelyanov <xemul@parallels.com>, sfr@canb.auug.org.au, Milosz Tanski <milosz@adfin.com>, rostedt <rostedt@goodmis.org>, arnd@arndb.de, ebiederm@xmission.com, gorcunov <gorcunov@openvz.org>, iulia manda21 <iulia.manda21@gmail.com>, dave hansen <dave.hansen@linux.intel.com>, mguzik <mguzik@redhat.com>, adobriyan@gmail.com, Davidlohr Bueso <dave@stgolabs.net>, linux-api <linux-api@vger.kernel.org>gorcun
List-Id: linux-api@vger.kernel.org

On 04/17/16 19:37, Josh Triplett wrote:
> 
> It seems like one of the main problems with syscall() is that it forces
> userspace to handle weird ABI issues, such as syscall numbers varying by
> architecture, encoding of 64-bit arguments on 32-bit platforms (see the
> example in the syscall manpage), and other subtleties that will break on
> architectures other than the one the developer is most likely to be
> running.  libinux bindings would eliminate those issues.
> 
> What cases do you have in mind where the libinux binding should look
> different than the C API of the SYSCALL_DEFINE'd function in the kernel?
> 
> Users can still call the libc syscall when they want libc's behavior;
> for syscalls that have a libc binding, most users will want that
> version.  But I've often needed to call the underlying syscall even for
> syscalls that *do* have a libc binding, for various purposes, and having
> a standard way to do that while still having safe type signatures seems
> helpful.
> 
> This would also make it much easier to write an alternative libc, or a
> language standard library that doesn't want to depend on libc.
> 

The main problem has to do with types, and the fact that the C library
may want to intersperse itself around system calls.  If people start
writing programs that call, say, __linux_umask() then it would make it
hard for libc to do something special with umask().

There are other things like it, e.g. where dev_t and __kernel_dev_t are
concerned.

Now, we could of course have __linux_getrandom() and make a weak alias
for getrandom(), but I really don't understand the use case for
exporting all the system calls.

	-hpa
