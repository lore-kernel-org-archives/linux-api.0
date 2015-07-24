From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Fri, 24 Jul 2015 16:19:41 -0400
Message-ID: <55B29DDD.5070508@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com>
 <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com> <20150724140308.GB20091@lerouge>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150724140308.GB20091@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>
List-Id: linux-api@vger.kernel.org

On 07/24/2015 10:03 AM, Frederic Weisbecker wrote:
> To summarize, lets first split nohz and isolation. Introduce
> CONFIG_CPU_ISOLATION and stuff all the isolation policies to
> kernel/cpu_isolation.c, lets try to implement hard isolation and see if that
> meets soft isolation workload users as well, if not we'll split that later.

I will do that for v5.

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

