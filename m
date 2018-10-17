From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.21 06/16] cpu_opv: Provide cpu_opv system call
 (v8)
Date: Wed, 17 Oct 2018 12:09:51 -0400 (EDT)
Message-ID: <1102241735.877.1539792591430.JavaMail.zimbra@efficios.com>
References: <20181010191936.7495-1-mathieu.desnoyers@efficios.com> <20181010191936.7495-7-mathieu.desnoyers@efficios.com> <20181017071931.GA18379@linux.vnet.ibm.com> <1006597066.825.1539789100381.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1006597066.825.1539789100381.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will
List-Id: linux-api@vger.kernel.org

----- On Oct 17, 2018, at 11:11 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Oct 17, 2018, at 3:19 AM, Srikar Dronamraju srikar@linux.vnet.ibm.com
> wrote:
> 
>> Hi Mathieu,
>> 
>>> +static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt,
>>> +		      struct cpu_opv_vaddr *vaddr_ptrs, int cpu)
>>> +{
>>> +	struct mm_struct *mm = current->mm;
>>> +	int ret;
>>> +
>>> +retry:
>>> +	if (cpu != raw_smp_processor_id()) {
>>> +		ret = push_task_to_cpu(current, cpu);
>>> +		if (ret)
>>> +			goto check_online;
>>> +	}
>>> +	down_read(&mm->mmap_sem);
>>> +	ret = vaddr_ptrs_check(vaddr_ptrs);
>>> +	if (ret)
>>> +		goto end;
>>> +	preempt_disable();
>>> +	if (cpu != smp_processor_id()) {
>>> +		preempt_enable();
>>> +		up_read(&mm->mmap_sem);
>>> +		goto retry;
>>> +	}
>> 
>> If we have a higher priority task/s either pinned to the cpu, dont we end up
>> in busy-looping till the task exits/sleeps?
> 
> You're right!
> 
> How about we ditch the thread migration altogether, and simply perform
> the cpu_opv operations in a IPI handler ?
> 
> This is possible now that cpu_opv uses a temporary vmap() rather than
> try to touch the user-space page through the current thread's page table.
> 
> Thoughts ?

Here is the associated implementation on top of this patchset:

commit 759c5a8860d867091e168900329f0955e5101989
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date:   Wed Oct 17 11:32:02 2018 -0400

    cpu opv: use ipi

diff --git a/kernel/cpu_opv.c b/kernel/cpu_opv.c
index db144b71d51a..30405e0cc049 100644
--- a/kernel/cpu_opv.c
+++ b/kernel/cpu_opv.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/atomic.h>
+#include <linux/smp.h>
 #include <asm/ptrace.h>
 #include <asm/byteorder.h>
 #include <asm/cacheflush.h>
@@ -1039,41 +1040,48 @@ static int vaddr_ptrs_check(struct cpu_opv_vaddr *vaddr_ptrs)
        return 0;
 }

+struct opv_ipi_args {
+       struct cpu_op *cpuop;
+       int cpuopcnt;
+       int ret;
+};
+
+static void cpu_opv_ipi(void *info)
+{
+       struct opv_ipi_args *args = info;
+
+       rseq_preempt(current);
+       args->ret = __do_cpu_opv(args->cpuop, args->cpuopcnt);
+}
+
 static int do_cpu_opv(struct cpu_op *cpuop, int cpuopcnt,
                      struct cpu_opv_vaddr *vaddr_ptrs, int cpu)
 {
        struct mm_struct *mm = current->mm;
+       struct opv_ipi_args args = {
+               .cpuop = cpuop,
+               .cpuopcnt = cpuopcnt,
+       };
        int ret;

 retry:
-       if (cpu != raw_smp_processor_id()) {
-               ret = push_task_to_cpu(current, cpu);
-               if (ret)
-                       goto check_online;
-       }
+       if (!cpumask_test_cpu(cpu, &current->cpus_allowed))
+               return -EINVAL;
        down_read(&mm->mmap_sem);
        ret = vaddr_ptrs_check(vaddr_ptrs);
        if (ret)
                goto end;
-       preempt_disable();
-       if (cpu != smp_processor_id()) {
-               preempt_enable();
+       ret = smp_call_function_single(cpu, cpu_opv_ipi, &args, 1);
+       if (ret) {
                up_read(&mm->mmap_sem);
-               goto retry;
+               goto check_online;
        }
-       ret = __do_cpu_opv(cpuop, cpuopcnt);
-       preempt_enable();
+       ret = args.ret;
 end:
        up_read(&mm->mmap_sem);
        return ret;

 check_online:
-       /*
-        * push_task_to_cpu() returns -EINVAL if the requested cpu is not part
-        * of the current thread's cpus_allowed mask.
-        */
-       if (ret == -EINVAL)
-               return ret;
        get_online_cpus();
        if (cpu_online(cpu)) {
                put_online_cpus();




-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
