From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH v2 0/2] Add epoll round robin wakeup mode
Date: Tue, 17 Feb 2015 15:33:21 -0500
Message-ID: <54E3A591.2050806@akamai.com>
References: <cover.1424200151.git.jbaron@akamai.com> <CALCETrWAH7SbQm0T+_7wviiU6pJ0isBdWE-cQBGk-joAx2OzFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWAH7SbQm0T+_7wviiU6pJ0isBdWE-cQBGk-joAx2OzFw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Eric Wong <normalperson@yhbt.net>, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 02/17/2015 02:46 PM, Andy Lutomirski wrote:
> On Tue, Feb 17, 2015 at 11:33 AM, Jason Baron <jbaron@akamai.com> wrote:
>> When we are sharing a wakeup source among multiple epoll fds, we end up with
>> thundering herd wakeups, since there is currently no way to add to the
>> wakeup source exclusively. This series introduces 2 new epoll flags,
>> EPOLLEXCLUSIVE for adding to a wakeup source exclusively. And EPOLLROUNDROBIN
>> which is to be used in conjunction to EPOLLEXCLUSIVE to evenly
>> distribute the wakeups. This patch was originally motivated by a desire to
>> improve wakeup balance and cpu usage for a listen socket() shared amongst
>> multiple epoll fd sets.
>>
>> See: http://lwn.net/Articles/632590/ for previous test program and testing
>> resutls.
>>
>> Epoll manpage text:
>>
>> EPOLLEXCLUSIVE
>>         Provides exclusive wakeups when attaching multiple epoll fds to a
>>         shared wakeup source. Must be specified with an EPOLL_CTL_ADD operation.
>>
>> EPOLLROUNDROBIN
>>         Provides balancing for exclusive wakeups when attaching multiple epoll
>>         fds to a shared wakeup soruce. Depends on EPOLLEXCLUSIVE being set and
>>         must be specified with an EPOLL_CTL_ADD operation.
>>
>> Thanks,
> What permissions do you need on the file descriptor to do this?  This
> will be the first case where a poll-like operation has side effects,
> and that's rather weird IMO.
>

So in the case where you have both non-exclusive and exclusive
waiters, all of the non-exclusive waiters will continue to get woken
up. However, I think you're getting at having multiple exclusive
waiters and potentially 'starving' out other exclusive waiters.

In general, I think wait queues are associated with a 'struct file',
so I think unless you are sharing your fd table, this isn't an issue.
However, there may be cases where this is not true? In which
case, perhaps, we could limit this to CAP_SYS_ADMIN...

Thanks,

-Jason

