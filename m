From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Fri, 23 Nov 2018 18:39:04 +0100
Message-ID: <87zhtzsngn.fsf@oldenburg.str.redhat.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
        <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
        <87wop5xeit.fsf@oldenburg.str.redhat.com>
        <1045257294.10291.1542905262086.JavaMail.zimbra@efficios.com>
        <87k1l5xd33.fsf@oldenburg.str.redhat.com>
        <20181122171010.GH23599@brightrain.aerifal.cx>
        <871s7cvt1l.fsf@oldenburg.str.redhat.com>
        <20181123142843.GJ23599@brightrain.aerifal.cx>
        <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
        <20181123173019.GK23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181123173019.GK23599@brightrain.aerifal.cx> (Rich Felker's
        message of "Fri, 23 Nov 2018 12:30:19 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Rich Felker:

> On Fri, Nov 23, 2018 at 12:05:20PM -0500, Mathieu Desnoyers wrote:
>> There has been presumptions about signals being blocked when the thread
>> exits throughout this email thread. Out of curiosity, what code is
>> responsible for disabling signals in this situation ? Related to this,
>> is it valid to access a IE model TLS variable from a signal handler at
>> _any_ point where the signal handler nests over thread's execution ?
>> This includes early start and just before invoking the exit system call.
>
> It should be valid to access *any* TLS object like this, but the
> standards don't cover it well.

C++ makes it undefined:

  <http://eel.is/c++draft/support.signal#def:evaluation,signal-safe>

Thanks,
Florian
