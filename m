From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of
 running thread
Date: Wed, 24 Feb 2016 17:17:57 +0000 (UTC)
Message-ID: <1095889878.7102.1456334277472.JavaMail.zimbra@efficios.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <1456270120-7560-2-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1602241206020.3670@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1602241206020.3670@nanos>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Feb 24, 2016, at 6:11 AM, Thomas Gleixner tglx@linutronix.de wrote:

> On Tue, 23 Feb 2016, Mathieu Desnoyers wrote:
>> +/*
>> + * If parent process has a thread-local ABI, the child inherits. Only applies
>> + * when forking a process, not a thread.
>> + */
>> +void getcpu_cache_fork(struct task_struct *t)
>> +{
>> +	t->cpu_cache = current->cpu_cache;
>> +}
>> +
>> +void getcpu_cache_execve(struct task_struct *t)
>> +{
>> +	t->cpu_cache = NULL;
>> +}
>> +
>> +void getcpu_cache_exit(struct task_struct *t)
>> +{
>> +	t->cpu_cache = NULL;
>> +}
> 
> That's hardly worth a function call. Please inline.
> 
>> +/*
>> + * sys_getcpu_cache - setup getcpu cache for caller thread
>> + */
>> +SYSCALL_DEFINE3(getcpu_cache, int, cmd, int32_t __user * __user *, cpu_cachep,
>> +		int, flags)
>> +{
>> +	if (unlikely(flags))
>> +		return -EINVAL;
> 
> New line for readability sake.
> 
>> +	switch (cmd) {
>> +	case GETCPU_CACHE_GET:
> 
> Other than that: Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks! Will do those changes for v5 and add your Reviewed-by tag.

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
