From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 12:40:54 +0200
Message-ID: <d8395c0e-7486-7c84-2c1c-de0929ec27b7@metux.net>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Aubrey Li <aubrey.li@linux.intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On 24.04.19 23:18, Thomas Gleixner wrote:

Hi,

>> +config PROC_PID_ARCH_STATUS
>> +	bool "Enable /proc/<pid>/arch_status file"
> 
> Why is this switchable? x86 selects it if PROC_FS is enabled and all other
> architectures are absolutely not interested in this.

IMHO, it's good to have a switch, but that way doesn't make much sense.
Instead, I'd do it the other way round: make that switch depending on
those archs that actually support it. Something like this:

config PROC_PID_ARCH_STATUS
	bool "Enable /proc/<pid>/arch_status file"
	depends on PROC_FS
	depends on BROKEN

When x86 comes in, it would change to:

config PROC_PID_ARCH_STATUS
	bool "Enable /proc/<pid>/arch_status file"
	depends on PROC_FS
	depends on X86

And later arm coming in:

config PROC_PID_ARCH_STATUS
	bool "Enable /proc/<pid>/arch_status file"
	depends on PROC_FS
	depends on X86 || ARM

>> +	default n
>> +	help
>> +	  Provides a way to examine process architecture specific information.
>> +	  See <file:Documentation/filesystems/proc.txt> for more information.
> 
> Which contains zero information about this file when only this patch is
> applied. 

hmm, the patch alone doesn't do anything useful anyway. it only becomes
useful with subsequent patches that add some arch. I wonder if there's
anything more useful to document at that point.

>> +/*
>> + * Add support for task architecture specific output in /proc/pid/arch_status.
>> + * task_arch_status() must be defined in asm/processor.h
>> + */
>> +#ifdef CONFIG_PROC_PID_ARCH_STATUS
>> +# ifndef task_arch_status
>> +# define task_arch_status(m, task)
>> +# endif
> 
> What exactly is the point of this macro mess? If an architecture selects
> CONFIG_PROC_PID_ARCH_STATUS then it has to provide proc_task_arch_status()
> and the prototype should be in include/linux/proc_fs.h.

ACK.

>> +static int proc_pid_arch_status(struct seq_file *m, struct pid_namespace *ns,
>> +				struct pid *pid, struct task_struct *task)
>> +{
>> +	task_arch_status(m, task);
>> +	return 0;
>> +}

Is that wrapper really neeeded ?


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
