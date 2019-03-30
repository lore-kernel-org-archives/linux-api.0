From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 2/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 15:37:27 +0100
Message-ID: <20190330143726.6aaxz4sctu3pzpyx@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io>
 <20190329155425.26059-3-christian@brauner.io>
 <f0d590b96b7d11ae21a9a06040b8ffa85fa74e2a.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f0d590b96b7d11ae21a9a06040b8ffa85fa74e2a.camel@bitron.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SsO8cmc=?= Billeter <j@bitron.ch>, torvalds@linux-foundation.org
Cc: jannh@google.com, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, ebiederm@xmission.com, khlebnikov@yandex-team.ru, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 12:53:57PM +0100, Jürg Billeter wrote:
> On Fri, 2019-03-29 at 16:54 +0100, Christian Brauner wrote:
> > diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
> > index ac49a220cf2a..d6c7c0701997 100644
> > --- a/include/uapi/linux/wait.h
> > +++ b/include/uapi/linux/wait.h
> > @@ -18,5 +18,7 @@
> >  #define P_PID		1
> >  #define P_PGID		2
> >  
> > +/* Get a file descriptor for /proc/<pid> of the corresponding pidfd
> > */
> > +#define PIDFD_GET_PROCFD _IOR('p', 1, int)
> >  
> >  #endif /* _UAPI_LINUX_WAIT_H */
> 
> This is missing an entry in Documentation/ioctl/ioctl-number.txt and is
> actually conflicting with existing entries.

Thanks. Yes, Jann mentioned this too.

> 
> However, I'd actually prefer a syscall to allow strict whitelisting via
> seccomp and avoid the other ioctl disadvantages that Daniel has already
> mentioned.

You can filter ioctls with seccomp.

I have compromised quite a bit now and I think what we have is perfectly
fine. a single clean syscalls pidfd_open() that lets you get pidfds for
threads and thread-group leaders independent of procfs and a clean,
simple fd->fd converstion ioctl() that is a property of the f_ops of the
pidfd to get an fd to /proc/<pid> for metadata access. Btw, this being a
part of the pidfd f_ops seems strikingly elegant to me. Because it
expresses the notion that the metadata is implicitly part of the pidfd
nicely. But I might just be dumb.

I do not see the need to add another syscall that is conditional on
CONFIG_PROC_FS and only does a pidfd to /proc/<pid>-fd conversion.
That's almost the definition of what an ioctl() is most suited for.

I get the opposition to multiplexers but consider if we where to oppose
all of them. Let's leave ioctls out and just look at a few widely used
multiplexer syscalls:

1. seccomp()
   - number of supported commands:   4

2. prctl()
   - number of supported commands:  45

3. keyctl()
   - number of supported commands:  25

4. bpf()
   - number of supported commands:  18

5. proposed fsconfig()
   - number of supported commands:   8

Total Number of required syscalls: 100

That means for bpf() alone Linux would have had to gain *18* additional
single syscalls and for the new mount api only for configuring a mount
context 8 additional syscalls would need to be pulled.
That all hinges on the argument that "syscalls are cheap" and that
running out of syscall numbers is not a real problem because there is a
patchset that lifts this restriction _eventually_. That patchset hasn't
been merged yet and I have not even seen it sent out yet. So we're still
short of syscall numbers. _Even_ if this patchset would have landed,
adding 26 syscalls for two apis seems excessive.
So unless Linus jumps in here (Cced) and says that he's fine that the
pidfd to /proc/<pid>-fd conversion is suited for yet another syscalls
what we have here is perfectly acceptable.
Again, as I've said before I don't see the point in sending piles of
syscalls when it is not really justified and I find none of the
arguments against this implementation we have here right now very
convincing.

Christian
