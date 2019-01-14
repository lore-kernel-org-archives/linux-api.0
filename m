From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at nptl init and thread creation (v4)
Date: Mon, 14 Jan 2019 20:37:01 +0100
Message-ID: <87y37n8202.fsf@oldenburg2.str.redhat.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com>
        <87h8fkz6qx.fsf@oldenburg2.str.redhat.com>
        <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
        <87fttv9iic.fsf@oldenburg2.str.redhat.com>
        <394676913.486.1547493757710.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <394676913.486.1547493757710.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Mon, 14 Jan 2019 14:22:37 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> ----- On Jan 14, 2019, at 10:55 AM, Florian Weimer fweimer@redhat.com wrote:
>
>> * Mathieu Desnoyers:
>> 
>>> Therefore, both symbols will end up in
>>> sysdeps/unix/sysv/linux/Versions.
>> 
>> I'm not sure what you mean by that.  The physical location in the
>> directory tree has little effect on which shared object the symbol is
>> placed in; that will need other changes.
>
> I'm currently moving the symbol definitions to csu/rseq-sym.c. On Linux,
> its content is overridden by a new sysdeps/unix/sysv/linux/rseq-sym.c
> which contains both __rseq_abi and __rseq_refcount symbols. On other
> platforms, it is a stub file.

You don't need a stub file if you use the “ifeq ($(subdir),csu)”
construct.

The other question is whether this belongs into the csu subdirectory.
Since TLS is not available in ld.so, the initialization would have to
happen rather late, after relocation, but before ELF constructors are
run.

(A side effect is that the rseq area would not be usable from IFUNC
resolvers.)

Thanks,
Florian
