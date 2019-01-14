From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at nptl init and thread creation (v4)
Date: Mon, 14 Jan 2019 19:55:07 +0100
Message-ID: <87fttv9iic.fsf@oldenburg2.str.redhat.com>
References: <20181204192141.4684-1-mathieu.desnoyers@efficios.com>
        <87h8fkz6qx.fsf@oldenburg2.str.redhat.com>
        <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1681283664.1380.1547152315426.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Thu, 10 Jan 2019 15:31:55 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Therefore, both symbols will end up in
> sysdeps/unix/sysv/linux/Versions.

I'm not sure what you mean by that.  The physical location in the
directory tree has little effect on which shared object the symbol is
placed in; that will need other changes.

>> By the way, you could avoid the need for unregistration if you allocated
>> the rseq areas persistently, index by TID.  They are quite small, so
>> with the typical PID range, maybe the wasted memory due to changing TIDs
>> would be acceptable?
>
> Would we be able to access those __rseq_abi as normal TLS IE model
> variables ?  The overhead of indexing an array matters for a
> fast-path.

No, that wouldn't be possible in this case.  You would need another
indirection.

Thanks,
Florian
