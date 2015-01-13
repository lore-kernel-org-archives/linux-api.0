From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing a
 timeslice
Date: Tue, 13 Jan 2015 12:25:16 +0100
Message-ID: <20150113112516.GH25256@twins.programming.kicks-ass.net>
References: <54935842.5020507@oracle.com>
 <alpine.DEB.2.11.1412182355020.17382@nanos>
 <54936562.5070502@oracle.com>
 <alpine.DEB.2.11.1412190045590.17382@nanos>
 <54949BF0.8030403@oracle.com>
 <alpine.DEB.2.11.1412200041220.17382@nanos>
 <5498498B.90703@oracle.com>
 <20141223105251.GB22203@gmail.com>
 <5499867C.1010201@oracle.com>
 <5499B8A2.4080008@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5499B8A2.4080008@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 23, 2014 at 01:46:58PM -0500, Rik van Riel wrote:
> An uncontended futex is taken without ever going into kernel
> space. Adaptive spinning allows short duration futexes to be
> taken without going into kernel space.

The going into kernel is a red herring afaict, a no-op syscall costs ~180
cycles or something like that. So sure you can do a wee spin (~90 cycles
to try and amortize that), but I really doubt that this is the problem.
