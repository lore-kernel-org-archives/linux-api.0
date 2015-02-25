From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Wed, 25 Feb 2015 11:27:04 -0500
Message-ID: <54EDF7D8.60201@akamai.com>
References: <cover.1424805740.git.jbaron@akamai.com> <20150225073814.GA14558@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150225073814.GA14558@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: peterz@infradead.org, mingo@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, normalperson@yhbt.net, davidel@xmailserver.org, mtk.manpages@gmail.com, luto@amacapital.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@ftp.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On 02/25/2015 02:38 AM, Ingo Molnar wrote:
> * Jason Baron <jbaron@akamai.com> wrote:
>
>> Hi,
>>
>> When we are sharing a wakeup source among multiple epoll 
>> fds, we end up with thundering herd wakeups, since there 
>> is currently no way to add to the wakeup source 
>> exclusively. This series introduces a new EPOLL_ROTATE 
>> flag to allow for round robin exclusive wakeups.
>>
>> I believe this patch series addresses the two main 
>> concerns that were raised in prior postings. Namely, that 
>> it affected code (and potentially performance) of the 
>> core kernel wakeup functions, even in cases where it was 
>> not strictly needed, and that it could lead to wakeup 
>> starvation (since we were are no longer waking up all 
>> waiters). It does so by adding an extra layer of 
>> indirection, whereby waiters are attached to a 'psuedo' 
>> epoll fd, which in turn is attached directly to the 
>> wakeup source.
>>   sched/wait: add __wake_up_rotate()
>>  include/linux/wait.h           |  1 +
>>  kernel/sched/wait.c            | 27 ++++++++++++++++++++++
> So the scheduler bits are looking good to me in principle, 
> because they just add a new round-robin-rotating wakeup 
> variant and don't disturb the others.
>
> Is there consensus on the epoll ABI changes? With Davide 

I'm not sure there is a clear consensus on this change,
but I'm hoping that I've addressed the outstanding
concerns in this latest version.

I also think the addition of a way to do a 'wakeup policy'
here will open up other 'policies', such as taking into
account cpu affinity as you suggested. So, I think its
potentially an interesting direction for this code.

> Libenzi inactive eventpoll appears to be without a 
> dedicated maintainer since 2011 or so. Is there anyone who 
> knows the code and its usages in detail and does final ABI 
> decisions on eventpoll - Andrew, Al or Linus?
>
Generally, Andrew and Al do more 'final' reviews here,
and a lot of others on lkml are always very helpful in
looking at this code. However, its not always clear, at
least to me, who I should pester.

Thanks,

-Jason
