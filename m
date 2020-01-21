From: Jann Horn <jannh@google.com>
Subject: Re: [RFC PATCH v1] pin_on_cpu: Introduce thread CPU pinning system call
Date: Tue, 21 Jan 2020 18:20:47 +0100
Message-ID: <CAG48ez2bQdoT9y7HkyU06DTazysUDdPdJe+gyV-NxgQA7JWQVQ@mail.gmail.com>
References: <20200121160312.26545-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200121160312.26545-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, kernel list <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Ingo Molnar <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Will Deacon <will.deacon@arm.com>, Shuah Khan <shuah@kernel.org>, Andi Kleen <andi@firstfloor.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Stev
List-Id: linux-api@vger.kernel.org

On Tue, Jan 21, 2020 at 5:13 PM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> There is an important use-case which is not possible with the
> "rseq" (Restartable Sequences) system call, which was left as
> future work.
>
> That use-case is to modify user-space per-cpu data structures
> belonging to specific CPUs which may be brought offline and
> online again by CPU hotplug. This can be used by memory
> allocators to migrate free memory pools when CPUs are brought
> offline, or by ring buffer consumers to target specific per-CPU
> buffers, even when CPUs are brought offline.
>
> A few rather complex prior attempts were made to solve this.
> Those were based on in-kernel interpreters (cpu_opv, do_on_cpu).
> That complexity was generally frowned upon, even by their author.
>
> This patch fulfills this use-case in a refreshingly simple way:
> it introduces a "pin_on_cpu" system call, which allows user-space
> threads to pin themselves on a specific CPU (which needs to be
> present in the thread's allowed cpu mask), and then clear this
> pinned state.
[...]
> For instance, this allows implementing this userspace library API
> for incrementing a per-cpu counter for a specific cpu number
> received as parameter:
>
> static inline __attribute__((always_inline))
> int percpu_addv(intptr_t *v, intptr_t count, int cpu)
> {
>         int ret;
>
>         ret = rseq_addv(v, count, cpu);
> check:
>         if (rseq_unlikely(ret)) {
>                 pin_on_cpu_set(cpu);
>                 ret = rseq_addv(v, count, percpu_current_cpu());
>                 pin_on_cpu_clear();
>                 goto check;
>         }
>         return 0;
> }

What does userspace have to do if the set of allowed CPUs switches all
the time? For example, on Android, if you first open Chrome and then
look at its allowed CPUs, Chrome is allowed to use all CPU cores
because it's running in the foreground:

walleye:/ # ps -AZ | grep 'android.chrome$'
u:r:untrusted_app:s0:c145,c256,c512,c768 u0_a145 7845 805 1474472
197868 SyS_epoll_wait f09c0194 S com.android.chrome
walleye:/ # grep cpuset /proc/7845/cgroup; grep Cpus_allowed_list
/proc/7845/status
3:cpuset:/top-app
Cpus_allowed_list: 0-7

But if you then switch to the home screen, the application is moved
into a different cgroup, and is restricted to two CPU cores:

walleye:/ # grep cpuset /proc/7845/cgroup; grep Cpus_allowed_list
/proc/7845/status
3:cpuset:/background
Cpus_allowed_list: 0-1

At the same time, I also wonder whether it is a good idea to allow
userspace to stay active on a CPU even after the task has been told to
move to another CPU core - that's probably not exactly a big deal, but
seems suboptimal to me.


I'm wondering whether it might be possible to rework this mechanism
such that, instead of moving the current task onto a target CPU, it
prevents all *other* threads of the current process from running on
that CPU (either entirely or in user mode). That might be the easiest
way to take care of issues like CPU hotplugging and changing cpusets
all at once? The only potential issue I see with that approach would
be that you wouldn't be able to use it for inter-process
communication; and I have no idea whether this would be good or bad
performance-wise.
