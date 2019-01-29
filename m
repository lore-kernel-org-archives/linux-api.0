From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C
 startup and thread creation (v6)
Date: Tue, 29 Jan 2019 11:57:39 -0500 (EST)
Message-ID: <632671842.3079.1548781059601.JavaMail.zimbra@efficios.com>
References: <20190121213530.23803-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190121213530.23803-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>
Cc: Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jan 21, 2019, at 4:35 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:
[...]

> diff --git a/sysdeps/unix/sysv/linux/sys/rseq.h
> b/sysdeps/unix/sysv/linux/sys/rseq.h
> new file mode 100644
> index 0000000000..61937fb193
> --- /dev/null
> +++ b/sysdeps/unix/sysv/linux/sys/rseq.h
> @@ -0,0 +1,64 @@

[...]
> +
> +#ifndef _SYS_RSEQ_H
> +#define _SYS_RSEQ_H	1
> +
> +/* We use the structures declarations from the kernel headers.  */
> +#include <linux/rseq.h>
> +#include <stdint.h>
> +
> +/* Signature required before each abort handler code.  */
> +#define RSEQ_SIG 0x53053053

I recalled that aarch64 defines RSEQ_SIG to a different value which maps to
a valid trap instruction. So I plan to move the RSEQ_SIG define to per-arch
headers like this:

 sysdeps/unix/sysv/linux/aarch64/bits/rseq.h                  |   24 ++
 sysdeps/unix/sysv/linux/arm/bits/rseq.h                      |   24 ++
 sysdeps/unix/sysv/linux/bits/rseq.h                          |   23 ++
 sysdeps/unix/sysv/linux/mips/bits/rseq.h                     |   24 ++
 sysdeps/unix/sysv/linux/powerpc/bits/rseq.h                  |   24 ++
 sysdeps/unix/sysv/linux/s390/bits/rseq.h                     |   24 ++
 sysdeps/unix/sysv/linux/x86/bits/rseq.h                      |   24 ++

where "bits/rseq.h" contains a #error:

# error "Architecture does not define RSEQ_SIG.

sys/rseq.h will now include <bits/rseq.h>.


> +
> +enum rseq_register_state
> +{
> +  /* Value RSEQ_REGISTER_ALLOWED means it is allowed to update
> +     the refcount field and to register/unregister rseq.  */
> +  RSEQ_REGISTER_ALLOWED = 0,
> +  /* Value RSEQ_REGISTER_NESTED means it is temporarily forbidden
> +     to update the refcount field or to register/unregister rseq.  */
> +  RSEQ_REGISTER_NESTED = 1,

I plan to rename "RSEQ_REGISTER_NESTED" to "RSEQ_REGISTER_ONGOING" which
seems to better represent the current registration state.

Please let me know if anything is wrong with those changes.

Thanks,

Mathieu


> +  /* Value RSEQ_REGISTER_EXITING means it is forbidden to update the
> +     refcount field or to register/unregister rseq for the rest of the
> +     thread's lifetime.  */
> +  RSEQ_REGISTER_EXITING = 2,
> +};
-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
