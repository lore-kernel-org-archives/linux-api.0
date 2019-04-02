From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and thread creation (v7)
Date: Tue, 02 Apr 2019 09:08:04 +0200
Message-ID: <87pnq4zxyj.fsf@oldenburg2.str.redhat.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com>
	<20190212194253.1951-2-mathieu.desnoyers@efficios.com>
	<5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com>
	<1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
	<87lg0tosfz.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101109-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <87lg0tosfz.fsf@concordia.ellerman.id.au> (Michael Ellerman's
	message of "Tue, 02 Apr 2019 17:02:40 +1100")
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Carlos O'Donell <codonell@redhat.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatson@fb.co>m, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vge>
List-Id: linux-api@vger.kernel.org

* Michael Ellerman:

> I'm a bit vague on what we're trying to do here.
>
> But it seems like you want some sort of "eye catcher" prior to the branch?
>
> That value is a valid instruction on current CPUs (rlwimi.
> r5,r24,6,1,9), and even if it wasn't it could become one in future.
>
> If you change it to 0x8053530 that is both a valid instruction and is a
> nop (conditional trap immediate but with no conditions set).

I think we need something that is very unlikely to appear in the
instruction stream.  It's just a marker.  The instruction will never be
executed, and it does not have to be a trap, either (I believe that a
standard trap instruction would be a bad choice).

Thanks,
Florian
