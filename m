From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/18] io_uring: add file set registration
Date: Thu, 7 Feb 2019 04:00:59 +0000
Message-ID: <20190207040058.GW2217@ZenIV.linux.org.uk>
References: <20190129192702.3605-1-axboe@kernel.dk>
 <20190129192702.3605-14-axboe@kernel.dk>
 <CAG48ez2kLWUEambWesQQaeVn_u=PtjuMeDUc49yamhYspfd7Sg@mail.gmail.com>
 <20190204025612.GR2217@ZenIV.linux.org.uk>
 <785c6db4-095e-65b0-ded5-72b41af5174e@kernel.dk>
 <2b2137ed-8107-f7b6-f0ca-202dcfb87c97@kernel.dk>
 <40b27e78-9ee8-1395-feb3-a73aac87c9a7@kernel.dk>
 <20190206005638.GU2217@ZenIV.linux.org.uk>
 <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <8f124de2-d6da-d656-25e4-b4d9e58f880e@kernel.dk>
Sender: owner-linux-aio@kvack.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>, linux-aio@kvack.org, linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>, hch@lst.de, jmoyer@redhat.com, avi@scylladb.com, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 06, 2019 at 06:41:00AM -0700, Jens Axboe wrote:
> On 2/5/19 5:56 PM, Al Viro wrote:
> > On Tue, Feb 05, 2019 at 12:08:25PM -0700, Jens Axboe wrote:
> >> Proof is in the pudding, here's the main commit introducing io_uring
> >> and now wiring it up to the AF_UNIX garbage collection:
> >>
> >> http://git.kernel.dk/cgit/linux-block/commit/?h=io_uring&id=158e6f42b67d0abe9ee84886b96ca8c4b3d3dfd5
> >>
> >> How does that look?
> > 
> > In a word - wrong.  Some theory: garbage collector assumes that there is
> > a subset of file references such that
> > 	* for all files with such references there's an associated unix_sock.
> > 	* all such references are stored in SCM_RIGHTS datagrams that can be
> > found by the garbage collector (currently: for data-bearing AF_UNIX sockets -
> > queued SCM_RIGHTS datagrams, for listeners - SCM_RIGHTS datagrams sent via
> > yet-to-be-accepted connections).
> > 	* there is an efficient way to count those references for given file
> > (->inflight of the corresponding unix_sock).
> > 	* removal of those references would render the graph acyclic.
> > 	* file can _NOT_ be subject to syscalls unless there are references
> > to it outside of that subset.
> 
> IOW, we cannot use fget() for registering files, and we still need fget/fput
> in the fast path to retain safe use of the file. If I'm understanding you
> correctly?

No.  *ALL* references (inflight and not) are the same for file->f_count.
unix_inflight() does not grab a new reference to file; it only says that
reference passed to it by the caller is now an in-flight one.

OK, braindump time:

Lifetime for struct file is controlled by a simple refcount.  Destructor
(__fput() and ->release() called from it) is called once the counter hits
zero.  Which is fine, except for the situations when some struct file
references are pinned down in structures reachable only via our struct file
instance.

Each file descriptor counts as a reference.  IOW, dup() will increment
the refcount by 1, close() will decrement it, fork() will increment it
by the number of descriptors in your descriptor table refering to this
struct file, desctruction of descriptor table on exit() will decrement
by the same amount, etc.

Syscalls like read() and friends turn descriptor(s) into struct file
references.  If descriptor table is shared, that counts as a new reference
that must be dropped in the end of syscall.  If it's not shared, we are
guaranteed that the reference in descriptor table will stay around until
the end of syscall, so we may use it without bumping the file refcount.
That's the difference between fget() and fdget() - the former will
bump the refcount, the latter will try to avoid that.  Of course, if
we do not intend to drop the reference we'd acquired by the end of
syscall, we want fget() - fdget() is for transient references only.

