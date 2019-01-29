From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C
 startup and thread creation (v6)
Date: Tue, 29 Jan 2019 21:56:18 +0000
Message-ID: <alpine.DEB.2.21.1901292153190.24454@digraph.polyomino.org.uk>
References: <20190121213530.23803-1-mathieu.desnoyers@efficios.com> <632671842.3079.1548781059601.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <libc-alpha-return-99598-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <632671842.3079.1548781059601.JavaMail.zimbra@efficios.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, 29 Jan 2019, Mathieu Desnoyers wrote:

> I recalled that aarch64 defines RSEQ_SIG to a different value which maps to
> a valid trap instruction. So I plan to move the RSEQ_SIG define to per-arch
> headers like this:
> 
>  sysdeps/unix/sysv/linux/aarch64/bits/rseq.h                  |   24 ++
>  sysdeps/unix/sysv/linux/arm/bits/rseq.h                      |   24 ++
>  sysdeps/unix/sysv/linux/bits/rseq.h                          |   23 ++
>  sysdeps/unix/sysv/linux/mips/bits/rseq.h                     |   24 ++
>  sysdeps/unix/sysv/linux/powerpc/bits/rseq.h                  |   24 ++
>  sysdeps/unix/sysv/linux/s390/bits/rseq.h                     |   24 ++
>  sysdeps/unix/sysv/linux/x86/bits/rseq.h                      |   24 ++
> 
> where "bits/rseq.h" contains a #error:
> 
> # error "Architecture does not define RSEQ_SIG.
> 
> sys/rseq.h will now include <bits/rseq.h>.

We're trying to reduce the number of cases where most or all new glibc 
architecture ports need to provide a bits/ header, by making the generic 
headers handle the common case.  So a generic header with a #error, and 
lots of architecture-specific headers mostly with the same value for 
RSEQ_SIG, seems unfortunate.  I'd hope the generic header could use a 
generic value, with architecture-specific variants only for architectures 
with some reason for a different value.

-- 
Joseph S. Myers
joseph@codesourcery.com
