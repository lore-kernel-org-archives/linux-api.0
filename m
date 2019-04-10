From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v14 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Wed, 10 Apr 2019 10:20:28 +0800
Message-ID: <89957461-ec42-f041-a7e9-2452b2e83d39@linux.intel.com>
References: <20190410015326.24500-1-aubrey.li@linux.intel.com>
 <CALCETrWV9SVDGQmzvZuub4aOPGyVqx7gPdk6D0s2_7j471jT_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWV9SVDGQmzvZuub4aOPGyVqx7gPdk6D0s2_7j471jT_g@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, aubrey.li@intel.com, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 2019/4/10 9:58, Andy Lutomirski wrote:
> On Tue, Apr 9, 2019 at 6:55 PM Aubrey Li <aubrey.li@linux.intel.com> wrote:
>>
>> The architecture specific information of the running processes could
>> be useful to the userland. Add support to examine process architecture
>> specific information externally.
>>
>> Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Tim Chen <tim.c.chen@linux.intel.com>
>> Cc: Dave Hansen <dave.hansen@intel.com>
>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> Cc: Linux API <linux-api@vger.kernel.org>
>> Cc: Alexey Dobriyan <adobriyan@gmail.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  fs/proc/array.c         | 5 +++++
>>  include/linux/proc_fs.h | 2 ++
>>  2 files changed, 7 insertions(+)
>>
>> diff --git a/fs/proc/array.c b/fs/proc/array.c
>> index 2edbb657f859..331592a61718 100644
>> --- a/fs/proc/array.c
>> +++ b/fs/proc/array.c
>> @@ -401,6 +401,10 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>>         seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>>  }
>>
>> +void __weak arch_proc_pid_status(struct seq_file *m, struct task_struct *task)
>> +{
>> +}
> 
> This pointlessly bloats other architectures.  Do this instead in an
> appropriate header:
> 
> #ifndef arch_proc_pid_status
> static inline void arch_proc_pid_status(...)
> {
> }
> #endif
> 

I saw a bunch of similar weak functions, is it not acceptable?

fs/proc$ grep weak *.c
cpuinfo.c:__weak void arch_freq_prepare_all(void)
meminfo.c:void __attribute__((weak)) arch_report_meminfo(struct seq_file *m)
vmcore.c:int __weak elfcorehdr_alloc(unsigned long long *addr, unsigned long long *size)
vmcore.c:void __weak elfcorehdr_free(unsigned long long addr)
vmcore.c:ssize_t __weak elfcorehdr_read(char *buf, size_t count, u64 *ppos)
vmcore.c:ssize_t __weak elfcorehdr_read_notes(char *buf, size_t count, u64 *ppos)
vmcore.c:int __weak remap_oldmem_pfn_range(struct vm_area_struct *vma,
vmcore.c:ssize_t __weak

> Or add /proc/PID/x86_status, which sounds better in most respects to me.
> 

I didn't figure out how to make /proc/PID/x86_status invisible to other
architectures in an appropriate way, do you have any suggestions?

Thanks,
-Aubrey
