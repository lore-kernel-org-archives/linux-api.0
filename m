From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 18:41:49 +0100
Message-ID: <20181118174148.nvkc4ox2uorfatbm@brauner.io>
References: <20181118111751.6142-1-christian@brauner.io>
 <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Colascione <dancol@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 07:38:09AM -0800, Andy Lutomirski wrote:
> On Sun, Nov 18, 2018 at 5:59 AM Daniel Colascione <dancol@google.com> wrote:
> >
> > I had been led to believe that the proposal would be a comprehensive
> > process API, not an ioctl basically equivalent to my previous patch.
> > If you had a more comprehensive proposal, please just share it on LKML
> > instead of limiting the discussion to those able to attend these
> > various conferences. If there's some determined opposition to a
> > general new process API, this opposition needs a fair and full airing,
> > as not everyone can attend these conferences.
> >
> > On Sun, Nov 18, 2018 at 3:17 AM, Christian Brauner <christian@brauner.io> wrote:
> > > With this patch an open() call on /proc/<pid> will give userspace a handle
> > > to struct pid of the process associated with /proc/<pid>. This allows to
> > > maintain a stable handle on a process.
> > > I have been discussing various approaches extensively during technical
> > > conferences this year culminating in a long argument with Eric at Linux
> > > Plumbers. The general consensus was that having a handle on a process
> > > will be something that is very simple and easy to maintain
> >
> > ioctls are the opposite of "easy to maintain". Their
> > file-descriptor-specific behavior makes it difficult to use the things
> > safely. If you want to take this approach, please make a new system
> > call. An ioctl is just a system call with a very strange spelling and
> > unfortunate collision semantics.
> >
> > > with the
> > > option of being extensible via a more advanced api if the need arises.
> >
> > The need *has* arisen; see my exithand patch.
> >
> > > I
> > > believe that this patch is the most simple, dumb, and therefore
> > > maintainable solution.
> > >
> > > The need for this has arisen in order to reliably kill a process without
> > > running into issues of the pid being recycled as has been described in the
> > > rejected patch [1].
> >
> > That patch was not "rejected". It was tabled pending the more
> > comprehensive process API proposal that was supposed to have emerged.
> > This patch is just another variant of the sort of approach we
> > discussed on that patch's thread here. As I mentioned on that thread,
> > the right approach option is a new system call, not an ioctl.
> >
> >  To fulfill the need described in that patchset a new
> > > ioctl() PROC_FD_SIGNAL is added. It can be used to send signals to a
> > > process via a file descriptor:
> > >
> > > int fd = open("/proc/1234", O_DIRECTORY | O_CLOEXEC);
> > > ioctl(fd, PROC_FD_SIGNAL, SIGKILL);
> > > close(fd);
> > >
> > > Note, the stable handle will allow us to carefully extend this feature in
> > > the future.
> >
> > We still need the ability to synchronously wait on a process's death,
> > as in my patch set. I will be refreshing that patch set.
> 
> I fully agree that a more comprehensive, less expensive API for
> managing processes would be nice.  But I also think that this patch
> (using the directory fd and ioctl) is better from a security
> perspective than using a new file in /proc.
> 
> I have an old patch to make proc directory fds pollable:
> 
> https://lore.kernel.org/patchwork/patch/345098/
> 
> That patch plus the one in this thread might make a nice addition to
> the kernel even if we expect something much better to come along
> later.

I agree. Eric's point was to make the first implementation of this as
simple as possible that's why this patch is intentionally almost
trivial. And I like it for its simplicity.

I had a more comprehensive API proposal of which open(/proc/<pid>) was a
part. I didn't send out alongside this patch as Eric clearly prefered to
only have the /proc/<pid> part. Here is the full proposal as I intended
to originally send it out:

The gist is to have file descriptors for processes which is obviously not a new
idea. This has been done before in other OSes and it has been tried before in
Linux [2], [3] (Thanks to Kees for pointing out these patches.). So I want to
make it very clear that I'm not laying claim to this being my or even a novel
idea in any way. However, I want to diverge from previous approaches with my
suggestion. (Though I can't be sure that there's not something similar in other
OSes already.)

