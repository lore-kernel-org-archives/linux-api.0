From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v13 2/3] x86,/proc/pid/status: Add AVX-512 usage elapsed
 time
Date: Sat, 6 Apr 2019 23:41:57 +0800
Message-ID: <d118f16e-0d8c-956f-9057-26e463ce3e60@linux.intel.com>
References: <20190224044400.34975-1-aubrey.li@linux.intel.com>
 <20190224044400.34975-2-aubrey.li@linux.intel.com>
 <CAG48ez2hJvjRD-immEJ9uJAY1WRth3pMf0Qz8bApRke05kC+2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez2hJvjRD-immEJ9uJAY1WRth3pMf0Qz8bApRke05kC+2Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>, tim.c.chen@linux.intel.com, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, aubrey.li@intel.com, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 2019/4/6 4:27, Jann Horn wrote:
> On Fri, Apr 5, 2019 at 10:02 PM Aubrey Li <aubrey.li@linux.intel.com> wrote:
>> AVX-512 components use could cause core turbo frequency drop. So
>> it's useful to expose AVX-512 usage elapsed time as a heuristic hint
>> for the user space job scheduler to cluster the AVX-512 using tasks
>> together.
>>
>> Tensorflow example:
>> $ while [ 1 ]; do cat /proc/pid/status | grep AVX; sleep 1; done
>> AVX512_elapsed_ms:      4
>> AVX512_elapsed_ms:      8
>> AVX512_elapsed_ms:      4
>>
>> This means that 4 milliseconds have elapsed since the AVX512 usage
>> of tensorflow task was detected when the task was scheduled out.
>>
>> Or:
>> $ cat /proc/pid/status | grep AVX512_elapsed_ms
>> AVX512_elapsed_ms:      -1
> 
> (Very nitpicky, feel free to ignore: If you change the /proc/pid to
> /proc/tid in the commit message, it becomes clearer that this status
> is really per-task/thread, not per-process/threadgroup.)

Thanks, I'll refine.

> 
> [...]
>> +
>> +/*
>> + * Report the amount of time elapsed in millisecond since last AVX512
>> + * use in the task.
>> + */
>> +static void avx512_status(struct seq_file *m, struct task_struct *task)
>> +{
>> +       unsigned long timestamp = task->thread.fpu.avx512_timestamp;
> 
> This is theoretically a data race, right? Should this have a READ_ONCE() on it?

Thanks, I'll refine.

> 
> Is there something that zeroes out the avx512_timestamp on
> fork()/clone(), or will every child inherit the avx512 timestamp? As
> far as I can tell, the timestamp is inherited; I think it would be
> nicer to zero it out at that point. Either way, It might be worth
> documenting this decision.
> 

This timestamp is not inherited, see below:

_do_fork()
->copy_process()
-->dup_task_struct()
--->arch_dup_task_struct()
---->fpu__copy()

Thanks,
-Aubrey
