From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
Date: Mon, 24 Nov 2014 22:30:50 -0800
Message-ID: <1416897050.20575.18.camel@linux-t7sj.site>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <5473E388.6000605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <5473E388.6000605@redhat.com>
Sender: linux-doc-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, tglx@linutronix.de, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-11-24 at 21:03 -0500, Rik van Riel wrote:
> I can see this "solution" help mostly with userspace spinlocks,
> which are relics of a past era that need to die. There is no
> way userspace spinlocks will not fail miserably on virtual
> machines, and it is time to get rid of them.

No, not really. Spinlocks are still very useful on bare metal.
Virtualization is not the only thing out there.

Thanks,
Davidlohr