One of the main motivations for having procfds is to have a race-free way of
configuring, starting, polling, and killing a process. Basically, a process
lifecycle api if you want to think about it that way. The api should also be
easily extendable in the future to avoid running into the limitations we
currently see with the clone*() syscall(s) again.

One of the crucial points of the api is to *separate the configuration
of a process through a procfd from actually creating the process*.
This is a crucial property expressed in the open*() system calls. First, get a
stable handle on an object then allow for ways to configure it. As such the
procfd api shares the same insight with Al's and David's new mount api.
(Fwiw, Andy also pointed out similarities with posix_spawn().)
What I envisioned was to have the following syscalls (multiple name suggestions):

1. int process_open / proc_open / procopen
2. int process_config / proc_config / procconfig or ioctl()-based
3. int process_info / proc_info / procinfo or ioctl()-based
4. int process_manage / proc_manage / procmanage or ioctl()-based

and the following procfs extension:

int procfd = open("/proc/<pid>", O_DIRECTORY | O_CLOEXEC);

Some of you will notice right away that we could replace 2-4 with ioctl()s.

#### process_open()
will return an fd that creates a process context.
The fd returned by process_open() does neither refer to any existing process
nor has the process actually been started yet. So non-configuration operations
on it or trying to interact with it would fail with e.g. ESRCH/EINVAL.

#### process_config() / ioctl()
takes an fd returned by process_open() and can be used to configure a process
context *before it is alive*.
Some things that I would like to be able to do with this syscall are:
- configure signals
- set clone flags
- write idmappings if the process runs in a new user namespace
- configure what happens when all procfds referring to the process are gone
- ...

Just to get a very rough feel for this without detailing parameters right now:

/* process should have own mountns */
process_config/ioctl(fd, PROC_SET_FLAG,  CLONE_NEWNS, <potentially additional arguments>)

/* process should get SIGKILL when all procfds are closed */
process_config/ioctl(fd, PROC_SET_CLOSE, SIGKILL,     <potentially additional arguments>)

After the caller is done configuring the process there would be a final step:

process_config/ioctl(fd, PROC_CREATE, 0, <potentially additional arguments>)

which would create the process and (either as return value or through a
parameter) return the pid of the newly created process.

These fds should be pollable (though this is maybe out of scope for a first
implementation). In combination with the split between getting an fd for a
process context and starting the process would this would then allow for nice
things such as adding an fd gotten via process_open() to an epoll() instance
where other processes can poll the fd to e.g. (given appropriate privileges)
get an event when process_config/ioctl()(fd, PROC_CREATE, *, <potentially
additional arguments>) has actually started the process or it exited.

#### int process_info / ioctl()
allows to retrieve information about a process (e.g. signals, namespaces, or
even information available through getrusage()).
This would be a more performant and race-free way then parsing through various
files in /proc. I remember quite some people asking for a variation of this.

#### process_manage / ioctl()
allows to interact/manage a process through a procfd.
Specifically, one would be able to send signals to the process, retrieve the
exit status from it etc. Here is an example to get a feel for it:

/* send SIGTERM to process /
process_manage/ioctl(fd, PROC_SIGNAL, SIGTERM, <potentially additional arguments>)

/* block until the process has exited and retrieve exit information via
 * <potentially additional arguments>.
 * One could also make it possible to specify a timeout here.
 */
process_manage/ioctl(fd, PROC_WAIT, 0, <potentially additional arguments>)

#### /proc/<pid>
allow to get a procfd for an existing process.
This adds a new file "handle" to /proc that serves as a way to get a procfd for
a process.

I hope that's enough information for now without too much detail.
I think that /proc/<pid> is probably the easiest to target and that I
prototyped.

[1]: https://lkml.org/lkml/2018/10/30/118
[2]: https://lkml.kernel.org/r/cover.1426180120.git.josh@joshtriplett.org
[3]: https://lore.kernel.org/lkml/2279556.Wl6mCVq5Zi@tjmaciei-mobl4
