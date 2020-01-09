From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH][RESEND v5] x86/resctrl: Add task resctrl information
 display
Date: Thu, 9 Jan 2020 14:24:44 +0000
Message-ID: <20200109142444.GB61542@chrisdown.name>
References: <20200109135001.10076-1-yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200109135001.10076-1-yu.c.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chen Yu <yu.c.chen@intel.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Reinette Chatre <reinette.chatre@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Michal Hocko <mhocko@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Chen Yu writes:
>+#ifdef CONFIG_PROC_CPU_RESCTRL
>+
>+/*
>+ * A task can only be part of one control
>+ * group and of one monitoring group which
>+ * is associated to that control group.
>+ * So one line is simple and clear enough:

Can we please avoid using the word "control group" to describe these? It's 
extremely confusing for readers since it's exactly the same word as used for 
actual cgroups, especially since those are also a form of "resource control"...

Doesn't official documentation refer to them as "resource groups" to avoid 
this?
