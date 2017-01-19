From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: writev error codes
Date: Thu, 19 Jan 2017 02:47:58 +0000
Message-ID: <20170119024758.GA27291@ZenIV.linux.org.uk>
References: <20170118154431.GD7021@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118154431.GD7021-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 18, 2017 at 04:44:31PM +0100, Michal Hocko wrote:
> Hi,
> we have noticed that one of the LTP tests started to fail after
> 99526912c934 ("fix iov_iter_fault_in_readable()"). The code has expected
> EINVAL while it gets EFAULT. I believe the new behavior is reasonable,
> but checking the man 2 writev, there is no mention about EFAULT,
> and other errnos for that matter, so it seems this is rather under
> documented and it can confuse users. LTP has been fixed in the meantime
> [1] but this might come unexpected to others.
> 
> In principle writev as a write
> "multiplier" should be allowed all the error codes that write(2) allows,
> right? I am not sure how we should reflect that. Either c&p what we have
> in man 2 write or put a reference to it and only describe writev
> specific, if there are any (I haven't checked that).

FWIW, EFAULT-related parts in POSIX are very weak.

2.3 Error Numbers:

[EFAULT]
    Bad address. The system detected an invalid address in attempting to
    use an argument of a call. The reliable detection of this error cannot
    be guaranteed, and when not detected may result in the generation of a
    signal, indicating an address violation, which is sent to the process.

B.2.3 Error Numbers:

POSIX.1 requires (in the ERRORS sections of function descriptions)
certain error values to be set in certain conditions because many
existing applications depend on them. Some error numbers, such as
[EFAULT], are entirely implementation-defined and are noted as such in
their description in the ERRORS section. This section otherwise allows
wide latitude to the implementation in handling error reporting.

idem:

[EFAULT]
    Most historical implementations do not catch an error and set errno
    when an invalid address is given to the functions wait(), time(),
    or times(). Some implementations cannot reliably detect an invalid
    address. And most systems that detect invalid addresses will do so
    only for a system call, not for a library routine.

idem, in discussion of thread IDs:

As with other interfaces that take pointer parameters, the outcome of
passing an invalid parameter can result in an invalid memory reference
or an attempt to access an undefined portion of a memory object, cause
signals to be sent (SIGSEGV or SIGBUS) and possible termination of the
process. This is a similar case to passing an invalid buffer pointer to
read(). Some implementations might implement read() as a system call and
set an [EFAULT] error condition. Other implementations might contain
parts of read() at user level and the first attempt to access data at
an invalid reference will cause a signal to be sent instead.

and for execve(2) et.al. there's
[EFAULT]
    Some historical systems return [EFAULT] rather than [ENOEXEC] when
    the new process image file is corrupted. They are non-conforming.

And that's it - this is the only syscall page that explicitly mentions
EFAULT (and that - as "don't return it for that case").  read(2),
write(2), writev(2), etc. all get EFAULT implicitly from 2.3.

In particular, how far would e.g. writev(2) get in case when some parts of
the source buffer(s) are at invalid address is not guaranteed at all.
We get either a short write or EFAULT; it is not (and never had been)
guaranteed that ever byte prior to the first invalid address will be
written out.  Moreover, the amount of potentially fetchable bytes _not_
written is (and always had been) file-dependent.  Generally we try to
keep it bounded by page size, but even that is not guarateed - e.g. a driver
might very well take "all or nothing" policy and treat everything short of
successfully reading all the source buffer as "fail with EFAULT, nothing
gets written".  For regular files on more or less normal filesystems the
actual rule is "discard anything starting at the last covered file offset
divisible by page size" - IOW, two writev() to the same file with identical
iovec array can result in short writes of different lengths if the latter call
is preceded by lseek().  Again, details of behaviour depend upon the file
you are writing to, and that's just for Linux - other Unices have rules of
their own.  No userland code should ever rely upon the specific rules here;
if you have an invalid address anywhere in the source buffers, you can
(on Linux) count upon a short write of some length or EFAULT.  Anything
more specific depends upon a lot of factors.
