From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Fri, 14 Jun 2019 08:55:10 -0400 (EDT)
Message-ID: <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <87wohzorj0.fsf@oldenburg2.str.redhat.com> <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com> <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com> <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com> <87ftocwkei.fsf@oldenburg2.str.redhat.com> <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com> <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <libc-alpha-return-102709-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 14, 2019, at 1:35 PM, Florian Weimer fweimer@redhat.com wrote:

> * Mathieu Desnoyers:
> 
>> * Makefile:
>>
>> LIBCPATH=/home/efficios/glibc-test/lib
>> KERNEL_HEADERS=/home/efficios/git/linux-percpu-dev/usr/include
>> CFLAGS=-I${KERNEL_HEADERS} -L${LIBCPATH} -Wl,--rpath=${LIBCPATH}
>> -Wl,--dynamic-linker=${LIBCPATH}/ld-linux-x86-64.so.2
>>
>> all:
>> 	gcc ${CFLAGS} -o a a.c
>> 	gcc ${CFLAGS} -shared -fPIC -o s.so s.c
> 
> For me, that does not correctly link against the built libc because the
> system dynamic loader seeps into the link.

I have the same issue. I tried adding "-B${LIBCPATH}" as well, but it did
not seem to help. I still have this ldd output:

ldd a
./a: /lib64/ld-linux-x86-64.so.2: version `GLIBC_2.30' not found (required by ./a)
	linux-vdso.so.1 (0x00007fffaa7e9000)
	libc.so.6 => /home/efficios/glibc-test/lib/libc.so.6 (0x00007fac5d479000)
	/home/efficios/glibc-test/lib/ld-linux-x86-64.so.2 => /lib64/ld-linux-x86-64.so.2 (0x00007fac5da33000)

Still no luck there. Any idea what compiler/linker flag I am missing ?

> 
>> specifically this commit:
>> https://github.com/compudj/glibc-dev/commit/c49a286497d065a7fc00aafd846e6edce14f97fc
> 
> This commit links __rseq_handled into libc.so.6 via rseq-sym.c, but does
> not export it from there.

Moving __rseq_handled to elf/dl-support.c and elf/rtld.c was part a commit on top.
I've force-pushed on the dev branch, and the commit moving __rseq_handled to the
dynamic linker it now appears as:
https://github.com/compudj/glibc-dev/commit/f0d4e60e5d0ceb0c2642f99da5af61b6ad988531

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
