From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Fri, 24 Jul 2015 16:21:43 -0400
Message-ID: <55B29E57.1070207@ezchip.com>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com>
 <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com>
 <CALCETrVoHvofNHG81Q2Vb2i1qc7f2dy=qgkyb5NWNfUgYxhE8Q@mail.gmail.com>
 <20150721203622.GX3717@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1507220856030.17411@east.gentwo.org>
 <20150722192834.GA32511@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1507221501220.15682@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1507221501220.15682@east.gentwo.org>
Sender: linux-doc-owner@vger.kernel.org
To: Christoph Lameter <cl@linux.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/22/2015 04:02 PM, Christoph Lameter wrote:
> On Wed, 22 Jul 2015, Paul E. McKenney wrote:
>
>>>> Didn't Christoph Lameter fix this?  Or is this an additional problem?
>>> Well the vmstat update must realize first that there are no outstanding
>>> updates before switching itself off. So typically there is one extra tick.
>>> But we could add another function that will simply fold the differential
>>> immediately and turn the kworker task in the expectation that the
>>> processor will stay quiet.
>> Got it, thank you!
>>
>> 								Thanx, Paul
> Ok here is a function that quiets down the vmstat kworkers.

That's great - I will include this patch in my series then, and call it
as part of the "hard isolation" mode return to userspace.  Thanks!

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com