Descriptor tables (struct files) *can* be shared; several processes
(usually - threads that share VM as well, but that's not necessary)
may be working with the same instance of struct files, so e.g. open()
in one of them is seen by the others.  The same goes for close(),
dup(), dup2(), etc.

That makes for an interesting corner case - what if two threads happen
to share a descriptor table and we have close(fd) in one of them
in the middle of read(fd, ..., ...) in another?  That's one aread where
Unices differ - one variant is to abort read(), another - to have close()
wait for read() to finish, etc.  What we do is
	* close() succeeds immediately; the reference is removed from
descriptor table and dropped.
	* if close(fd) has happened before read(fd, ...) has converted
fd to struce file reference, read() will get -EBADF.
	* otherwise, read() proceeds unmolested; the reference it has
acquired is dropped in the end of syscall.  If that's the last reference
to struct file, struct file will get shut down at that point.

clone(2) will have the child sharing descriptor table of parent if
CLONE_FILES is in the flags.  Note that in this case struct file
refcounts are not modified at all - no new references to files are
created.  Without CLONE_FILES it's the same as fork() - an independent
copy of descriptor table is created and populated by copies of references
to files, each bumping file's refcount.

unshare(2) with CLONE_FILES in flags will get a copy of descriptor table
(same as done on fork(), etc.) and switch to using it; the old reference
is dropped (note: it'll only bother with that if descriptor table used
to be shared in the first place - if we hold the only reference to
descriptor table, we'll just keep using it).

execve(2) does almost the same - if descriptor table used to be shared,
it will switch to a new copy first; in case of success the reference
to original is dropped, in case of failure we revert to original and
drop the copy.  Note that handling of close-on-exec is done in the _copy_
- the original is unaffected, so failing execve() does not disrupt the
descriptor table.

exit(2) will drop the reference to descriptor table.  When the last
reference is dropped, all file references are removed from it (and dropped).

The thread's pointer to descriptor table (current->files) is never
modified by other thread; something like ls /proc/<pid>/fd will fetch
it, so stores need to be protected (by task_lock(current)), but
the only the thread itself can do them.  

Note that while extra references to descriptor table can appear at any
time (/proc/<pid>/fd accesses, for example), such references may not
be used for modifications.  In particular, you can't switch to another
thread's descriptor table, unless it had been yours at some earlier
point _and_ you've kept a reference to it.

That's about it for descriptor tables; that, by far, is the main case
of persistently held struct file references.  Transient references
are grabbed by syscalls when they resolve descriptor to struct file *,
which ought to be done once per syscall _and_ reasonably early in
it.  Unfortunately, that's not all - there are other persistent struct
file references.

The things like "LOOP_SET_FD grabs a reference to struct file and
stashes it in ->lo_backing_file" are reasonably simple - the reference
will be dropped later, either directly by LOOP_CLR_FD (if nothing else
held the damn thing open at the time) or later in lo_release().
Note that in the latter case it's possible to get "close() of
/dev/loop descriptor drops the last reference to it, triggering
bdput(), which happens to by the last thing that held block device
opened, which triggers lo_release(), which drops the reference to
underlying struct file (almost certainly the last one by that point)".
It's still not a problem - while we have the underlying struct file
pinned by something held by another struct file, the dependencies'
graph is acyclic, so plain refcounts we are using work fine.

The same goes for the things like e.g. ecryptfs opening an underlying
(encrypted) file on open() and dropping it when the last reference
to ecryptfs file is dropped - the only difference here is that the
underlying struct file is never appearing in _anyone's_ descriptor
tables.

However, in a couple of cases we do have something trickier.

Case 1: SCM_RIGHTS datagram can be sent to an AF_UNIX socket.  That
converts the caller-supplied array of descriptors into an array of
struct file references, which gets attached to the packet we queue.
When the datagram is received, the struct file references are
moved into the descriptor table of recepient or, in case of error,
dropped.  Note that sending some descriptors in an SCM_RIGHTS datagram
and closing them is perfectly legitimate - as soon as sendmsg(2)
returns you can go ahead and close the descriptors you've sent;
the references are already acquired and you don't need to wait for
the packet to be received.

That would still be simple, if not for the fact that there's nothing
to stop you from passing AF_UNIX sockets around the same way.  In fact,
that has legitimate uses and, most of the time, doesn't cause any
complications at all.  However, it is possible to get the situation
when
	* struct file instances A and B are both AF_UNIX sockets.
	* the only reference to A is in the SCM_RIGHTS packet that
sits in the receiving queue of B.
	* the only reference to B is in the SCM_RIGHTS packet that
sits in the receiving queue of A.
That, of course, is where the pure refcounting of any kind will break.

SCM_RIGHTS datagram that contains the sole reference to A can't be
received without the recepient getting hold of a reference to B.
Which cannot happen until somebody manages to receive the SCM_RIGHTS
datagram containing the sole reference to B.  Which cannot happen
until that somebody manages to get hold of a reference to A,
which cannot happen until the first SCM_RIGHTS datagram is
received.

Dropping the last reference to A would've discarded everything in
its receiving queue, including the SCM_RIGHTS that contains the
reference to B; however, that can't happen either - the other
SCM_RIGHTS datagram would have to be either received or discarded
first, etc.

Case 2: similar, with a bit of a twist.  AF_UNIX socket used for
descriptor passing is normally set up by socket(), followed by
connect().  As soon as connect() returns, one can start sending.
Note that connect() does *NOT* wait for the recepient to call
accept() - it creates the object that will serve as low-level
part of the other end of connection (complete with received
packet queue) and stashes that object into the queue of *listener*
socket.  Subsequent accept() fetches it from there and attaches
it to a new socket, completing the setup; in the meanwhile,
sending packets works fine.  Once accept() is done, it'll see
the stuff you'd sent already in the queue of the new socket and
everything works fine.

If the listening socket gets closed without accept() having
been called, its queue is flushed, discarding all pending
connection attempts, complete with _their_ queues.  Which is
the same effect as accept() + close(), so again, normally
everything just works.

However, consider the case when we have
	* struct file instances A and B being AF_UNIX sockets.
	* A is a listener
	* B is an established connection, with the other end
yet to be accepted on A
	* the only references to A and B are in an SCM_RIGHTS
datagram sent over by A.

That SCM_RIGHTS datagram could've been received, if somebody
had managed to call accept(2) on A and recvmsg(2) on the
socket created by that accept(2).  But that can't happen
without that somebody getting hold of a reference to A in
the first place, which can't happen without having received
that SCM_RIGHTS datagram.  It can't be discarded either,
since that can't happen without dropping the last reference
to A, which sits right in it.

The difference from the previous case is that there we had
	A holds unix_sock of A
	unix_sock of A holds SCM_RIGHTS with reference to B
	B holds unix_sock of B
	unix_sock of B holds SCM_RIGHTS with reference to A
and here we have
	A holds unix_sock of A
	unix_sock of A holds the packet with reference to embryonic
unix_sock created by connect()
	that embryionic unix_sock holds SCM_RIGHTS with references
to A and B.

Dependency graph is different, but the problem is the same -
unreachable loops in it.  Note that neither class of situations
would occur normally - in the best case it's "somebody had been
doing rather convoluted descriptor passing, but everyone involved
got hit with kill -9 at the wrong time; please, make sure nothing
leaks".  That can happen, but a userland race (e.g. botched protocol
handling of some sort) or a deliberate abuse are much more likely.

Catching the loop creation is hard and paying for that every time
we do descriptor-passing would be a bad idea.  Besides, the loop
per se is not fatal - e.g if in the second case the descriptor for
A had been kept around, close(accept()) would've cleaned everything
up.  Which means that we need a garbage collector to deal with
the (rare) leaks.

Note that in both cases the leaks are caused by loops passing through
some SCM_RIGHTS datagrams that could never be received.  So locating
those, removing them from the queues they sit in and then discarding
the suckers is enough to resolve the situation.

Furthermore, in both cases the loop passes through unix_sock of
something that got sent over in an SCM_RIGHTS datagram.  So we
can do the following:
	1) keep the count of references to struct file of AF_UNIX
