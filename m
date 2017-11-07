From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH v16 00/13] support "task_isolation" mode
Date: Tue, 7 Nov 2017 11:54:29 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1711071153280.19523@nuc-kabylake>
References: <1509728692-10460-1-git-send-email-cmetcalf@mellanox.com> <alpine.DEB.2.20.1711060932520.9015@nuc-kabylake> <bd5526d4-7b6e-3b3d-79d0-5d6567c0bdf8@mellanox.com> <alpine.DEB.2.20.1711071109090.19523@nuc-kabylake>
 <41f63344-ff57-2474-d1ba-41d67ee4c8c4@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-1671889168-1510077269=:19523"
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <41f63344-ff57-2474-d1ba-41d67ee4c8c4@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Francis Giraldeau <francis.giraldeau@gmail.com>, linux-mm@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1671889168-1510077269=:19523
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 7 Nov 2017, Chris Metcalf wrote:

> > Presumably we have another context there were we may be able to call into
> > the cleanup code with interrupts enabled.
>
> Right now for task isolation we run with interrupts enabled during the
> initial sys_prctl() call, and call quiet_vmstat_sync() there, which currently
> calls refresh_cpu_vm_stats(false).  In fact we could certainly pass "true"
> there instead (and probably should) since we can handle dealing with
> the pagesets at this time.  As we return to userspace we will test that
> nothing surprising happened with vmstat; if so we jam an EAGAIN into
> the syscall result value, but if not, we will be in userspace and won't need
> to touch the vmstat counters until we next go back into the kernel.

If you do it too early and there is another page allocator action then it
may potentially repopulate the caches. Since this is only draining the
caches for remote node allocation it may be rare and not that important.

--8323329-1671889168-1510077269=:19523--
