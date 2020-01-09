From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH][RESEND v5] x86/resctrl: Add task resctrl information
 display
Date: Fri, 10 Jan 2020 01:31:40 +0800
Message-ID: <20200109173140.GB11490@chenyu-office.sh.intel.com>
References: <20200109135001.10076-1-yu.c.chen@intel.com>
 <20200109145355.GC61542@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200109145355.GC61542@chrisdown.name>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Down <chris@chrisdown.name>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Reinette Chatre <reinette.chatre@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Michal Hocko <mhocko@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Chris,
Thanks for looking at this patch.
On Thu, Jan 09, 2020 at 02:53:55PM +0000, Chris Down wrote:
> Chen Yu writes:
> > +#ifdef CONFIG_PROC_CPU_RESCTRL
> > +	ONE("resctrl", S_IRUGO, proc_resctrl_show),
> 
> There was already some discussion about "resctrl" by itself being a
> misleading name, hence why the CONFIG option eventually became
> CONFIG_X86_CPU_RESCTRL. Can you please rethink the name of this /proc file,
> and have it at least be "cpu_resctrl" or "x86_resctrl" or similar? :-)
Ok, I'll change the name from "resctrl" to "cpu_resctrl", because:
1. it is a CPU feature so a 'cpu' prefixed seems to be more obvious,
2. other CPUs than x86 could also use this file in the future.

Thanks,
Chenyu
