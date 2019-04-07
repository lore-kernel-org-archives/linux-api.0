From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v13 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Sun, 7 Apr 2019 18:46:22 +0300
Message-ID: <20190407154622.GA16004@avx2>
References: <20190224044400.34975-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
 <20190406214143.GA21551@avx2>
 <7cd8fa2d-301a-5c96-ce3d-3dc373a5d8f5@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7cd8fa2d-301a-5c96-ce3d-3dc373a5d8f5@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, aubrey.li@intel.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sun, Apr 07, 2019 at 09:02:38PM +0800, Li, Aubrey wrote:
> On 2019/4/7 5:41, Alexey Dobriyan wrote:
> > On Fri, Apr 05, 2019 at 09:32:35PM +0200, Thomas Gleixner wrote:
> >>> +/* Add support for architecture specific output in /proc/pid/status */
> >>> +extern void arch_proc_pid_status(struct seq_file *m, struct task_struct *task);
> >      ^^^^^^
> > 
> > Unnecessary extern.
> > 
> The linkage is default extern, but with this functions and variables
> can be treated the same way.
> 
> Is it mandatory not to use it explicitly? ./script/checkpatch.pl did
> not report this.

"extern" is only necessary for variables. For prototypes, it is more typing
and more characters on the screen.

checkpatch.pl doesn't report it because opening floodgates is not the plan.

Yours,
	Extern Police.
