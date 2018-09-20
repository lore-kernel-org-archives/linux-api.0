From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Thu, 20 Sep 2018 20:29:43 +0000
Message-ID: <alpine.DEB.2.21.1809202028120.17228@digraph.polyomino.org.uk>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1809191630260.26757@digraph.polyomino.org.uk> <381061785.8994.1537473866841.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <381061785.8994.1537473866841.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Sep 2018, Mathieu Desnoyers wrote:

> Something like this in pthreadP.h ?
> 
> +#ifdef __NR_rseq
> +#include <sysdeps/unix/sysv/linux/rseq-internal.h>
> +#else
> +#include <sysdeps/nptl/rseq-internal.h>
> +#endif  /* __NR_rseq.  */
> 
> where sysdeps/unix/sysv/linux/rseq-internal.h contains the linux
> implementation of rseq_register_current_thread () and
> rseq_unregister_current_thread (), and sysdeps/nptl/rseq-internal.h
> contains stubs.
> 
> Am I on the right track ?

It's hard to define the right abstractions for what goes where given that 
only Linux uses NPTL since the removal of the NaCl port.  I suppose it 
does make logical sense for a #include of <linux/rseq.h> to go somewhere 
under sysdeps/unix/sysv/linux/.

-- 
Joseph S. Myers
joseph@codesourcery.com
