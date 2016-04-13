From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH v2 1/2] vfs: Define new syscall getumask.
Date: Wed, 13 Apr 2016 14:57:08 +0100
Message-ID: <20160413135708.GG11600@redhat.com>
References: <1460552272-15985-1-git-send-email-rjones@redhat.com>
 <1460552272-15985-2-git-send-email-rjones@redhat.com>
 <20160413132031.GJ2000@uranus.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160413132031.GJ2000@uranus.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, sfr@canb.auug.org.au, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, fw@deneb.enyo.de
List-Id: linux-api@vger.kernel.org

On Wed, Apr 13, 2016 at 04:20:32PM +0300, Cyrill Gorcunov wrote:
> On Wed, Apr 13, 2016 at 01:57:51PM +0100, Richard W.M. Jones wrote:
> > Define a system call for reading the current umask value.
> > 
> > Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> 
> Btw don't we have to declare it in include/uapi/asm-generic/unistd.h as well?

Yes, I think I do.  I was following pwritev2 which wasn't added
to this file, but other recent system calls (mlock2, copy_file_range)
were added.

TBH the documentation for this file is not very clear...

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
