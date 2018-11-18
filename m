From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] proc: allow killing processes via file descriptors
Date: Sun, 18 Nov 2018 09:44:15 -0800
Message-ID: <CALCETrXJrk3Jys_T6P=PxO4JY=H-1e9hcMVyBxQJvMRYf=5vfQ@mail.gmail.com>
References: <20181118111751.6142-1-christian@brauner.io> <CAKOZuet3s0WxxPgrtrNkq8YiOWhYAiK6yEio6PKVV9J_H4_TSA@mail.gmail.com>
 <CALCETrUd2Y2MmO8Qx8aUvQDOTNiyj35Y7bctPBZe0p2i1EUiLw@mail.gmail.com> <20181118174148.nvkc4ox2uorfatbm@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181118174148.nvkc4ox2uorfatbm@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andrew Lutomirski <luto@kernel.org>, Daniel Colascione <dancol@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, Kees Cook <keescook@chromium.org>, David Howells <dhowells@redhat.com>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 18, 2018 at 9:42 AM Christian Brauner <christian@brauner.io> wrote:
>
> On Sun, Nov 18, 2018 at 07:38:09AM -0800, Andy Lutomirski wrote:
> > On Sun, Nov 18, 2018 at 5:59 AM Daniel Colascione <dancol@google.com> wrote:
> > >
> > > I had been led to believe that the proposal would be a comprehensive
> > > process API, not an ioctl basically equivalent to my previous patch.
> > > If you had a more comprehensive proposal, please just share it on LKML
> > > instead of limiting the discussion to those able to attend these
> > > various conferences. If there's some determined opposition to a
> > > general new process API, this opposition needs a fair and full airing,
> > > as not everyone can attend these conferences.
> > >
> > > On Sun, Nov 18, 2018 at 3:17 AM, Christian Brauner <christian@brauner.io> wrote:
> > > > With this patch an open() call on /proc/<pid> will give userspace a handle
> > > > to struct pid of the process associated with /proc/<pid>. This allows to
> > > > maintain a stable handle on a process.
> > > > I have been discussing various approaches extensively during technical
> > > > conferences this year culminating in a long argument with Eric at Linux
> > > > Plumbers. The general consensus was that having a handle on a process
> > > > will be something that is very simple and easy to maintain
> > >
> > > ioctls are the opposite of "easy to maintain". Their
> > > file-descriptor-specific behavior makes it difficult to use the things
> > > safely. If you want to take this approach, please make a new system
> > > call. An ioctl is just a system call with a very strange spelling and
> > > unfortunate collision semantics.
> > >
> > > > with the
> > > > option of being extensible via a more advanced api if the need arises.
> > >
> > > The need *has* arisen; see my exithand patch.
> > >
> > > > I
> > > > believe that this patch is the most simple, dumb, and therefore
> > > > maintainable solution.
> > > >
> > > > The need for this has arisen in order to reliably kill a process without
> > > > running into issues of the pid being recycled as has been described in the
> > > > rejected patch [1].
> > >
> > > That patch was not "rejected". It was tabled pending the more
> > > comprehensive process API proposal that was supposed to have emerged.
> > > This patch is just another variant of the sort of approach we
> > > discussed on that patch's thread here. As I mentioned on that thread,
> > > the right approach option is a new system call, not an ioctl.
> > >
> > >  To fulfill the need described in that patchset a new
> > > > ioctl() PROC_FD_SIGNAL is added. It can be used to send signals to a
> > > > process via a file descriptor:
> > > >
> > > > int fd = open("/proc/1234", O_DIRECTORY | O_CLOEXEC);
> > > > ioctl(fd, PROC_FD_SIGNAL, SIGKILL);
> > > > close(fd);
> > > >
> > > > Note, the stable handle will allow us to carefully extend this feature in
> > > > the future.
> > >
> > > We still need the ability to synchronously wait on a process's death,
> > > as in my patch set. I will be refreshing that patch set.
> >
> > I fully agree that a more comprehensive, less expensive API for
> > managing processes would be nice.  But I also think that this patch
> > (using the directory fd and ioctl) is better from a security
> > perspective than using a new file in /proc.
> >
> > I have an old patch to make proc directory fds pollable:
> >
> > https://lore.kernel.org/patchwork/patch/345098/
> >
> > That patch plus the one in this thread might make a nice addition to
> > the kernel even if we expect something much better to come along
> > later.
>
> I agree. Eric's point was to make the first implementation of this as
> simple as possible that's why this patch is intentionally almost
> trivial. And I like it for its simplicity.
>
> I had a more comprehensive API proposal of which open(/proc/<pid>) was a
> part. I didn't send out alongside this patch as Eric clearly prefered to
> only have the /proc/<pid> part. Here is the full proposal as I intended
> to originally send it out:
>
> The gist is to have file descriptors for processes which is obviously not a new
> idea. This has been done before in other OSes and it has been tried before in
> Linux [2], [3] (Thanks to Kees for pointing out these patches.). So I want to
> make it very clear that I'm not laying claim to this being my or even a novel
> idea in any way. However, I want to diverge from previous approaches with my
> suggestion. (Though I can't be sure that there's not something similar in other
> OSes already.)
>
> One of the main motivations for having procfds is to have a race-free way of
> configuring, starting, polling, and killing a process. Basically, a process
> lifecycle api if you want to think about it that way. The api should also be
> easily extendable in the future to avoid running into the limitations we
> currently see with the clone*() syscall(s) again.
>
> One of the crucial points of the api is to *separate the configuration
> of a process through a procfd from actually creating the process*.
> This is a crucial property expressed in the open*() system calls. First, get a
> stable handle on an object then allow for ways to configure it. As such the
> procfd api shares the same insight with Al's and David's new mount api.
> (Fwiw, Andy also pointed out similarities with posix_spawn().)
> What I envisioned was to have the following syscalls (multiple name suggestions):
>
> 1. int process_open / proc_open / procopen
> 2. int process_config / proc_config / procconfig or ioctl()-based
> 3. int process_info / proc_info / procinfo or ioctl()-based
> 4. int process_manage / proc_manage / procmanage or ioctl()-based

Emails crossed :(

For process management, I generally like this, although we might do
better if we make execve() effectively invalidate the handle.  Then we
avoid a bunch of nasty permission issues.  For process *creation*, we
have the problem that libc authors feel that they can't safely use fds
at all.  There was a proposal for "high fds" a long time back to solve
that.  We might finally need to do something like that.
