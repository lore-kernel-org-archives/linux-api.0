From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Mon, 1 Feb 2016 14:42:07 -0500
Message-ID: <56AFB50F.5010806@akamai.com>
References: <cover.1449523436.git.jbaron@akamai.com>
 <56A9C03B.7020104@gmail.com> <56AA56A2.3000700@akamai.com>
 <56AB1F6C.7000609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AB1F6C.7000609-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org



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

Hi Michael,

So the current EPOLLEXCLUSIVE interface (added in 4.5-rc1 as epoll: add
EPOLLEXCLUSIVE flag df0108c) is lacking as currently implemented and
that would affect the docs here.

The issue is that if epoll() waiters create differnt POLL* sets and
register them as exclusive against the same target fd, the current
implementation will stop waking any further waiters once it finds the
first idle waiter. This means that waiters will miss wakeups, in the
case the interest sets differ. The common use-case we've had so far for
this has set all the interest sets in the same way.

For example, when we wake up a pipe for reading we do:

wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLRDNORM);

So if one epoll set or epfd is added with EPOLLEXCLUSVIE to pipe p with
POLLIN and a second set epfd2 is added to pipe p with EPOLLEXCLUSIVE |
POLLRDNORM, only epfd may receive the wakeup since the current
implementation will stop after it finds any intersection of events with
a waiter that is blocked in epoll_wait().

We could potentially address this by requiring all epoll waiters that
are added to p to be required to pass the same set of POLL* events. IE
the first EPOLL_CTL_ADD that passes EPOLLEXCLUSIVE establishes the set
POLL* flags to be used by any other epfds that are added as
EPOLLEXCLUSIVE. However, I think it might be a somewhat confusing
interface as we would have to reference count the number of users for
that set, and so userspace would have to keep track of that count, or we
would need a more complex interface....It also adds some shared state
that we'd have store somewhere. I don't think anybody will want to bloat
__wait_queue_head for this.

I think what we could do instead, is to simply restrict EPOLLEXCLUSIVE
such that it can only be specified with EPOLLIN and/or EPOLLOUT. So that
way if the wakeup includes 'POLLIN' and not 'POLLOUT', we can stop once
we hit the first idle waiter that specifies the EPOLLIN bit, since any
remaining waiters that only have 'POLLOUT' set wouldn't need to be
woken. Likewise, we can do the same thing if 'POLLOUT' is in the wakeup
bit set and not 'POLLIN'. If both 'POLLOUT' and 'POLLIN' are set the
wake bit set (there is at least one example of this I saw in fs/pipe.c),
then we just wake the entire exclusive list. Having both 'POLLOUT' and
'POLLIN' both set should not be on any performance critical path, so I
think that's ok (in fs/pipe.c its in pipe_release()).

Since epoll waiters are going to be interested in other events as well
besides POLLIN and POLLOUT, these can still be added by doing a 'dup()'
on the target fd and adding that as one normally would with
EPOLL_CTL_ADD. Since I think that the POLLIN and POLLOUT events are
really the only ones that we are interested in reducing wakeups for, the
'dup' thing would perhaps be added to only one of the waiter threads. So
this would look something like (rough pseudo-code):

int p[2], dup_p;
pipe(p);

for each thread do:
	epoll_ctl(epfd, EPOLL_CTL_ADD, p[0], EPOLLEXCLUSIVE | EPOLLIN);

dup_p = dup(p[0]);

pick one (or more threads) and do:
	epoll_ctl(epfd, EPOLL_CTL_ADD, dup_p, EPOLLERR | EPOLLHUP);


So I don't think that adds to much complexity to user-space here and
keeps the kernel implementation small. I think this change is really
about balancing POLLIN events (and maybe POLLOUT), and so having
user-space have to explicitly call that out I think is ok.

Kernel patch is below to hopefully explain the thing better.

Thanks,

-Jason


diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ae1dbcf..4f19793 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -94,6 +94,11 @@
 /* Epoll private bits inside the event mask */
 #define EP_PRIVATE_BITS (EPOLLWAKEUP | EPOLLONESHOT | EPOLLET |
EPOLLEXCLUSIVE)

+#define EPOLLINOUT_BITS (POLLIN | POLLOUT)
+
+#define EPOLLEXCLUSIVE_OK_BITS (EPOLLINOUT_BITS | EPOLLWAKEUP | EPOLLET | \
+				EPOLLEXCLUSIVE)
+
 /* Maximum number of nesting allowed inside epoll sets */
 #define EP_MAX_NESTS 4

@@ -1068,7 +1073,8 @@ static int ep_poll_callback(wait_queue_t *wait,
unsigned mode, int sync, void *k
 	 * wait list.
 	 */
 	if (waitqueue_active(&ep->wq)) {
-		ewake = 1;
+		if ((((unsigned long)key & EPOLLINOUT_BITS) != EPOLLINOUT_BITS))
+			ewake = 1;
 		wake_up_locked(&ep->wq);
 	}
 	if (waitqueue_active(&ep->poll_wait))
@@ -1875,9 +1881,13 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op,
int, fd,
 	 * so EPOLLEXCLUSIVE is not allowed for a EPOLL_CTL_MOD operation.
 	 * Also, we do not currently supported nested exclusive wakeups.
 	 */
-	if ((epds.events & EPOLLEXCLUSIVE) && (op == EPOLL_CTL_MOD ||
-		(op == EPOLL_CTL_ADD && is_file_epoll(tf.file))))
-		goto error_tgt_fput;
+	if (epds.events & EPOLLEXCLUSIVE) {
+		if (op == EPOLL_CTL_MOD)
+			goto error_tgt_fput;
+		if (op == EPOLL_CTL_ADD && (is_file_epoll(tf.file) ||
+				(epds.events & ~EPOLLEXCLUSIVE_OK_BITS)))
+			goto error_tgt_fput;
+	}

 	/*
 	 * At this point it is safe to assume that the "private_data" contains
@@ -1935,7 +1945,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op,
int, fd,
 	switch (op) {
 	case EPOLL_CTL_ADD:
 		if (!epi) {
-			epds.events |= POLLERR | POLLHUP;
+			if (!(epds.events & EPOLLEXCLUSIVE))
+				epds.events |= POLLERR | POLLHUP;
 			error = ep_insert(ep, &epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
@@ -1950,8 +1961,10 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op,
int, fd,
 		break;
 	case EPOLL_CTL_MOD:
 		if (epi) {
-			epds.events |= POLLERR | POLLHUP;
-			error = ep_modify(ep, epi, &epds);
+			if (!(epi->event.events & EPOLLEXCLUSIVE)) {
+				epds.events |= POLLERR | POLLHUP;
+				error = ep_modify(ep, epi, &epds);
+			}
 		} else
 			error = -ENOENT;
 		break;
-- 
2.6.1
