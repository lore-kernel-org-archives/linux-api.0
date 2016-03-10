From: Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Thu, 10 Mar 2016 13:53:41 -0500
Message-ID: <56E1C2B5.2040905@akamai.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <56AB1F6C.7000609@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, akpm@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, viro@ftp.linux.org.uk, normalperson@yhbt.net, m@silodev.com, corbet@lwn.net, luto@amacapital.net, torvalds@linux-foundation.org, hagen@jauu.net, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

On 01/29/2016 03:14 AM, Michael Kerrisk (man-pages) wrote:
> Hello Jason,
> On 01/28/2016 06:57 PM, Jason Baron wrote:
>> Hi,
>>
>> On 01/28/2016 02:16 AM, Michael Kerrisk (man-pages) wrote:
>>> Hi Jason,
>>>
>>> On 12/08/2015 04:23 AM, Jason Baron wrote:
>>>> Hi,
>>>>
>>>> Re-post of an old series addressing thundering herd issues when sharing
>>>> an event source fd amongst multiple epoll fds. Last posting was here
>>>> for reference: https://lkml.org/lkml/2015/2/25/56
>>>>  
>>>> The patch herein drops the core scheduler 'rotate' changes I had previously
>>>> proposed as this patch seems performant without those.
>>>>
>>>> I was prompted to re-post this because Madars Vitolins reported some good
>>>> speedups with this patch using Enduro/X application. His writeup is here:
>>>> https://mvitolin.wordpress.com/2015/12/05/endurox-testing-epollexclusive-flag/
>>>>
>>>> Thanks,
>>>>
>>>> -Jason
>>>>
>>>> Sample epoll_clt text:
>>>
>>> Thanks for the proposed text. I have some questions about points
>>> that are not quite clear to me.
>>>
>>>> EPOLLEXCLUSIVE
>>>>         Sets an exclusive wakeup mode for the epfd file descriptor that is
>>>> 	being attached to the target file descriptor, fd. Thus, when an
>>>> 	event occurs and multiple epfd file descriptors are attached to the
>>>> 	same target file using EPOLLEXCLUSIVE, one or more epfds will receive
>>>> 	an event with epoll_wait(2). The default in this scenario (when
>>>> 	EPOLLEXCLUSIVE is not set) is for all epfds to receive an event.
>>>> 	EPOLLEXLUSVIE may only be specified with the op EPOLL_CTL_ADD.
>>>
>>> So, assuming an FD is present in the interest list of multiple (say 6)
>>> epoll FDs, and some (say 3) of those attachments were done using
>>> EPOLLEXCLUSVE. Which of the following statements are correct:
>>>
>>> (a) It's guaranteed that *none* of the epoll FDs that did NOT specify
>>>     EPOLLEXCLUSIVE will receive an event.
>>>
>>> (b) It's guaranteed that *all* of the epoll FDs that did NOT specify
>>>     EPOLLEXCLUSIVE will receive an event.
>>>
>>> (c) From 1 to 3 of the epoll FDs that did specify EPOLLEXCLUSIVE
>>>     will receive an event.
>>>
>>> (d) Exactly one epoll FD that did specify EPOLLEXCLUSIVE will get
>>>     an event, and it is indeterminate which one.
>>>
>>
>> So b and c. All the non-exclusive adds will get it and at least 1 of the
>> exclusive adds will as well.
> 
> So is it fair to say that the expected use case is that all epoll sets
> would use EPOLLEXCLUSIVE?
> 
>>> I suppose one point I'm trying to uncover in the above is: what is
>>> the scope of EPOLLEXCLUSIVE? Is it just applicable for one process's
>>> FD, or is it setting an attribute in the epoll "interest list" record
>>> for that FD that affects notification behavior across all processes?
>>>
>>
>> Right - so 'EPOLLEXCLUSIVE' will affect other epoll sets that are also
>> using 'EPOLLEXCLUSIVE' against the the same fd, but will have no affect
>> on epoll sets connected to fd that do not specify it.
>>
>>
>>> And then:
>>>
>>> (1) What are the semantics of EPOLLEXCLUSIVE if the added FD becomes
>>>     disabled via EPOLLONESHOT (or explicitly via EPOLL_CTL_MOD with
>>>     the 'events' field set to 0)?
>>>
>>
>> In the case of EPOLLEXCLUSIVE and EPOLLONESHOT, one would have to re-arm
>> at least 1 of threads that was woken up by doing EPOLL_CTL_MOD to
>> guarantee further wakeups.
>>
>> And like-wise with an EPOLL_CTL_MOD with 'events' all set to 0, one
>> would need to either re-arm the thread that set the 'events' field to 0
>> (by setting back to non-zero), or re-arm in at least one other thread
>> via EPOLL_CTL_MOD (or delete and add).
> 
> Okay -- so when an EPOLLEXCLUSIVE FD becomes disarmed it is possible
> to re-enable rith EPOLL_CTL_MOD; one doesn't need to delete and re-add
> the FD.
> 
>>> (2) The source code contains a comment "we do not currently supported 
>>>     nested exclusive wakeups". Could you elaborate on this point? It
>>>     sounds like something that should be documented.
>>
>> So I was just trying to say that we return -EINVAL if you try to do and
>> EPOLL_CTL_ADD with EPOLLEXCLUSIVE and the 'fd' argument is a epoll fd
>> returned via epoll_create().
> 
> Okay -- that definitely belongs in the man page.
> 
> I'll work up a text, but would like to get input about the "use case"
> question above.
> 
> Cheers,
> 
> Michael
> 
> 
> 

Ok, here's some updated text:

EPOLLEXCLUSIVE

Sets an exclusive wakeup mode for the epfd file descriptor that is being
attached to the target file descriptor, fd. When a wakeup event occurs
and multiple epfd file descriptors are attached to the same target file
using EPOLLEXCLUSIVE, one or more epfds will receive an event with
epoll_wait(2). The default in this scenario (when EPOLLEXCLUSIVE is not
set) is for all epfds to receive an event.

The events supported by EPOLLEXCLUSIVE are: EPOLLIN, EPOLLOUT, EPOLLERR,
EPOLLHUP, EPOLLWAKEUP, and EPOLLET. epoll_wait(2) will always wait for
EPOLLERR and EPOLLHUP; it is not necessary to set it in events. If
EPOLLEXCLUSIVE is set using epoll_ctl(2), then a subsequent
EPOLL_CTL_MOD on the same epfd, fd pair will retrun -EINVAL. An
epoll_ctl(2) that specifies EPOLLEXCLUSIVE in events and specifies the
target file descriptor fd as an epoll instance will return -EINVAL
as well.

Thanks,

-Jason



