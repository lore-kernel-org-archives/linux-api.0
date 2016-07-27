From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v13 00/12] support "task_isolation" mode
Date: Wed, 27 Jul 2016 09:01:27 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607270900250.24843@east.gentwo.org>
References: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468529299-27929-1-git-send-email-cmetcalf@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org


We tested this with 4.7-rc7 and aside from the issue with
clocksource_watchdog() this is working fine.

Tested-by: Christoph Lameter <cl@linux.com>
