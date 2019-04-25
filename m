From: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Subject: Re: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Thu, 25 Apr 2019 12:11:57 +0200
Message-ID: <6a9e6bd9-8e1a-9fe5-135d-c7a49697b5a4@metux.net>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904242310040.1762@nanos.tec.linutronix.de>
 <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <da1fcb4f-e856-d31f-7c72-76c969af3935@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Li, Aubrey" <aubrey.li@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On 25.04.19 03:50, Li, Aubrey wrote:

>>> +>>> +config PROC_PID_ARCH_STATUS>>> +	bool "Enable
/proc/<pid>/arch_status file">>>> Why is this switchable? x86 selects it
if PROC_FS is enabled and all other>> architectures are absolutely not
interested in this.> > Above and this, I was trying to avoid an empty
arch_file on other architectures.> In previous proposal the entry only
exists on the platform with AVX512.
Why not making it depend on those archs that actually support it ?

> In that way proc_task_arch_status() should be defined in asm/processor.h,> but proc_task_arch_status() has four parameters, I don't want
unnecessary> "struct pid_namespace *ns" and "struct pid *pid" leaked
into arch headers,> so I defined task_arch_status(m, task) to avoid that.

--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
