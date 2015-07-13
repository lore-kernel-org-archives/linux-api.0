From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Mon, 13 Jul 2015 13:40:58 -0700
Message-ID: <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com> <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jul 13, 2015 at 12:57 PM, Chris Metcalf <cmetcalf@ezchip.com> wrote:
> The existing nohz_full mode makes tradeoffs to minimize userspace
> interruptions while still attempting to avoid overheads in the
> kernel entry/exit path, to provide 100% kernel semantics, etc.
>
> However, some applications require a stronger commitment from the
> kernel to avoid interruptions, in particular userspace device
> driver style applications, such as high-speed networking code.
>
> This change introduces a framework to allow applications to elect
> to have the stronger semantics as needed, specifying
> prctl(PR_SET_CPU_ISOLATED, PR_CPU_ISOLATED_ENABLE) to do so.
> Subsequent commits will add additional flags and additional
> semantics.

I thought the general consensus was that this should be the default
behavior and that any associated bugs should be fixed.

--Andy
