From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 20:01:16 -0700
Message-ID: <20171014030116.GM2482@two.firstfloor.org>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
 <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
 <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Maurer <bmaurer@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>Andrew
List-Id: linux-api@vger.kernel.org

> That sounds so obvious and stupid that you might go "What do you
> mean?", but for things to work for libraries, they have to work
> together with *other* users, and with *independent* users.

As far as I can see the current model fundamentally only works for
one user per process (because there is only a single range and abort IP) 

So once malloc started using it noone else could.

Since malloc is the primary user it would be pointless to ever
try it on something else.

It seems fixing that would complicate everything quite a bit --
all ranges would need to be (unlimited?) arrays.

-Andi
