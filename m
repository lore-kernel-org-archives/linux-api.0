From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.1 3/3] rseq/selftests: Adapt number of threads to
 the number of detected cpus
Date: Fri, 19 Apr 2019 16:59:01 -0400 (EDT)
Message-ID: <1136505826.203.1555707541777.JavaMail.zimbra@efficios.com>
References: <20190305194755.2602-1-mathieu.desnoyers@efficios.com> <1444419838.71.1555677682502.JavaMail.zimbra@efficios.com> <1266612341.87.1555678507226.JavaMail.zimbra@efficios.com> <614774674.134.1555681346941.JavaMail.zimbra@efficios.com> <1863599735.141.1555681723685.JavaMail.zimbra@efficios.com> <6ba0796c-8a96-f797-265c-37bfb9b4bb71@kernel.org> <580328197.148.1555684824260.JavaMail.zimbra@efficios.com> <cfcbace7-363d-e45e-11da-8efb200783b7@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cfcbace7-363d-e45e-11da-8efb200783b7@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cat>
List-Id: linux-api@vger.kernel.org

----- On Apr 19, 2019, at 2:57 PM, shuah shuah@kernel.org wrote:
[...]
> Should I drop this patch that is currently in linux-kseltest next? Just
> confirming if your new patch is supposed to be applied on top of this
> one or not?

We should keep this patch in linux-kselftest next. The fix applies on top
of it.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
