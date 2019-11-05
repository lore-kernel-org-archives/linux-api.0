From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v2 PATCH] futex: extend set_robust_list to allow 2 locking
 ABIs at the same time.
Date: Tue, 5 Nov 2019 01:10:44 +0100 (CET)
Message-ID: <alpine.DEB.2.21.1911050104050.17054@nanos.tec.linutronix.de>
References: <20191104002909.25783-1-shawn@git.icu> <alpine.DEB.2.21.1911041423510.5102@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1911041423510.5102@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Shawn Landden <shawn@git.icu>
Cc: libc-alpha@sourceware.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Deepa Dinamani <deepa.kernel@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Keith Packard <keithp@keithp.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>
List-Id: linux-api@vger.kernel.org

On Mon, 4 Nov 2019, Thomas Gleixner wrote:
> Please provide a proper design and explain how this should work together
> with existing robust list using code first.

Just for clarification:

Any change to that interface needs to be discussed with the *libc people
first. Your way of overriding the robust list interfacce with some ad hoc
solution will break existing users which is not acceptable.

So either the problem is solved with the *libc people in a way which allows
them to build upon or if your intention is solely to solve the problem
Keith described then none of this is required at all as user space can
handle the different layouts for that magic fence implementation perfectly
fine.

Thanks,

	tglx
