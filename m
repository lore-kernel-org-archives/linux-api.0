From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
Date: Thu, 18 Dec 2014 16:38:10 -0700
Message-ID: <54936562.5070502@oracle.com>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.11.1412182355020.17382@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/18/2014 04:02 PM, Thomas Gleixner wrote:
> On Thu, 18 Dec 2014, Khalid Aziz wrote:
>> On 12/18/2014 03:28 PM, Peter Zijlstra wrote:
>>> On Thu, Dec 18, 2014 at 11:44:19AM -0700, Khalid Aziz wrote:
>>>> sched/fair: Add advisory flag for borrowing a timeslice
>>>
>>> yuck hatred and much of that.
>>>
>>> Also, you fail to explain why a kernel side spin futex-lock is not an
>>> option.
>>>
>>
>> I had explained that when this question came up in the last round of
>> discussions. The queuing problem I am trying to solve stems from userspace
>> locks. Java and databases implement their own userspace locks that do not use
>> futex. Solving this with futex will not help the primary users of this
>> solution.
>
> If we can solve it with a proper designed and well thought out
> functionality in the kernel based on a futex like mechanism, why cant
> java and databases not switch over to that and simply use it?
>
> You need to modify user space anyway, so it does not matter whether
> you modify it in a sane or in a hacky way.

Actually userspace does not need to be modified. The code to use this 
functionality is already present in database code since this same 
functionality exists on other OSs (the API is a little different but 
those details can be handled with a simple header file in userspace). 
Userspace code has already been tested and debugged thoroughly on the 
OSs that support this functionality and that has significant impact on 
testing effort. So for userspace it is simply a matter of turning that 
code on on Linux as well and recompiling. This would be a multi-platform 
solution for database/java as opposed to a Linux specific solution.

--
Khalid
