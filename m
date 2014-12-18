From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing a
 timeslice
Date: Thu, 18 Dec 2014 23:28:46 +0100
Message-ID: <20141218222846.GH30905@twins.programming.kicks-ass.net>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com>
Sender: linux-doc-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Dec 18, 2014 at 11:44:19AM -0700, Khalid Aziz wrote:
> sched/fair: Add advisory flag for borrowing a timeslice

yuck hatred and much of that.

Also, you fail to explain why a kernel side spin futex-lock is not an
option.
