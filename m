From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v15 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Wed, 17 Apr 2019 18:07:17 +0800
Message-ID: <a3c19a36-9b0b-e48b-6d1f-9f4b654df615@linux.intel.com>
References: <20190416063250.7514-1-aubrey.li@linux.intel.com>
 <20190416160143.8292ced993dc803aae7fa0da@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416160143.8292ced993dc803aae7fa0da@linux-foundation.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2019/4/17 7:01, Andrew Morton wrote:
> On Tue, 16 Apr 2019 14:32:48 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
> 
>> The architecture specific information of the running processes could
>> be useful to the userland. Add support to examine process architecture
>> specific information externally.
> 
> The implementation looks just fine to me.  Have you had any feedback on
> the overall desirability of adding this feature?
> 
This is orientated by the customer's complain. When the customer colocated
their latency critical tasks with AVX512 tasks, the latency critical tasks
were affected due to core frequency slowing down by AVX512 use. So we propose
this interface for the user space tools to identify AVX512 using task and
apply user space dispatching policy. We may have subsequent effort based on
this proposal.

>> --- a/fs/proc/array.c
>> +++ b/fs/proc/array.c
>> @@ -96,6 +96,11 @@
>>  #include <asm/processor.h>
>>  #include "internal.h"
>>  
>> +/* Add support for architecture specific output in /proc/pid/status */
>> +#ifndef	arch_proc_pid_status
>> +#define	arch_proc_pid_status(m, task)
>> +#endif
> 
> To this I suggest adding
> 
> /* arch_proc_pid_status() must be defined in asm/processor.h */
> 
> Because we've regularly had different architectures defining such things
> in different headers, resulting in a mess.

Thanks, I'll add it in the next version.
-Aubrey
