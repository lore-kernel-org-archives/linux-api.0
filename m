From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 21:05:11 -0700
Message-ID: <CA+55aFxZo_K41mvgWzbHSnUSZd3SbH3F_PqWF9ZqK4shdqynVg@mail.gmail.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com> <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
 <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com> <20171014030116.GM2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171014030116.GM2482@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Ben Maurer <bmaurer@fb.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 13, 2017 at 8:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> As far as I can see the current model fundamentally only works for
> one user per process (because there is only a single range and abort IP)

No, it should work for libraries, you just need to always initialize
the proper start/commit/abort IP's for every transaction. Then
everybody should be fine.

So I _think_ it's all good. But I really would want to see that
actually being the case.

                Linus
