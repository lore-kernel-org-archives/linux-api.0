From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 20/24] task_diag: Only add VMAs for thread_group leader
Date: Tue, 14 Jul 2015 22:01:51 -0400
Message-ID: <55A5BF0F.7090808@gmail.com>
References: <1436172445-6979-1-git-send-email-avagin@openvz.org> <1436172445-6979-21-git-send-email-avagin@openvz.org> <20150714174703.GA8088@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150714174703.GA8088@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>, Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Roger Luethi <rl@hellgate.ch>, Arnd Bergmann <arnd@arndb.de>, Arnaldo Carvalho de Melo <acme@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Pavel Odintsov <pavel.odintsov@gmail.com>
List-Id: linux-api@vger.kernel.org

On 7/14/15 1:47 PM, Oleg Nesterov wrote:
> On 07/06, Andrey Vagin wrote:
>>
>> From: David Ahern <dsahern@gmail.com>
>>
>> threads of a process share the same VMAs, so when dumping all threads
>> for all processes only push vma data for group leader.
>
> ...
>
>> @@ -492,6 +493,13 @@ static int task_diag_fill(struct task_struct *tsk, struct sk_buff *skb,
>>   	}
>>
>>   	if (show_flags & TASK_DIAG_SHOW_VMA) {
>> +		/* if the request is to dump all threads of all processes
>> +		 * only show VMAs for group leader.
>> +		 */
>> +		if (req->dump_strategy == TASK_DIAG_DUMP_ALL_THREAD &&
>> +		    !thread_group_leader(tsk))
>> +			goto done;
>> +
>
> This doesn't look right, group leader can be a zombie with ->mm == NULL,

Seriously? I'll find some way to track whether VMAs have been dumped for 
a pid.

>
>>   		if (i >= n)
>>   			err = fill_vma(tsk, skb, cb, &progress, show_flags);
>
> so this probably needs something like find_lock_task_mm().

ok.

Thanks for the review,
David
