From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [ANNOUNCE] New linux-rseq tree on kernel.org
Date: Tue, 17 Oct 2017 19:25:59 +0000 (UTC)
Message-ID: <817181118.43238.1508268359153.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Maurer <bmaurer@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>Boqun Feng <b>
Cc: linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi,

I have created a linux-rseq tree on kernel.org to make it easier for
developers of userspace applications and libraries to try out Restartable
Sequences. It is available at

  https://git.kernel.org/pub/scm/linux/kernel/git/rseq/linux-rseq.git/

The volatile branch "rseq/dev" is the ongoing development. It will
be periodically rebased on the latest tags from Linus.

I will also push tags from time to time. I just created a tag
including changes based on feedback from the past few days as:

  v4.14-rc5-rseq-20171017

Note that the system call numbers currently used may have to be
bumped whenever rebasing onto a new tag from Linus. Thus, when
updating to a newer tag, it is important to refresh kernel headers
with e.g.
"rm -rf /path_to_kernel/usr/include/ && cd /path_to_kernel && make headers_install"
and build your application with -I/path_to_kernel/usr/include
so the right kernel headers are used.

Feedback is welcome!

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