socket held by SCM_RIGHTS (kept in unix_sock->inflight).  Any
struct unix_sock instance without such references is not a part of
unreachable loop.  Maintain the set of unix_sock that are not excluded
by that (i.e. the ones that have some of references from SCM_RIGHTS
instances).  Note that we don't need to maintain those counts in
struct file - we care only about unix_sock here.
	2) struct file of AF_UNIX socket with some references
*NOT* from SCM_RIGHTS is also not a part of unreachable loop.
	3) for each unix_sock consider the following set of
SCM_RIGHTS: everything in queue of that unix_sock if it's
a non-listener and everything in queues of all embryonic unix_sock
in queue of a listener.  Let's call those SCM_RIGHTS associated
with our unix_sock.
	4) all SCM_RIGHTS associated with a reachable unix_sock
are reachable.
	5) if some references to struct file of a unix_sock
are in reachable SCM_RIGHTS, it is reachable.

Garbage collector starts with calculating the set of potentially
unreachable unix_sock - the ones not excluded by (1,2).
No unix_sock instances outside of that set need to be considered.

If some unix_sock in that set has counter _not_ entirely covered
by SCM_RIGHTS associated with the elements of the set, we can
conclude that there are references to it in SCM_RIGHTS associated
with something outside of our set and therefore it is reachable
and can be removed from the set.

If that process converges to a non-empty set, we know that
everything left in that set is unreachable - all references
to their struct file come from _some_ SCM_RIGHTS datagrams
and all those SCM_RIGHTS datagrams are among those that can't
be received or discarded without getting hold of a reference
to struct file of something in our set.

