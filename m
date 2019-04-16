From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v15 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Tue, 16 Apr 2019 16:01:43 -0700
Message-ID: <20190416160143.8292ced993dc803aae7fa0da@linux-foundation.org>
References: <20190416063250.7514-1-aubrey.li@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190416063250.7514-1-aubrey.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aubrey Li <aubrey.li@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 16 Apr 2019 14:32:48 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:

> The architecture specific information of the running processes could
> be useful to the userland. Add support to examine process architecture
> specific information externally.

The implementation looks just fine to me.  Have you had any feedback on
the overall desirability of adding this feature?

> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -96,6 +96,11 @@
>  #include <asm/processor.h>
>  #include "internal.h"
>  
> +/* Add support for architecture specific output in /proc/pid/status */
> +#ifndef	arch_proc_pid_status
> +#define	arch_proc_pid_status(m, task)
> +#endif

To this I suggest adding

/* arch_proc_pid_status() must be defined in asm/processor.h */

Because we've regularly had different architectures defining such things
in different headers, resulting in a mess.
