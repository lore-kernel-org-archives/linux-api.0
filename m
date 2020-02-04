From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 5/6] clone3: allow spawning processes into cgroups
Date: Tue, 4 Feb 2020 12:53:51 +0100
Message-ID: <20200204115351.GD14879@hirez.programming.kicks-ass.net>
References: <20200121154844.411-1-christian.brauner@ubuntu.com>
 <20200121154844.411-6-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200121154844.411-6-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Jan 21, 2020 at 04:48:43PM +0100, Christian Brauner wrote:
> This adds support for creating a process in a different cgroup than its
> parent. Callers can limit and account processes and threads right from
> the moment they are spawned:
> - A service manager can directly spawn new services into dedicated
>   cgroups.
> - A process can be directly created in a frozen cgroup and will be
>   frozen as well.
> - The initial accounting jitter experienced by process supervisors and
>   daemons is eliminated with this.
> - Threaded applications or even thread implementations can choose to
>   create a specific cgroup layout where each thread is spawned
>   directly into a dedicated cgroup.
> 
> This feature is limited to the unified hierarchy. Callers need to pass
> an directory file descriptor for the target cgroup. The caller can
> choose to pass an O_PATH file descriptor. All usual migration
> restrictions apply, i.e. there can be no processes in inner nodes. In
> general, creating a process directly in a target cgroup adheres to all
> migration restrictions.

AFAICT, he *big* win here is avoiding the write side of the
cgroup_threadgroup_rwsem. Or am I mis-reading the patch?

That global lock is what makes moving tasks/threads around super
expensive, avoiding that by use of this clone() variant wins the day.
