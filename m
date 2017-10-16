From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Mon, 16 Oct 2017 09:46:01 -0700
Message-ID: <20171016164600.GO2482@two.firstfloor.org>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
 <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
 <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com>
 <20171013205418.GM3521@linux.vnet.ibm.com>
 <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com>
 <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com>
 <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Ben Maurer <bmaurer@fb.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, rostedt <rostedt@goodmis.org>
List-Id: linux-api@vger.kernel.org

> How you collect, summarize, and analyze that overwhelming evidence
> is up to you, specific to each change, and difficult to do accurately
> and with any large measure of statistical confidence. The reviewer
> has to basically trust you to some degree :-)

I think Linus' just asked for some working "real world, not micro" code that
demonstrates use.

A prototype type implementation of the glibc malloc cache using this may
be good enough.

Even if the API still changes slightly later in review I would assume
the basic concepts will stay the same, so it would be likely not
too difficult to convert that prototype to the later final API.

-Andi
