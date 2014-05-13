From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [SCHED_DEADLINE man pages 0/2] Summary
Date: Tue, 13 May 2014 19:56:09 +0200
Message-ID: <53725CB9.4060903@gmail.com>
References: <53723235.40101@gmail.com> <20140513152719.GF2485@laptop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140513152719.GF2485@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: mtk.manpages@gmail.com, Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>, lkml <linux-kernel@vger.kernel.org>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 05/13/2014 05:27 PM, Peter Zijlstra wrote:
> On Tue, May 13, 2014 at 04:54:45PM +0200, Michael Kerrisk (man-pages) wrote:
>> Peter, at al.
>>
>> The follow ups to this mail contain the changes to man-pages for
>> the new sched_setattr() and sched_getattr() system calls, as well
>> as the changes to the sched(7) man page to document the 
>> SCHED_DEADLINE policy, all new changes in kernel 3.14.
>>
>> I used the text you submitted, but _heavily_ edited it, and added
>> a _lot_ of further details. Therefore, could you (and Juri, and 
>> Dario?) please carefully review the text.
>>
>> The follow-up mails are:
>>
>> [1/2] The sched_setattr.2 page that documents sched_setattr(2) 
>>       and sched_getattr(2).
>>
>> [2/2] The revisions to the sched(7) page.
>>
>> In each case, I've posted the formatted output for easy reading,
>> and attached the page source to the message.
> 
> I've read (as careful as one still can after seeing too much of this)
> both texts and they appear to be good.

Thanks for checking, Peter.

> Thanks for polishing, they are indeed clearer than what I provided.

Good!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
