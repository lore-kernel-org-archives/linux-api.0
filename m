From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH v5 2/3] pid: Introduce pidfd_getfd syscall
Date: Sun, 22 Dec 2019 21:15:58 +0100
Message-ID: <20191222201556.zcjceuwpel26jo37@wittgenstein>
References: <20191220232810.GA20233@ircssh-2.c.rugged-nimbus-611.internal>
 <20191222124756.o2v2zofseypnqg3t@wittgenstein>
 <CAMp4zn-x3wiYVgmoVfkA61Epfh7JoEHUn5QCpULERxLPkLoMYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn-x3wiYVgmoVfkA61Epfh7JoEHUn5QCpULERxLPkLoMYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: Emilio Cobos =?utf-8?Q?=C3=81lvarez?= <ealvarez@mozilla.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, Gian-Carlo Pascutto <gpascutto@mozilla.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Jed Davis <jld@mozilla.com>, LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 22, 2019 at 10:36:42AM -0800, Sargun Dhillon wrote:
> , On Sun, Dec 22, 2019 at 4:48 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > On Fri, Dec 20, 2019 at 11:28:13PM +0000, Sargun Dhillon wrote:
> > > This syscall allows for the retrieval of file descriptors from other
> > > processes, based on their pidfd. This is possible using ptrace, and
> > > injection of parasitic code along with using SCM_RIGHTS to move
> > > file descriptors between a tracee and a tracer. Unfortunately, ptrace
> > > comes with a high cost of requiring the process to be stopped, and
> > > breaks debuggers. This does not require stopping the process under
> > > manipulation.
> > >
> > > One reason to use this is to allow sandboxers to take actions on file
> > > descriptors on the behalf of another process. For example, this can be
> > > combined with seccomp-bpf's user notification to do on-demand fd
> > > extraction and take privileged actions. For example, it can be used
> > > to bind a socket to a privileged port.
> > >
> > > /* prototype */
> > >   /*
> > >    * pidfd_getfd_options is an extensible struct which can have options
> > >    * added to it. If options is NULL, size, and it will be ignored be
> > >    * ignored, otherwise, size should be set to sizeof(*options). If
> > >    * option is newer than the current kernel version, E2BIG will be
> > >    * returned.
> > >    */
> > >   struct pidfd_getfd_options {};
> > >   long pidfd_getfd(int pidfd, int fd, unsigned int flags,
> > >                  struct pidfd_getfd_options *options, size_t size);
> That's embarrassing. This was supposed to read:
> long pidfd_getfd(int pidfd, int fd, struct pidfd_get_options *options,
> size_t size);
> 
> >
> > The prototype advertises a flags argument but the actual
> >
> > +SYSCALL_DEFINE4(pidfd_getfd, int, pidfd, int, fd,
> > +               struct pidfd_getfd_options __user *, options, size_t, usize)
> >
> > does not have a flags argument...
> >
> > I think having a flags argument makes a lot of sense.
> >
> > I'm not sure what to think about the struct. I agree with Aleksa that
> > having an empty struct is not a great idea. From a design perspective it
> > seems very out of place. If we do a struct at all putting at least a
> > single reserved field in there might makes more sense.
> >
> > In general, I think we need to have a _concrete_ reason why putting a
> > struct versioned by size as arguments for this syscall.
> > That means we need to have at least a concrete example for a new feature
> > for this syscall where a flag would not convey enough information.
> I can think of at least two reasons we need flags:
> * Clearing cgroup flags
> * Closing the process under manipulation's FD when we fetch it.
> 
> The original reason for wanting to have two places where we can put
> flags was to have a different field for fd flags vs. call flags. I'm not sure
> there's any flags you'd want to set.
> 
> Given this, if we want to go down the route of a syscall, we should just
> leave it as a __u64 flags, and drop the pointer to the struct, if we're

I think it needs to be an unsigned int. Having a 64bit register arg is
really messy on 32bit and means you need to have a compat syscall
implementation which handles this.

Christian
