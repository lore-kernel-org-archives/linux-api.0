From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v17 2/3] /proc/pid/arch_status: Add AVX-512 usage elapsed
 time
Date: Wed, 24 Apr 2019 23:19:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1904242318100.1762@nanos.tec.linutronix.de>
References: <20190421183529.9141-1-aubrey.li@linux.intel.com> <20190421183529.9141-2-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190421183529.9141-2-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, 22 Apr 2019, Aubrey Li wrote:

$Subject: /proc/pid/arch_status: Add AVX-512 usage elapsed time

x86 patches surely have a different prefix.

>  
> +#ifdef CONFIG_PROC_PID_ARCH_STATUS
> +/* Add support for task architecture specific output in /proc/pid/arch_status */
> +void task_arch_status(struct seq_file *m, struct task_struct *task);
> +#define task_arch_status task_arch_status
> +#endif /* CONFIG_PROC_PID_ARCH_STATUS */

See previous reply.

Thanks,

	tglx
