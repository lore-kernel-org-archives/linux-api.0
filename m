From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice (was: Pre-emption control for userspace)
Date: Mon, 24 Nov 2014 21:20:08 -0700
Message-ID: <1416889208.4335.127.camel@maggy.simpson.net>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1411242317380.6439@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-25 at 00:35 +0100, Thomas Gleixner wrote:

> Aside of the general issues I have with this (see the inline replies
> to your changelog) the overall impression of this patch is that it is
> a half baken and carelessly cobbled together extract of some data base
> specific kernel hackery, which I prefer not to see at all.

It culminates in a lumbering pseudo RT class of task disguised as a fair
class task.  I'd expect more gain by twiddling knobs to let last buddy
do its job than the 3% mentioned.

You could perhaps create a SUPER_BATCH class that is not wakeup
preempted by any fair class task of <= priority, not only BATCH and
IDLE, but that's as nasty as this patch, though loads prettier.  The
tick time thing doesn't feel right at all... if you're hurt badly by the
tick, you're likely holding the lock too long methinks.

	-Mike


