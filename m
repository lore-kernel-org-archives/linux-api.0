From: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Tue, 23 Oct 2012 18:01:46 -0700
Message-ID: <50873DFA.5010205@adobe.com>
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <5086D27F.1000007@adobe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5086D27F.1000007-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Cc: "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/23/12 6:26 AM, Michael Kerrisk (man-pages) wrote:
> On 10/23/12 10:23 AM, Paton J. Lewis wrote:
>> [Re-sending without HTML formatting; all vger.kernel.org destination
>> addresses bounced my original response.]
>>
>> On 10/16/12 8:12 AM, Michael Kerrisk (man-pages) wrote:
>>> [CC += linux-api@]
>>
>> Thank you; is this sufficient to coordinate the required changes to the
>> glibc version of epoll.h?
>
> I'm not sure. With a bit of luck, someone at glibc might monitor that list.
>
>>> Hello Paton,
>>>
>>> On Thu, Aug 23, 2012 at 11:15 PM, Paton J. Lewis <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
>>> wrote:
>>>> From: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
>>>>
>>>> Enhanced epoll_ctl to support EPOLL_CTL_DISABLE, which disables an
>>>> epoll item.
>>>> If epoll_ctl doesn't return -EBUSY in this case, it is then safe to
>>>> delete the
>>>> epoll item in a multi-threaded environment. Also added a new
>>>> test_epoll self-
>>>> test app to both demonstrate the need for this feature and test it.
>>>
>>> (There's a lot of background missing from this version of the patch
>>> that was included in the previous version
>>> [http://thread.gmane.org/gmane.linux.kernel/1311457]. It helps to
>>> include the full rationale with a revised patch--best not to assume
>>> that someone has the context of past mails when reading a revised
>>> patch.)
>>
>> I was trying to present the same information in a more concise manner. I
>> was hoping that the test application would provide a clearer description
>> of the problem and the solution. However, I can include some of my
>> original prose from the v1 email in the next revision's email if you
>> think that would be helpful.
>
> Yes, it would be a good idea.
>
>>> I've taken a look at this patch as it currently stands in 3.7-rc1, and
>>> done a bit of testing. (By the way, the test program
>>> tools/testing/selftests/epoll/test_epoll.c does not compile...)
>>
>> Sorry, the test program compiled against commit
>> ecca5c3acc0d0933d89abc44e60afb0cc8170e35 from
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git, which
>> I believe was the current head commit when I emailed the v2 patch in
>> August. I thought that git's format-patch command would include the
>> necessary information so people could see which commit the diff was
>> created from. Should I be pulling from a different repository or working
>> on a different branch? Since this is my first patch submission and I
>> have essentially zero experience with git, I would appreciate any
>> guidance you could provide here.
>
> I'm not expert enough to provide guidance, unfortunately. I'd just
> make sure that the program gets updated with any future patch
> revision.
>
> I should have added that the changes to fix the program were fairly
> trivial (but they involved a misnamed variable--it looks like you did
> a scan renaming a variable but didn't catch all instances, so I'm not
> sure how the test program could have ever compiled in the form that
> was committed), and I did get it going.

Sorry, that error arose from my lack of experience with git and its 
format-patch command. I created the patch without first committing the 
final fix to my branch.

>>> There are one or two places where the behavior seems a little strange,
>>> so I have a question or two at the end of this mail. But other than
>>> that, I want to check my understanding so that the interface can be
>>> correctly documented.
>>>
>>> Just to go though my understanding, the problem is the following
>>> scenario in a multithreaded application:
>>>
>>> 1. Multiple threads are performing epoll_wait() operations,
>>>     and maintaining a user-space cache that contains information
>>>     corresponding to each file descriptor being monitored by
>>>     epoll_wait().
>>>
>>> 2. At some point, a thread wants to delete (EPOLL_CTL_DEL)
>>>     a file descriptor from the epoll interest list, and
>>>     delete the corresponding record from the user-space cache.
>>>
>>> 3. The problem with (2) is that some other thread may have
>>>     previously done an epoll_wait() that retrieved information
>>>     about the fd in question, and may be in the middle of using
>>>     information in the cache that relates to that fd. Thus,
>>>     there is a potential race.
>>>
>>> 4. The race can't solved purely in user space, because doing
>>>     so would require applying a mutex across the epoll_wait()
>>>     call, which would of course blow thread concurrency.
>>>
>>> Right?
>>
>> Yes, that is an accurate description of the problem.
>
> Okay.
>
>>> Your solution is the EPOLL_CTL_DISABLE operation. I want to
>>> confirm my understanding about how to use this flag, since
>>> the description that has accompanied the patches so far
>>> has been a bit sparse
>>>
>>> 0. In the scenario you're concerned about, deleting a file
>>>     descriptor means (safely) doing the following:
>>>     (a) Deleting the file descriptor from the epoll interest list
>>>         using EPOLL_CTL_DEL
>>>     (b) Deleting the corresponding record in the user-space cache
>>>
>>> 1. It's only meaningful to use this EPOLL_CTL_DISABLE in
>>>     conjunction with EPOLLONESHOT.
>>>
>>> 2. Using EPOLL_CTL_DISABLE without using EPOLLONESHOT in
>>>     conjunction is a logical error.
>>>
>>> 3. The correct way to code multithreaded applications using
>>>     EPOLL_CTL_DISABLE and EPOLLONESHOT is as follows:
>>>
>>>     a. All EPOLL_CTL_ADD and EPOLL_CTL_MOD operations should
>>>        should EPOLLONESHOT.
>>>
>>>     b. When a thread wants to delete a file descriptor, it
>>>        should do the following:
>>>
>>>        [1] Call epoll_ctl(EPOLL_CTL_DISABLE)
>>>        [2] If the return status from epoll_ctl(EPOLL_CTL_DISABLE)
>>>            was zero, then the file descriptor can be safely
>>>            deleted by the thread that made this call.
>>>        [3] If the epoll_ctl(EPOLL_CTL_DISABLE) fails with EBUSY,
>>>            then the descriptor is in use. In this case, the calling
>>>            thread should set a flag in the user-space cache to
>>>            indicate that the thread that is using the descriptor
>>>            should perform the deletion operation.
>>>
>>> Is all of the above correct?
>>
>> Yes, that is correct.
>
> Okay
>
>>
>>> The implementation depends on checking on whether
>>> (events & ~EP_PRIVATE_BITS) == 0
>>> This replies on the fact that EPOLL_CTL_AD and EPOLL_CTL_MOD always
>>> set EPOLLHUP and EPOLLERR in the 'events' mask, and EPOLLONESHOT
>>> causes those flags (as well as all others in ~EP_PRIVATE_BITS) to be
>>> cleared.
>>>
>>> A corollary to the previous paragraph is that using EPOLL_CTL_DISABLE
>>> is only useful in conjunction with EPOLLONESHOT. However, as things
>>> stand, one can use EPOLL_CTL_DISABLE on a file descriptor that does
>>> not have EPOLLONESHOT set in 'events' This results in the following
>>> (slightly surprising) behavior:
>>>
>>> (a) The first call to epoll_ctl(EPOLL_CTL_DISABLE) returns 0
>>>      (the indicator that the file descriptor can be safely deleted).
>>> (b) The next call to epoll_ctl(EPOLL_CTL_DISABLE) fails with EBUSY.
>>>
>>> This doesn't seem particularly useful, and in fact is probably an
>>> indication that the user made a logic error: they should only be using
>>> epoll_ctl(EPOLL_CTL_DISABLE) on a file descriptor for which
>>> EPOLLONESHOT was set in 'events'. If that is correct, then would it
>>> not make sense to return an error to user space for this case?
>>
>> Good point. I've implemented and tested your suggested change, and I've
>> updated the test application to cover that case. I will soon submit a
>> revised patch.
>
> I suppose that I have a concern that goes in the other direction. Is
> there not some other solution possible that doesn't require the use of
> EPOLLONESHOT? It seems overly restrictive to require that the caller
> must employ this flag, and imposes the burden that the caller must
> re-enable monitoring after each event.
>
> Does a solution like the following (with no requirement for EPOLLONESHOT) work?
>
> 0. Implement an epoll_ctl() operation EPOLL_CTL_XXX
>    where the name XXX might be chosen based on the decision
>    in 4(a).
> 1. EPOLL_CTL_XXX employs a private flag, EPOLLUSED, in the
>    per-fd events mask in the ready list. By default,
>    that flag is off.
> 2. epoll_wait() always clears the EPOLLUSED flag if a
>    file descriptor is found to be ready.
> 3. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>    flag is NOT set, then
>         a) it sets the EPOLLUSED flag
>         b) It disables I/O events (as per EPOLL_CTL_DISABLE)
>            (I'm not 100% sure if this is necesary).
>         c) it returns EBUSY to the caller
> 4. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>    flag IS set, then it
>         a) either deletes the fd or disables events for the fd
>            (the choice here is a matter of design taste, I think;
>            deletion has the virtue of simplicity; disabling provides
>            the option to re-enable the fd later, if desired)
>         b) returns 0 to the caller.
>
> All of the above with suitable locking around the user-space cache.
>
> Cheers,
>
> Michael

I don't believe that proposal will solve the problem. Consider the case 
where a worker thread has just executed epoll_wait and is about to 
execute the next line of code (which will access the data associated 
with the fd receiving the event). If the deletion thread manages to call 
epoll_ctl(EPOLL_CTL_XXX) for that fd twice in a row before the worker 
thread is able to execute the next statement, then the deletion thread 
will mistakenly conclude that it is safe to destroy the data that the 
worker thread is about to access.

Pat
