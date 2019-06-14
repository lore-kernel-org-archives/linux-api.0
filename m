From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v10)
Date: Fri, 14 Jun 2019 09:01:41 -0400 (EDT)
Message-ID: <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com> <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com> <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com> <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com> <87ftocwkei.fsf@oldenburg2.str.redhat.com> <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com> <87tvcsv1pk.fsf@oldenburg2.str.redhat.com> <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Jun 14, 2019, at 2:55 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Jun 14, 2019, at 1:35 PM, Florian Weimer fweimer@redhat.com wrote:
> 
>> * Mathieu Desnoyers:
>> 
>>> * Makefile:
>>>
>>> LIBCPATH=/home/efficios/glibc-test/lib
>>> KERNEL_HEADERS=/home/efficios/git/linux-percpu-dev/usr/include
>>> CFLAGS=-I${KERNEL_HEADERS} -L${LIBCPATH} -Wl,--rpath=${LIBCPATH}
>>> -Wl,--dynamic-linker=${LIBCPATH}/ld-linux-x86-64.so.2
>>>
>>> all:
>>> 	gcc ${CFLAGS} -o a a.c
>>> 	gcc ${CFLAGS} -shared -fPIC -o s.so s.c
>> 
>> For me, that does not correctly link against the built libc because the
>> system dynamic loader seeps into the link.
> 
> I have the same issue. I tried adding "-B${LIBCPATH}" as well, but it did
> not seem to help. I still have this ldd output:
> 
> ldd a
> ./a: /lib64/ld-linux-x86-64.so.2: version `GLIBC_2.30' not found (required by
> ./a)
>	linux-vdso.so.1 (0x00007fffaa7e9000)
>	libc.so.6 => /home/efficios/glibc-test/lib/libc.so.6 (0x00007fac5d479000)
>	/home/efficios/glibc-test/lib/ld-linux-x86-64.so.2 =>
>	/lib64/ld-linux-x86-64.so.2 (0x00007fac5da33000)
> 
> Still no luck there. Any idea what compiler/linker flag I am missing ?
> 

Actually, even though ldd seems confused, running the program seems to
use the right ld.so:

efficios@compudjdev:~/test/libc-sym$ ./a
__rseq_handled main: 1 0x55f0ec915020
__rseq_abi.cpu_id main: 28 0x7f54f6c2d4c0
efficios@compudjdev:~/test/libc-sym$ LD_PRELOAD=./s.so ./a
__rseq_handled s.so: 1 0x557350bc6020
__rseq_abi.cpu_id s.so: -1 0x7fe2f30f2680
__rseq_handled main: 1 0x557350bc6020
__rseq_abi.cpu_id main: 27 0x7fe2f30f2680

But my original issue remains: if I define a variable called __rseq_handled
within either the main executable or the preloaded library, it overshadows
the libc one:

efficios@compudjdev:~/test/libc-sym$ ./a
__rseq_handled main: 0 0x56135fd5102c
__rseq_abi.cpu_id main: 29 0x7fcbeca6d5a0
efficios@compudjdev:~/test/libc-sym$ LD_PRELOAD=./s.so ./a
__rseq_handled s.so: 0 0x558f70aeb02c
__rseq_abi.cpu_id s.so: -1 0x7fdca78b7760
__rseq_handled main: 0 0x558f70aeb02c
__rseq_abi.cpu_id main: 27 0x7fdca78b7760

Which is unexpected.

This is with my dev branch at this commit:

https://github.com/compudj/glibc-dev/commit/f0d4e60e5d0ceb0c2642f99da5af61b6ad988531

What am I missing ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
