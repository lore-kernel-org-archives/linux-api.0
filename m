From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 11:58:21 -0700
Message-ID: <39260843-9918-be3b-7f0f-3d034ec3e7a8@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <20190206005638.GU2217@ZenIV.linux.org.uk>
 <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
 <20190207040058.GW2217@ZenIV.linux.org.uk>
 <73e23146-2138-5a46-46ed-9c7f1f912a04@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <73e23146-2138-5a46-46ed-9c7f1f912a04@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/7/19 11:45 AM, Jens Axboe wrote:
> On 2/6/19 9:00 PM, Al Viro wrote:
>> On Wed, Feb 06, 2019 at 06:41:00AM -0700, Jens Axboe wrote:
>>> On 2/5/19 5:56 PM, Al Viro wrote:
>>>> On Tue, Feb 05, 2019 at 12:08:25PM -0700, Jens Axboe wrote:
>>>>> Proof is in the pudding, here's the main commit introducing io_uring
>>>>> and now wiring it up to the AF_UNIX garbage collection:
>>>>>
>>>>> http://git.kernel.dk/cgit/linux-block/commit/?h=io_uring&id=158e6f42b67d0abe9ee84886b96ca8c4b3d3dfd5
>>>>>
>>>>> How does that look?
>>>>
>>>> In a word - wrong.  Some theory: garbage collector assumes that there is
>>>> a subset of file references such that
>>>> 	* for all files with such references there's an associated unix_sock.
>>>> 	* all such references are stored in SCM_RIGHTS datagrams that can be
>>>> found by the garbage collector (currently: for data-bearing AF_UNIX sockets -
>>>> queued SCM_RIGHTS datagrams, for listeners - SCM_RIGHTS datagrams sent via
>>>> yet-to-be-accepted connections).
>>>> 	* there is an efficient way to count those references for given file
>>>> (->inflight of the corresponding unix_sock).
>>>> 	* removal of those references would render the graph acyclic.
>>>> 	* file can _NOT_ be subject to syscalls unless there are references
>>>> to it outside of that subset.
>>>
>>> IOW, we cannot use fget() for registering files, and we still need fget/fput
>>> in the fast path to retain safe use of the file. If I'm understanding you
>>> correctly?
>>
>> No.  *ALL* references (inflight and not) are the same for file->f_count.
>> unix_inflight() does not grab a new reference to file; it only says that
>> reference passed to it by the caller is now an in-flight one.
>>
>> OK, braindump time:
> 
> [snip]
> 
> This is great info, and I think it belongs in Documentation/ somewhere.
> Not sure I've ever seen such a good and detailed dump of this before.
> 
>> What you are about to add is *ANOTHER* kind of loops - references
>> to files in the "registered" set are pinned down by owning io_uring.
>>
>> That would invalidate just about every assumption made the garbage
>> collector - even if you forbid to register io_uring itself, you
>> still can register both ends of AF_UNIX socket pair, then pass
>> io_uring in SCM_RIGHTS over that, then close all descriptors involved.
>> From the garbage collector point of view all sockets have external
>> references, so there's nothing to collect.  In fact those external
>> references are only reachable if you have a reachable reference
>> to io_uring, so we get a leak.
>>
>> To make it work:
>> 	* have unix_sock created for each io_uring (as your code does)
>> 	* do *NOT* have unix_inflight() done at that point - it's
>> completely wrong there.
>> 	* file set registration becomes
>> 		* create and populate SCM_RIGHTS, with the same
>> fget()+grab an extra reference + unix_inflight() sequence.
>> Don't forget to have skb->destructor set to unix_destruct_scm
>> or equivalent thereof.
>> 		* remember UNIXCB(skb).fp - that'll give you your
>> array of struct file *, to use in lookups.
>> 		* queue it into your unix_sock
>> 		* do _one_ fput() for everything you've grabbed,
>> dropping one of two references you've taken.
>> 	* unregistering is simply skb_dequeue() + kfree_skb().
>> 	* in ->release() you do sock_release(); it'll do
>> everything you need (including unregistering the set, etc.)
> 
> This is genius! I implemented this and it works. I've verified that the
> previous test app failed to release due to the loop, and with this in
> place, once the GC kicks in, the io_uring is released appropriately.
> 
>> The hairiest part is the file set registration, of course -
>> there's almost certainly a helper or two buried in that thing;
>> simply exposing all the required net/unix/af_unix.c bits is
>> ucking fugly.
> 
> Outside of the modification to unix_get_socket(), the only change I had
> to make was to ensure that unix_destruct_scm() is available to io_uring.
> No other changes needed.
> 
>> I'm not sure what you propose for non-registered descriptors -
>> _any_ struct file reference that outlives the return from syscall
>> stored in some io_uring-attached data structure is has exact same
>> loop (and leak) problem.  And if you mean to have it dropped before
>> return from syscall, I'm afraid I don't follow you.  How would
>> that be done?
>>
>> Again, "io_uring descriptor can't be used in those requests" does
>> not help at all - use a socket instead, pass the io_uring fd over
>> it in SCM_RIGHTS and you are back to square 1.
> 
> I wasn't proposing to fput() before return, otherwise I can't hang on to
> that file *.
> 
> Right now for async punt, we don't release the reference, and then we
> fput() when IO completes. According to what you're saying here, that's
> not good enough. Correct me if I'm wrong, but what if we:
> 
> 1) For non-sock/io_uring fds, the current approach is sufficient
> 2) Disallow io_uring fd, doesn't make sense anyway
> 
> That leaves the socket fd, which is problematic. Should be solvable by
> allocating an skb and marking that file inflight?

Actually, we can just NOT set NOWAIT for types we don't support. That
means we'll never punt to async context for those.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
