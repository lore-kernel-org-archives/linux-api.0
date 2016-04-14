From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH v4 0/3] vfs: Define new syscall umask2 [formerly getumask]
Date: Thu, 14 Apr 2016 10:15:47 +0100
Message-ID: <20160414091547.GB28599@redhat.com>
References: <1460574336-18930-1-git-send-email-rjones@redhat.com>
 <20160414090938.44c56c78@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414090938.44c56c78@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, viro@zeniv.linux.org.uk, mathieu.desnoyers@efficios.com, zab@redhat.com, emunson@akamai.com, paulmck@linux.vnet.ibm.com, aarcange@redhat.com, josh@joshtriplett.org, xemul@parallels.com, milosz@adfin.com, rostedt@goodmis.org, arnd@arndb.de, ebiederm@xmission.com, gorcunov@openvz.org, iulia.manda21@gmail.com, dave.hansen@linux.intel.com, mguzik@redhat.com, adobriyan@gmail.com, dave@stgolabs.net, linux-api@vger.kernel.org, gorcunov@gmail.com, fw@deneb.enyo.de, walters@verbum.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 14, 2016 at 09:09:38AM +1000, Stephen Rothwell wrote:
> Hi Richard,
> 
> On Wed, 13 Apr 2016 20:05:33 +0100 "Richard W.M. Jones" <rjones@redhat.com> wrote:
> >
> > It's not possible to read the process umask without also modifying it,
> > which is what umask(2) does.  A library cannot read umask safely,
> > especially if the main program might be multithreaded.
> 
> I was wondering if you really need to read the umask, or would just a
> "ignore umask" flag to open{,at} do what you want?

This would be very useful, although I think being able to read umask
is also useful.

---

FWIW I am currently developing a patch to add umask to
/proc/PID/status.  Will post it shortly once I've tested it properly.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
