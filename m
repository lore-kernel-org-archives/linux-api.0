From: "Li, Aubrey" <aubrey.li@linux.intel.com>
Subject: Re: [PATCH v13 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Sun, 7 Apr 2019 21:02:38 +0800
Message-ID: <7cd8fa2d-301a-5c96-ce3d-3dc373a5d8f5@linux.intel.com>
References: <20190224044400.34975-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
 <20190406214143.GA21551@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190406214143.GA21551@avx2>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, aubrey.li@intel.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 2019/4/7 5:41, Alexey Dobriyan wrote:
> On Fri, Apr 05, 2019 at 09:32:35PM +0200, Thomas Gleixner wrote:
>>> +/* Add support for architecture specific output in /proc/pid/status */
>>> +extern void arch_proc_pid_status(struct seq_file *m, struct task_struct *task);
>      ^^^^^^
> 
> Unnecessary extern.
> 
The linkage is default extern, but with this functions and variables
can be treated the same way.

Is it mandatory not to use it explicitly? ./script/checkpatch.pl did
not report this.

Thanks,
-Aubrey