Everything outside of that set is reachable, so taking the
SCM_RIGHTS with references to stuff in our set (all of
them to be found among those associated with elements of
our set) out of the queues they are in will break all
unreachable loops.  Discarding the collected datagrams
will do the rest - file references in those will be
dropped, etc.

One thing to keep in mind here is the locking.  What the garbage
collector relies upon is
	* changes of ->inflight are serialized with respect to
it (on unix_gc_lock; increment done by unix_inflight(),
decrement - by unix_notinflight()).
	* references cannot be extracted from SCM_RIGHTS datagrams
while the garbage collector is running (achieved by having
unix_notinflight() done before references out of SCM_RIGHTS)
	* removal of SCM_RIGHTS associated with a socket can't
be done without a reference to that socket _outside_ of any
SCM_RIGHTS (automatically true).
	* adding SCM_RIGHTS in the middle of garbage collection
is possible, but in that case it will contain no references to
anything in the initial candidate set.

The last one is delicate.  SCM_RIGHTS creation has unix_inflight()
called for each reference we put there, so it's serialized wrt
unix_gc(); however, insertion into queue is *NOT* covered by that -
queue rescans are, but each queue has a lock of its own and they
are definitely not going to be held throughout the whole thing.

So in theory it would be possible to have
	* thread A: sendmsg() has SCM_RIGHTS created and populated,
complete with file refcount and ->inflight increments implied,
at which point it gets preempted and loses the timeslice.
	* thread B: gets to run and removes all references
from descriptor table it shares with thread A.
	* on another CPU we have garbage collector triggered;
it determines the set of potentially unreachable unix_sock and
everything in our SCM_RIGHTS _is_ in that set, now that no
other references remain.
	* on the first CPU, thread A regains the timeslice
and inserts its SCM_RIGHTS into queue.  And it does contain
references to sockets from the candidate set of running
garbage collector, confusing the hell out of it.


That is avoided by a convoluted dance around the SCM_RIGHTS creation
and insertion - we use fget() to obtain struct file references,
then _duplicate_ them in SCM_RIGHTS (bumping a refcount for each, so
we are holding *two* references), do unix_inflight() on them, then
queue the damn thing, then drop each reference we got from fget().

That way everything refered to in that SCM_RIGHTS is going to have
extra struct file references (and thus be excluded from the initial
candidate set) until after it gets inserted into queue.  In other
words, if it does appear in a queue between two passes, it's
guaranteed to contain no references to anything in the initial
canidate set.

End of braindump.
===================================================================

What you are about to add is *ANOTHER* kind of loops - references
to files in the "registered" set are pinned down by owning io_uring.

That would invalidate just about every assumption made the garbage
collector - even if you forbid to register io_uring itself, you
still can register both ends of AF_UNIX socket pair, then pass
io_uring in SCM_RIGHTS over that, then close all descriptors involved.
>From the garbage collector point of view all sockets have external
references, so there's nothing to collect.  In fact those external
references are only reachable if you have a reachable reference
to io_uring, so we get a leak.

To make it work:
	* have unix_sock created for each io_uring (as your code does)
	* do *NOT* have unix_inflight() done at that point - it's
completely wrong there.
	* file set registration becomes
		* create and populate SCM_RIGHTS, with the same
fget()+grab an extra reference + unix_inflight() sequence.
Don't forget to have skb->destructor set to unix_destruct_scm
or equivalent thereof.
		* remember UNIXCB(skb).fp - that'll give you your
array of struct file *, to use in lookups.
		* queue it into your unix_sock
		* do _one_ fput() for everything you've grabbed,
dropping one of two references you've taken.
	* unregistering is simply skb_dequeue() + kfree_skb().
	* in ->release() you do sock_release(); it'll do
everything you need (including unregistering the set, etc.)

The hairiest part is the file set registration, of course -
there's almost certainly a helper or two buried in that thing;
simply exposing all the required net/unix/af_unix.c bits is
ucking fugly.

I'm not sure what you propose for non-registered descriptors -
_any_ struct file reference that outlives the return from syscall
stored in some io_uring-attached data structure is has exact same
loop (and leak) problem.  And if you mean to have it dropped before
return from syscall, I'm afraid I don't follow you.  How would
that be done?

Again, "io_uring descriptor can't be used in those requests" does
not help at all - use a socket instead, pass the io_uring fd over
it in SCM_RIGHTS and you are back to square 1.

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
