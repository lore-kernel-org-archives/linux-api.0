From: Rich Felker <dalias@libc.org>
Subject: Re: Proposal to fix pwrite with O_APPEND via pwritev2 flag
Date: Fri, 24 Jan 2020 09:07:21 -0500
Message-ID: <20200124140721.GV30412@brightrain.aerifal.cx>
References: <20200124000243.GA12112@brightrain.aerifal.cx>
 <87d0b942lp.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d0b942lp.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 24, 2020 at 10:37:22AM +0100, Florian Weimer wrote:
> * Rich Felker:
> 
> > There's a longstanding unfixable (due to API stability) bug in the
> > pwrite syscall:
> >
> > http://man7.org/linux/man-pages/man2/pwrite.2.html#BUGS
> >
> > whereby it wrongly honors O_APPEND if set, ignoring the caller-passed
> > offset. Now that there's a pwritev2 syscall that takes a flags
> > argument, it's possible to fix this without breaking stability by
> > adding a new RWF_NOAPPEND flag, which callers that want the fixed
> > behavior can then pass.
> >
> > I have a completely untested patch to add such a flag, but would like
> > to get a feel for whether the concept is acceptable before putting
> > time into testing it. If so, I'll submit this as a proper patch with
> > detailed commit message etc. Draft is below.
> 
> Has this come up before?

I'm not sure if there's an open glibc bug for it or not, but it's come
up in musl community before that the kernel is non-conforming here for
historical reasons (preserving the original bug in case any software
is depending on it) and we've always wanted to have a fix, but
couldn't find one short of just erroring out if O_APPEND is set when
pwrite is called. That's what the fallback will do (rather than
silently write data at the wrong place) if pwritev2+RWF_NOAPPEND is
not supported on the system at runtime.

> I had already written a test case and it turns out that an O_APPEND
> descriptor does not protect the previously written data in the file:
> 
> openat(AT_FDCWD, "/tmp/append-truncateuoRexJ", O_RDWR|O_CREAT|O_EXCL, 0600) = 3
> write(3, "@", 1)                        = 1
> close(3)                                = 0
> openat(AT_FDCWD, "/tmp/append-truncateuoRexJ", O_WRONLY|O_APPEND) = 3
> ftruncate(3, 0)                         = 0
> 
> So at least it looks like there is no security issue in adding a
> RWF_NOAPPEND flag.

Indeed, if you have the file open you can just use fcntl to remove
O_APPEND (but of course using that in an emulation would be racy), so
it's not a security boundary. Someone could try to "make it into one"
with seccomp, blocking fcntl that would remove O_APPEND and blocking
ftruncate, mmap, and all other ways you could modify the existing part
of the file, but that sounds fragile, and if they really want to do
that they can block pwritev2 as well (or at least block it with
RWF_NOAPPEND or future/unknown flags).

Rich
