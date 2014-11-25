From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH v3] sched/fair: Add advisory flag for borrowing a
 timeslice
Date: Tue, 25 Nov 2014 10:46:04 -0700
Message-ID: <1416937564.3512.15.camel@maggy.simpson.net>
References: <1416862595-24513-1-git-send-email-khalid.aziz@oracle.com>
	 <alpine.DEB.2.11.1411242317380.6439@nanos>
	 <1416889208.4335.127.camel@maggy.simpson.net> <54749725.3050307@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54749725.3050307@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 2014-11-25 at 07:50 -0700, Khalid Aziz wrote:

> It is definitely not an attempt to solve any kind of RT problem.

No no, I'm saying that giving certain tasks special dispensations
effectively elevates them.  Temporarily or otherwise, they play by
different rules, will block more deserving tasks, and it's not cut and
dried that that blocking will not do more harm than good.

Is it a clear win to make say some kworker or other global asset wait
when it could have preempted and been gone in usecs?  Nope.

	-Mike
