From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Fri, 14 Jun 2019 15:09:27 +0200
Message-ID: <87d0jguxdk.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <c16c9785-7f8c-430b-a4df-a53e47bf1600@redhat.com>
        <914051741.43025.1560348011775.JavaMail.zimbra@efficios.com>
        <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com>
        <87ftocwkei.fsf@oldenburg2.str.redhat.com>
        <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
        <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
        <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
        <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 14 Jun 2019 09:01:41 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> But my original issue remains: if I define a variable called __rseq_handled
> within either the main executable or the preloaded library, it overshadows
> the libc one:
>
> efficios@compudjdev:~/test/libc-sym$ ./a
> __rseq_handled main: 0 0x56135fd5102c
> __rseq_abi.cpu_id main: 29 0x7fcbeca6d5a0
> efficios@compudjdev:~/test/libc-sym$ LD_PRELOAD=./s.so ./a
> __rseq_handled s.so: 0 0x558f70aeb02c
> __rseq_abi.cpu_id s.so: -1 0x7fdca78b7760
> __rseq_handled main: 0 0x558f70aeb02c
> __rseq_abi.cpu_id main: 27 0x7fdca78b7760
>
> Which is unexpected.

Why is this unexpected?  It has to be this way if the main program uses
a copy relocation of __rseq_handled.  As long as there is just one
address across the entire program and ld.so initializes the copy of the
variable that is actually used, everything will be fine.

Thanks,
Florian
