From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Thu, 20 Sep 2018 20:20:28 +0000
Message-ID: <alpine.DEB.2.21.1809202016270.17228@digraph.polyomino.org.uk>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <alpine.DEB.2.21.1809191630260.26757@digraph.polyomino.org.uk> <67473000.8399.1537375994645.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1809191706090.26757@digraph.polyomino.org.uk>
 <1619649568.9014.1537474457166.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1619649568.9014.1537474457166.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, 20 Sep 2018, Mathieu Desnoyers wrote:

> Are you saying glibc has an explicit check for the kernel version visible
> from /proc before using specific features ? If so, how can this work with
> the variety of feature backports we find in the distribution kernels out
> there ?

See sysdeps/unix/sysv/linux/dl-sysdep.c and 
sysdeps/unix/sysv/linux/dl-osinfo.h.  As I said, Carlos has proposed 
removing that check.

> For too-old headers at compile time, one possibility is that we don't event
> expose the __rseq_abi TLS symbol. OTOH, if we need to keep exposing it anyway
> for ABI consistency purposes, then we'd leave its cpu_id field at the initial
> value (-1). But that would require that we copy linux/rseq.h into the glibc
> source tree.

The ABI needs to be independent of the kernel headers used.  I don't think 
you need to copy linux/rseq.h; all you should need is to e.g. define an 
array of suitable size and alignment with the relevant member initialized 
and a suitable explanatory comment.

-- 
Joseph S. Myers
joseph@codesourcery.com
