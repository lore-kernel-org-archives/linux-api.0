From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup and thread creation (v10)
Date: Fri, 14 Jun 2019 15:24:24 +0200
Message-ID: <87wohoti47.fsf@oldenburg2.str.redhat.com>
References: <20190503184219.19266-1-mathieu.desnoyers@efficios.com>
        <802638054.3032.1560506584705.JavaMail.zimbra@efficios.com>
        <87ftocwkei.fsf@oldenburg2.str.redhat.com>
        <1635690189.3049.1560507249693.JavaMail.zimbra@efficios.com>
        <87tvcsv1pk.fsf@oldenburg2.str.redhat.com>
        <1190407525.3131.1560516910936.JavaMail.zimbra@efficios.com>
        <1085273942.3137.1560517301721.JavaMail.zimbra@efficios.com>
        <87d0jguxdk.fsf@oldenburg2.str.redhat.com>
        <1779359826.3226.1560518318701.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1779359826.3226.1560518318701.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Fri, 14 Jun 2019 09:18:38 -0400
        (EDT)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> ----- On Jun 14, 2019, at 3:09 PM, Florian Weimer fweimer@redhat.com wrote:
>
>> * Mathieu Desnoyers:
>> 
>>> But my original issue remains: if I define a variable called __rseq_handled
>>> within either the main executable or the preloaded library, it overshadows
>>> the libc one:
>>>
>>> efficios@compudjdev:~/test/libc-sym$ ./a
>>> __rseq_handled main: 0 0x56135fd5102c
>>> __rseq_abi.cpu_id main: 29 0x7fcbeca6d5a0
>>> efficios@compudjdev:~/test/libc-sym$ LD_PRELOAD=./s.so ./a
>>> __rseq_handled s.so: 0 0x558f70aeb02c
>>> __rseq_abi.cpu_id s.so: -1 0x7fdca78b7760
>>> __rseq_handled main: 0 0x558f70aeb02c
>>> __rseq_abi.cpu_id main: 27 0x7fdca78b7760
>>>
>>> Which is unexpected.
>> 
>> Why is this unexpected?  It has to be this way if the main program uses
>> a copy relocation of __rseq_handled.  As long as there is just one
>> address across the entire program and ld.so initializes the copy of the
>> variable that is actually used, everything will be fine.
>
> Here is a printout of the __rseq_handled address observed by ld.so, it
> does not match:
>
> LD_PRELOAD=./s.so ./a
> elf: __rseq_handled addr: 7f501c98a140
> __rseq_handled s.so: 0 0x55817a88d02c
> __rseq_abi.cpu_id s.so: -1 0x7f501c983760
> __rseq_handled main: 0 0x55817a88d02c
> __rseq_abi.cpu_id main: 27 0x7f501c983760

Where do you print the address?  Before or after the self-relocation of
the dynamic loader?  The address is only correct after self-relocation.

Thanks,
Florian
