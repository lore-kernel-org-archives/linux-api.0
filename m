From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Wed, 19 Sep 2018 17:10:08 +0000
Message-ID: <alpine.DEB.2.21.1809191706090.26757@digraph.polyomino.org.uk>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1809191630260.26757@digraph.polyomino.org.uk> <67473000.8399.1537375994645.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <67473000.8399.1537375994645.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 19 Sep 2018, Mathieu Desnoyers wrote:

> > This looks like it's coming from the Linux kernel.  Can't the relevant
> > uapi header just be used directly without copying into glibc (with due
> > care to ensure that glibc still builds if the kernel headers used for the
> > build are too old - you need such conditionals anyway if they don't define
> > the relevant syscall number)?
> 
> This is indeed in the list of "things to consider" I've put in the patch
> commit message. If the usual practice is to build against uapi kernel headers
> outside of the glibc tree, I'm fine with that.

We build with, currently, 3.2 or later headers (since 3.2 is EOL there's a 
case for updating the minimum in glibc for both compile time and runtime, 
but I haven't proposed that since there isn't much cleanup that would 
enable and there's the open question of Carlos's proposal to eliminate the 
runtime check on the kernel version and just let things try to run anyway 
even if it's older than the configured minimum).  Functions depending on 
new syscalls may return ENOSYS errors if the headers used to build glibc 
were too old.  Since this patch is providing a data interface rather than 
functions that can set errno to ENOSYS, presumably you have some other way 
of signalling unavailability which would apply both with a too-old kernel 
at runtime and too-old headers at compile time.

-- 
Joseph S. Myers
joseph@codesourcery.com
