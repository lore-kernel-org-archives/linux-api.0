From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH][RESEND v5] x86/resctrl: Add task resctrl information
 display
Date: Fri, 10 Jan 2020 01:45:45 +0800
Message-ID: <20200109174544.GC11490@chenyu-office.sh.intel.com>
References: <20200109135001.10076-1-yu.c.chen@intel.com>
 <20200109142444.GB61542@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200109142444.GB61542@chrisdown.name>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Down <chris@chrisdown.name>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Reinette Chatre <reinette.chatre@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Michal Hocko <mhocko@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Chris,
On Thu, Jan 09, 2020 at 02:24:44PM +0000, Chris Down wrote:
> Chen Yu writes:
> > +#ifdef CONFIG_PROC_CPU_RESCTRL
> > +
> > +/*
> > + * A task can only be part of one control
> > + * group and of one monitoring group which
> > + * is associated to that control group.
> > + * So one line is simple and clear enough:
> 
> Can we please avoid using the word "control group" to describe these? It's
> extremely confusing for readers since it's exactly the same word as used for
> actual cgroups, especially since those are also a form of "resource
> control"...
> 
> Doesn't official documentation refer to them as "resource groups" to avoid
> this?
Right, how abut changing change this description to:
control group  ->   resctrl allocation group
monitor group  ->   resctrl monitor group?

Yes, the Documentation/x86/resctrl_ui.rst described them as
"Resource Control feature", which is composed of allocation
and monitor, so distinguish them as above seems to be appropriate.

Thanks,
Chenyu
