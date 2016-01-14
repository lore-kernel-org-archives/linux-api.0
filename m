From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] aio: enabled thread based async fsync
Date: Thu, 14 Jan 2016 10:19:56 +0100
Message-ID: <5697683C.5070402@redhat.com>
References: <cover.1452549431.git.bcrl@kvack.org>
 <80934665e0dd2360e2583522c7c7569e5a92be0e.1452549431.git.bcrl@kvack.org>
 <20160112011128.GC6033@dastard>
 <CA+55aFxtvMqHgHmHCcszV_QKQ2BY0wzenmrvc6BYN+tLFxesMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CA+55aFxtvMqHgHmHCcszV_QKQ2BY0wzenmrvc6BYN+tLFxesMA@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org



On 12/01/2016 02:20, Linus Torvalds wrote:
> On Mon, Jan 11, 2016 at 5:11 PM, Dave Chinner <david@fromorbit.com> wro=
te:
>>
>> Insufficient. Needs the range to be passed through and call
>> vfs_fsync_range(), as I implemented here:
>=20
> And I think that's insufficient *also*.
>=20
> What you actually want is "sync_file_range()", with the full set of arg=
uments.
>=20
> Yes, really. Sometimes you want to start the writeback, sometimes you
> want to wait for it. Sometimes you want both.
>=20
> For example, if you are doing your own manual write-behind logic, it
> is not sufficient for "wait for data". What you want is "start IO on
> new data" followed by "wait for old data to have been written out".
>=20
> I think this only strengthens my "stop with the idiotic
> special-case-AIO magic already" argument.  If we want something more
> generic than the usual aio, then we should go all in. Not "let's make
> more limited special cases".

The question is, do we really want something more generic than the usual
AIO?

Virt is one of the 10 (that's a binary number) users of AIO, and we
don't even use it by default because in most cases it's really a wash.

Let's compare AIO with a simple userspace thread pool.

AIO has the ability to submit and retrieve the results of multiple
operations at once.  Thread pools do not have the ability to submit
multiple operations at a time (you could play games with FUTEX_WAKE, but
then all the threads in the pool would have cacheline bounces on the fute=
x).

The syscall overhead on the critical path is comparable.  For AIO it's
io_submit+io_getevents, for a thread pool it's FUTEX_WAKE plus invoking
the actual syscall.  Again, the only difference for AIO is batching.

Unless userspace is submitting tens of thousands of operations per
second, which is pretty much the case only for read/write, there's no
real benefit in asynchronous system calls over a userspace thread pool.
 That applies to openat, unlinkat, fadvise (for readahead).  It also
applies to msync and fsync, etc. because if your workload is doing tons
of those you'd better buy yourself a disk with a battery-backed cache,
or an UPS, and remove the msync/fsync altogether.

So I'm really happy if we can move the thread creation overhead for such
a thread pool to the kernel.  It keeps the benefits of batching, it uses
the optimized kernel workqueues, it doesn't incur the cost of pthreads,
it makes it easy to remove the cases where AIO is blocking, it makes it
easy to add support for !O_DIRECT.  But everything else seems overkill.

Paolo

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=3Dmailto:"aart@kvack.org">aart@kvack.org</a>
