From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Tue, 5 Feb 2019 10:57:09 -0700
Message-ID: <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>
Cc: linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 2/4/19 7:19 PM, Jens Axboe wrote:
> On 2/3/19 7:56 PM, Al Viro wrote:
>> On Wed, Jan 30, 2019 at 02:29:05AM +0100, Jann Horn wrote:
>>> On Tue, Jan 29, 2019 at 8:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> We normally have to fget/fput for each IO we do on a file. Even with
>>>> the batching we do, the cost of the atomic inc/dec of the file usage
>>>> count adds up.
>>>>
>>>> This adds IORING_REGISTER_FILES, and IORING_UNREGISTER_FILES opcodes
>>>> for the io_uring_register(2) system call. The arguments passed in must
>>>> be an array of __s32 holding file descriptors, and nr_args should hold
>>>> the number of file descriptors the application wishes to pin for the
>>>> duration of the io_uring context (or until IORING_UNREGISTER_FILES is
>>>> called).
>>>>
>>>> When used, the application must set IOSQE_FIXED_FILE in the sqe->flags
>>>> member. Then, instead of setting sqe->fd to the real fd, it sets sqe->fd
>>>> to the index in the array passed in to IORING_REGISTER_FILES.
>>>>
>>>> Files are automatically unregistered when the io_uring context is
>>>> torn down. An application need only unregister if it wishes to
>>>> register a new set of fds.
>>>
>>> Crazy idea:
>>>
>>> Taking a step back, at a high level, basically this patch creates sort
>>> of the same difference that you get when you compare the following
>>> scenarios for normal multithreaded I/O in userspace:
>>
>>> This kinda makes me wonder whether this is really something that
>>> should be implemented specifically for the io_uring API, or whether it
>>> would make sense to somehow handle part of this in the generic VFS
>>> code and give the user the ability to prepare a new files_struct that
>>> can then be transferred to the worker thread, or something like
>>> that... I'm not sure whether there's a particularly clean way to do
>>> that though.
>>
>> Using files_struct for that opens a can of worms you really don't
>> want to touch.
>>
>> Consider the following scenario with any variant of this interface:
>> 	* create io_uring fd.
>> 	* send an SCM_RIGHTS with that fd to AF_UNIX socket.
>> 	* add the descriptor of that AF_UNIX socket to your fd
>> 	* close AF_UNIX fd, close io_uring fd.
>> Voila - you've got a shiny leak.  No ->release() is called for
>> anyone (and you really don't want to do that on ->flush(), because
>> otherwise a library helper doing e.g. system("/bin/date") will tear
>> down all the io_uring in your process).  The socket is held by
>> the reference you've stashed into io_uring (whichever way you do
>> that).  io_uring is held by the reference you've stashed into
>> SCM_RIGHTS datagram in queue of the socket.
>>
>> No matter what, you need net/unix/garbage.c to be aware of that stuff.
>> And getting files_struct lifetime mixed into that would be beyond
>> any reason.
>>
>> The only reason for doing that as a descriptor table would be
>> avoiding the cost of fget() in whatever uses it, right?  Since
> 
> Right, the only purpose of this patch is to avoid doing fget/fput for
> each IO.
> 
>> those are *not* the normal syscalls (and fdget() really should not
>> be used anywhere other than the very top of syscall's call chain -
>> that's another reason why tossing file_struct around like that
>> is insane) and since the benefit is all due to the fact that it's
>> *NOT* shared, *NOT* modified in parallel, etc., allowing us to
>> treat file references as stable... why the hell use the descriptor
>> tables at all?
> 
> This one is not a regular system call, since we don't do fget, then IO,
> then fput. We hang on to it. But for the non-registered case, it's very
> much just like a regular read/write system call, where we fget to do IO
> on it, then fput when we are done.
> 
>> All you need is an array of struct file *, explicitly populated.
>> With net/unix/garbage.c aware of such beasts.  Guess what?  We
>> do have such an object already.  The one net/unix/garbage.c is
>> working with.  SCM_RIGHTS datagrams, that is.
>>
>> IOW, can't we give those io_uring descriptors associated struct
>> unix_sock?  No socket descriptors, no struct socket (probably),
>> just the AF_UNIX-specific part thereof.  Then teach
>> unix_inflight()/unix_notinflight() about getting unix_sock out
>> of these guys (incidentally, both would seem to benefit from
>> _not_ touching unix_gc_lock in case when there's no unix_sock
>> attached to file we are dealing with - I might be missing
>> something very subtle about barriers there, but it doesn't
>> look likely).
> 
> That might be workable, though I'm not sure we currently have helpers to
> just explicitly create a unix_sock by itself. Not familiar with the
> networking bits at all, I'll take a look.
> 
>> And make that (i.e. registering the descriptors) mandatory.
> 
> I don't want to make it mandatory, that's very inflexible for managing
> tons of files. The registration is useful for specific cases where we
> have high frequency of operations on a set of files. Besides, it'd make
> the use of the API cumbersome as well for the basic case of just wanting
> to do async IO.
> 
>> Hell, combine that with creating io_uring fd, if we really
>> care about the syscall count.  Benefits:
> 
> We don't care about syscall count for setup as much. If you're doing
> registration of a file set, you're expected to do a LOT of IO to those
> files. Hence having an extra one for setup is not a concern. My concern
> is just making it mandatory to do registration, I don't think that's a
> workable alternative.
> 
>> 	* no file_struct refcount wanking
>> 	* no fget()/fput() (conditional, at that) from kernel
>> threads
>> 	* no CLOEXEC-dependent anything; just the teardown
>> on the final fput(), whichever way it comes.
>> 	* no fun with duelling garbage collectors.
> 
> The fget/fput from a kernel thread can be solved by just hanging on to
> the struct file * when we punt the IO. Right now we don't, which is a
> little silly, that should be changed.
> 
> Getting rid of the files_struct{} is doable.

OK, I've reworked the initial parts to wire up the io_uring fd to the
AF_UNIX garbage collection. As I made it to the file registration part,
I wanted to wire up that too. But I don't think there's a need for that
- if we have the io_uring fd appropriately protected, we'll be dropping
our struct file ** array index when the io_uring fd is released. That
should be adequate, we don't need the garbage collection to be aware of
those individually.

The only part I had to drop for now is the sq thread polling, as that
depends on us carrying the files_struct. I'm going to fold that in
shortly, but just make it be dependent on having registered files. That
avoids needing to fget/fput for that case, and needing registered files
for the sq side submission/polling is not a usability issue like it
would be for the "normal" use cases.

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
