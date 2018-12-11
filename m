From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at nptl init and thread creation (v4)
Date: Tue, 11 Dec 2018 11:40:22 +0100
Message-ID: <87h8fkz6qx.fsf@oldenburg2.str.redhat.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Carlos O'Donell <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> I want to keep the __rseq_refcount symbol so out-of-libc users can
> register rseq if they are linked against a pre-2.29 libc.

Sorry, I was confused.

> diff --git a/csu/Makefile b/csu/Makefile
> index 88fc77662e..81d471587f 100644
> --- a/csu/Makefile
> +++ b/csu/Makefile
> @@ -28,7 +28,7 @@ include ../Makeconfig
>  
>  routines = init-first libc-start $(libc-init) sysdep version check_fds \
>  	   libc-tls elf-init dso_handle
> -aux	 = errno
> +aux	 = errno rseq
>  elide-routines.os = libc-tls
>  static-only-routines = elf-init
>  csu-dummies = $(filter-out $(start-installed-name),crt1.o Mcrt1.o)

Do we plan to add Hurd support for this?

> diff --git a/sysdeps/unix/sysv/linux/rseq-internal.h b/sysdeps/unix/sysv/linux/rseq-internal.h
> new file mode 100644
> index 0000000000..2367926def
> --- /dev/null
> +++ b/sysdeps/unix/sysv/linux/rseq-internal.h

> +#define RSEQ_SIG 0x53053053

What's this?  This needs a comment.

> +extern __thread volatile struct rseq __rseq_abi
> +__attribute__ ((tls_model ("initial-exec")));
> +
> +extern __thread volatile uint32_t __rseq_refcount
> +__attribute__ ((tls_model ("initial-exec")));

The volatile qualifier needs justification in a comment.  (Usually,
volatile is wrong. and it is difficult to get rid of it.)

We need to document these public symbols somewhere.  There should be an
installed header file.

> diff --git a/nptl/Versions b/nptl/Versions
> index e7f691da7a..f7890f73fc 100644
> --- a/nptl/Versions
> +++ b/nptl/Versions
> @@ -277,6 +277,10 @@ libpthread {
>      cnd_timedwait; cnd_wait; tss_create; tss_delete; tss_get; tss_set;
>    }
>  
> +  GLIBC_2.29 {
> +    __rseq_refcount;
> +  }

Why put this into libpthread, and __rseq_abi into libc?

What, exactly, is the benefit of having __rseq_refcount defined by
glibc?  Have you actually got this working?  If an rseq library is
linked against glibc 2.29, it will reference the GLIBC_2.29 symbol
version, so it cannot be loaded by older glibcs.  In this case,
__rseq_refcount is not needed.

If you build against pre-2.29, then the __rseq_refcount symbol will be
unversioned.  But then you don't need it glibc, either.

So it seems to me that the addition to glibc is useless in both
scenarios.  Am I missing something?

By the way, you could avoid the need for unregistration if you allocated
the rseq areas persistently, index by TID.  They are quite small, so
with the typical PID range, maybe the wasted memory due to changing TIDs
would be acceptable?

I guess things would be so much easier if the kernel simply provided a
means to obtain the address of a previously registered rseq area.

Thanks,
Florian
