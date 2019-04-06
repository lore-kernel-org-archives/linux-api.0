From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v13 1/3] /proc/pid/status: Add support for architecture
 specific output
Date: Sun, 7 Apr 2019 00:41:43 +0300
Message-ID: <20190406214143.GA21551@avx2>
References: <20190224044400.34975-1-aubrey.li@linux.intel.com>
 <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904052129371.1802@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Aubrey Li <aubrey.li@linux.intel.com>, mingo@redhat.com, Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, aubrey.li@intel.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Apr 05, 2019 at 09:32:35PM +0200, Thomas Gleixner wrote:
> > +/* Add support for architecture specific output in /proc/pid/status */
> > +extern void arch_proc_pid_status(struct seq_file *m, struct task_struct *task);
     ^^^^^^

Unnecessary extern.
