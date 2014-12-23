From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
Date: Tue, 23 Dec 2014 08:13:00 -0700
Message-ID: <5499867C.1010201@oracle.com>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos> <54936562.5070502@oracle.com> <alpine.DEB.2.11.1412190045590.17382@nanos> <54949BF0.8030403@oracle.com> <alpine.DEB.2.11.1412200041220.17382@nanos> <5498498B.90703@oracle.com> <20141223105251.GB22203@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20141223105251.GB22203@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/23/2014 03:52 AM, Ingo Molnar wrote:
>
>
> to implement what Thomas suggested in the discussion: a proper
> futex like spin mechanism? That looks like a totally acceptable
> solution to me, without the disadvantages of your proposed
> solution.

Hi Ingo,

Thank you for taking the time to respond. It is indeed possible to 
implement a futex like spin mechanism. Futex like mechanism will be 
clean and elegant. That is where I had started when I was given this 
problem to solve. Trouble I run into is the primary application I am 
looking at to help with this solution is Database which implements its 
own locking mechanism without using POSIX semaphore or futex. Since the 
locking is entirely in userspace, kernel has no clue when the userspace 
has acquired one of these locks. So I can see only two ways to solve 
this - find a solution in userspace entirely, or have userspace tell the 
kernel when it acquires one of these locks. I will spend more time on 
finding a way to solve it in userspace and see if I can find a way to 
leverage futex mechanism without causing significant change to database 
code. There may be a way to use priority inheritance to avoid 
contention. Database performance people tell me that their testing has 
shown the cost of making any system calls in this code easily offsets 
any gains from optimizing for contention avoidance, so that is one big 
challenge. Database rewriting their locking code is extremely unlikely 
scenario. Am I missing a third option here?

Thanks,
Khalid
