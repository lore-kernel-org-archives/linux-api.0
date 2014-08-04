From: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 1/7] locking/rwsem: don't resched at the end of optimistic
 spinning
Date: Mon, 04 Aug 2014 14:36:35 -0400
Message-ID: <53DFD2B3.3090101@hp.com>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com> <1407119782-41119-2-git-send-email-Waiman.Long@hp.com> <20140804075528.GI9918@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140804075528.GI9918-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <davidlohr-VXdhtT5mjnY@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Scott J Norton <scott.norton-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 08/04/2014 03:55 AM, Peter Zijlstra wrote:
> On Sun, Aug 03, 2014 at 10:36:16PM -0400, Waiman Long wrote:
>> For a fully preemptive kernel, a call to preempt_enable() could
>> potentially trigger a task rescheduling event. In the case of rwsem
>> optimistic spinning, the task has either gotten the lock or is going
>> to sleep soon. So there is no point to do rescheduling here.
> Uh what? Why shouldn't we preempt if we've gotten the lock? What if a
> FIFO task just woke up?

I didn't mean that we shouldn't preempt if there is a higher priority 
task. I am sure that there will be other preemption points along the way 
that a higher priority task can take over the CPU. I just want to say 
that doing it here may not be the best place especially if the task is 
going to sleep soon.

If you think this patch does not make sense, I can remove it as other 
patches in the set has no dependency on this one.

-Longman
