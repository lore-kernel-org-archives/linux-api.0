From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Date: Wed, 21 Jan 2009 10:31:27 +0100
Message-ID: <4976EB6F.5090503@redhat.com>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de> <4970DDF9.4090007@redhat.com> <49748C1B.8090205@redhat.com> <20090121001131.GF21648@machine.or.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20090121001131.GF21648@machine.or.cz>
Sender: linux-arch-owner@vger.kernel.org
To: Petr Baudis <pasky@suse.cz>
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, aarcange@redhat.com
List-Id: linux-api@vger.kernel.org

Petr Baudis wrote:
> On Mon, Jan 19, 2009 at 03:20:11PM +0100, Gerd Hoffmann wrote:
>> I do see the point in adding a interface like this ...
>>
>>>    ssize_t readz (int fd, void *buf, size_t len, void **res)
>> ... to help the kernel do zero-copy I/O.
>>
>> I think system calls for vector I/O are *not* the right place for that
>> though.  Usually applications use vectored I/O because they *do* care
>> about the place the data is stored, because vectored I/O allows them to
>> avoid copying data within the application.
> 
> Can you elaborate on this? An application would have to have quite a
> contrived design if its pointers simply cannot be updated according
> to what the kernel returns.

Well.  The "just update the pointers" argument is bogous.  It simply
doesn't work in general for a number of reasons:

First, it assumes that there is a pointer you can update in the first place.

Second, it assumes you can easily update all pointer instances pointing
to your data.  Finding all places which need updating might be
non-trivial or impossible.  This tends to be true for refcounted data
structures.

Third, updating pointers can have extra costs, such as locking
requirements in threaded applications.

Of course there are also tons of applications where it is absolutely no
problem to just update the pointer.

But I think that applications using the vectored I/O very likely belong
to the group which can't.  Otherwise there would be little reason to use
the vectored API in the first place.

> Then again, I'm not sure why wouldn't readv() actually be
> zerocopy-ready. Just make sure you handle iov_base being NULL gracefully
> now (EINVAL, with the remark that the kernel can write to the iovec
> memory area in the future) and later the kernel can in that case set
> iov_base to the buffer location?

You could (assuming you don't break POSIX along the way).  I don't think
apps would use such an interface though for the reasons outlined above.
 The readz() prototype by Ullrich (without iovecs being involved) looks
much more reasonable to me.

cheers,
  Gerd
