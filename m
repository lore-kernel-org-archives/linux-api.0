From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at
 nptl init and thread creation (v4)
Date: Thu, 10 Jan 2019 15:31:55 -0500 (EST)
Message-ID: <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com> <87h8fkz6qx.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87h8fkz6qx.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 11, 2018, at 2:40 AM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>> I want to keep the __rseq_refcount symbol so out-of-libc users can
>> register rseq if they are linked against a pre-2.29 libc.
> 
> Sorry, I was confused.

Hi Florian,

Thanks for your questions below. Sorry for my delayed answer, I've
been preempted by vacation time. See more below,

> 
>> diff --git a/csu/Makefile b/csu/Makefile
>> index 88fc77662e..81d471587f 100644
>> --- a/csu/Makefile
>> +++ b/csu/Makefile
>> @@ -28,7 +28,7 @@ include ../Makeconfig
>>  
>>  routines = init-first libc-start $(libc-init) sysdep version check_fds \
>>  	   libc-tls elf-init dso_handle
>> -aux	 = errno
>> +aux	 = errno rseq
>>  elide-routines.os = libc-tls
>>  static-only-routines = elf-init
>>  csu-dummies = $(filter-out $(start-installed-name),crt1.o Mcrt1.o)
> 
> Do we plan to add Hurd support for this?

No.

A logical path where we could move rseq.c is under sysdeps/unix/sysv/linux/rseq.c.
This would allow the __rseq_abi symbol to be used from anywhere in glibc.

> 
>> diff --git a/sysdeps/unix/sysv/linux/rseq-internal.h
>> b/sysdeps/unix/sysv/linux/rseq-internal.h
>> new file mode 100644
>> index 0000000000..2367926def
>> --- /dev/null
>> +++ b/sysdeps/unix/sysv/linux/rseq-internal.h
> 
>> +#define RSEQ_SIG 0x53053053
> 
> What's this?  This needs a comment.

I will move it to an installed header (sysdeps/unix/sysv/linux/sys/rseq.h)
with the following comment:

/* Signature required before each abort handler code.  */
#define RSEQ_SIG 0x53053053

> 
>> +extern __thread volatile struct rseq __rseq_abi
>> +__attribute__ ((tls_model ("initial-exec")));
>> +
>> +extern __thread volatile uint32_t __rseq_refcount
>> +__attribute__ ((tls_model ("initial-exec")));
> 
> The volatile qualifier needs justification in a comment.  (Usually,
> volatile is wrong. and it is difficult to get rid of it.)
> 
> We need to document these public symbols somewhere.  There should be an
> installed header file.

Moving to sysdeps/unix/sysv/linux/sys/rseq.h with the following comments:

/* volatile because fields can be read/updated by the kernel.  */
extern __thread volatile struct rseq __rseq_abi
__attribute__ ((tls_model ("initial-exec")));

/* volatile because refcount can be read/updated by signal handlers.  */
extern __thread volatile uint32_t __rseq_refcount
__attribute__ ((tls_model ("initial-exec")));


> 
>> diff --git a/nptl/Versions b/nptl/Versions
>> index e7f691da7a..f7890f73fc 100644
>> --- a/nptl/Versions
>> +++ b/nptl/Versions
>> @@ -277,6 +277,10 @@ libpthread {
>>      cnd_timedwait; cnd_wait; tss_create; tss_delete; tss_get; tss_set;
>>    }
>>  
>> +  GLIBC_2.29 {
>> +    __rseq_refcount;
>> +  }
> 
> Why put this into libpthread, and __rseq_abi into libc?

The __rseq_abi symbol should be available to the glibc memory allocator.
I plan to move the __rseq_abi to sysdeps/unix/sysv/linux/Versions instead
so it becomes Linux-specific.

The __rseq_refcount symbol only needs to be made available to applications
and libraries linking against libpthread, because only libpthread actually
handles the rseq registration/unregistration at thread start/exit and
library initialization.

However, considering that we want this to be Linux-specific as well,
I could move it to sysdeps/unix/sysv/linux/Versions too.

Then it would make sense to move the __rseq_refcount symbol defined in
nptl/rseq.c to sysdeps/unix/sysv/linux/rseq.c as well and group
everything together.

Therefore, both symbols will end up in sysdeps/unix/sysv/linux/Versions.

> 
> What, exactly, is the benefit of having __rseq_refcount defined by
> glibc?  Have you actually got this working?  If an rseq library is
> linked against glibc 2.29, it will reference the GLIBC_2.29 symbol
> version, so it cannot be loaded by older glibcs.  In this case,
> __rseq_refcount is not needed.
> 
> If you build against pre-2.29, then the __rseq_refcount symbol will be
> unversioned.  But then you don't need it glibc, either.
> 
> So it seems to me that the addition to glibc is useless in both
> scenarios.  Am I missing something?

Here is the scenario where it becomes useful:

librseq is built against a pre-2.29 glibc. So the __rseq_refcount symbol
it emits is unversioned. Application is build against 2.29 glibc.
Application links both against librseq (itself built against pre-2.29 glibc)
and glibc (2.29).

In that scenario, librseq and glibc rely on a unique __rseq_refcount TLS
variable per process ensure that they don't register rseq twice for each thread.

> 
> By the way, you could avoid the need for unregistration if you allocated
> the rseq areas persistently, index by TID.  They are quite small, so
> with the typical PID range, maybe the wasted memory due to changing TIDs
> would be acceptable?

Would we be able to access those __rseq_abi as normal TLS IE model variables ?
The overhead of indexing an array matters for a fast-path.

> 
> I guess things would be so much easier if the kernel simply provided a
> means to obtain the address of a previously registered rseq area.

Even if the kernel did provide this (which is not part of the syscall ABI anyway),
I suspect we would need extra code on the fast-path to access the __rseq_abi
TLS, which I would very much like to avoid. But perhaps there are ways to do
this without extra overhead that are beyond my understanding of glibc handling
of TLS models.

I will soon post an updated patch set taking care of your comments.

Thanks!

Mathieu

> 
> Thanks,
> Florian

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
