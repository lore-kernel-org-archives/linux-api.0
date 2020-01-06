From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Date: Mon, 06 Jan 2020 20:30:06 +0100
Message-ID: <87a7709ydd.fsf@mid.deneb.enyo.de>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com>
        <87imman36g.fsf@mid.deneb.enyo.de>
        <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com>
        <875zian2a2.fsf@mid.deneb.enyo.de>
        <669061171.14506.1576876500152.JavaMail.zimbra@efficios.com>
        <1025393027.850.1578337717165.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1025393027.850.1578337717165.JavaMail.zimbra@efficios.com>
        (Mathieu Desnoyers's message of "Mon, 6 Jan 2020 14:08:37 -0500
        (EST)")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, paulmck <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>, stable <stable@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Neel Natu <neelnatu@google.com>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> Just to clarify: should the discussion here prevent the UAPI
> documentation change from being merged into the Linux kernel ? Our
> discussion seems to be related to integration of rseq into glibc,
> rather than the kernel UAPI per se.

I still think that clearing rseq_cs upon exit from the function that
contains the sequence is good practice, and the UAPI header should
mention that.

For glibc, if I recall correctly, we decided against doing anything in
dlclose to deal with this issue (remapping new code in an existing
rseq area) because it would need updating all threads, not just the
thread calling dlclose.  That's why we're punting this to
applications and why I think the UAPI header should mention this.
