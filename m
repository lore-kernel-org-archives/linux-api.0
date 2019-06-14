From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Fri, 14 Jun 2019 13:35:51 +0200
Message-ID: <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <87o93d4lqb.fsf@oldenburg2.str.redhat.com>
        <117220011.27079.1559663870037.JavaMail.zimbra@efficios.com>
        <87wohzorj0.fsf@oldenburg2.str.redhat.com>
        <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com>
        <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com>
        <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com>
        <87ftocwkei.fsf@oldenburg2.str.redhat.com>
        <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 14 Jun 2019 06:14:09 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> * Makefile:
>
> LIBCPATH=/home/efficios/glibc-test/lib
> KERNEL_HEADERS=/home/efficios/git/linux-percpu-dev/usr/include
> CFLAGS=-I${KERNEL_HEADERS} -L${LIBCPATH} -Wl,--rpath=${LIBCPATH} -Wl,--dynamic-linker=${LIBCPATH}/ld-linux-x86-64.so.2
>
> all:
> 	gcc ${CFLAGS} -o a a.c
> 	gcc ${CFLAGS} -shared -fPIC -o s.so s.c

For me, that does not correctly link against the built libc because the
system dynamic loader seeps into the link.

> specifically this commit:
> https://github.com/compudj/glibc-dev/commit/c49a286497d065a7fc00aafd846e6edce14f97fc

This commit links __rseq_handled into libc.so.6 via rseq-sym.c, but does
not export it from there.

Thanks,
Florian
