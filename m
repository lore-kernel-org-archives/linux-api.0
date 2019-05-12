From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Sun, 12 May 2019 12:19:35 +0200
Message-ID: <20190512101933.lqafnc2zu46ocyhe@brauner.io>
References: <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin>
 <20190510204141.GB253532@google.com>
 <CALCETrW2nn=omqJb4p+m-BDsCOhg+YZQ3ELd4BdhODV3G44gfA@mail.gmail.com>
 <20190510225527.GA59914@google.com>
 <C60DC580-854D-478D-AF23-5F29FB7C3E50@amacapital.net>
 <CAHk-=wh1JJD_RabMaFfinsAQp1vHGJOQ1rKqihafY=r7yHc8sQ@mail.gmail.com>
 <CALCETrUOj=4VWp=B=QT0BQ8X_Ds_b+pt68oDwfjGb+K0StXmWA@mail.gmail.com>
 <CAHk-=wg3+3GfHsHdB4o78jNiPh_5ShrzxBuTN-Y8EZfiFMhCvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wg3+3GfHsHdB4o78jNiPh_5ShrzxBuTN-Y8EZfiFMhCvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>kerne
List-Id: linux-api@vger.kernel.org

On Sat, May 11, 2019 at 07:08:49PM -0400, Linus Torvalds wrote:
> [ on mobile again, power is off and the wifi doesn't work, so I'm reading
> email on my phone and apologizing once more for horrible html email.. ]
> 
> On Sat, May 11, 2019, 18:40 Andy Lutomirski <luto@kernel.org> wrote:
> 
> >
> > a) Change all my UIDs and GIDs to match a container, enter that
> > container's namespaces, and run some binary in the container's

For the namespace part, an idea I had and presented at LPC a while ago
was to make setns() interpret the nstype argument as a flag argument and
to introduce an fd that can refer to multiple namespaces at the same
time. This way you could do:

setns(namespaces_fd, CLONE_NEWNS | CLONE_NEWUSER | CLONE_NEWPID)

that could still be done. But I since have come to think that there's a
better way now that we have CLONE_PIDFD. We should just make setns()
take a pidfd as argument and then be able to call:

setns(pidfd, 0);

which would cause the calling thread to join all of the namespaces of
the process referred to by pidfd at the same time. That really shouldn't
be hard to do. I could probably get this going rather quickly and it
would really help out container managers a lot.

> > filesystem, all atomically enough that I don't need to worry about
> > accidentally leaking privileges into the container.  A
> > super-duper-non-dumpable mode would kind of allow this, but I'd worry
> > that there's some other hole besides ptrace() and /proc/self.
> >
> 
> So I would expect that you'd want to do this even *without* doing an execve
> at all, which is why I still don't think this is actually about
> spawn/execve at all.
> 
> But I agree that what you that what you want sounds reasonable. But I think

I have pitched an api like that a while ago (see [1]) - when I first
started this fd for processes thing - that would allow you to do things
like that. The gist was:

1. int pidfd_create aka CLONE_PIDFD now
   will return an fd that creates a process context. The fd returned by
   does not refer to any existing process and has not actually been
   started yet. So non-configuration operations on it or trying to
   interact with it would fail with e.g. ESRCH/EINVAL.
   
   We essentially have this now with CLONE_PIDFD. The bit that is missing
   is an "unscheduled" process.

2. int pidfd_config
   takes a CLONE_PIDFD and can be used to configure a process context
   before it is alive.
   Some things that I would like to be able to do with this syscall are:
   - configure signals
   - set clone flags
   - write idmappings if the process runs in a new user namespace
   - configure what happens when all procfds referring to the process are gone
   - ...
3. int pidfd_info
4. int pidfd_manage
   Parts of that are captured in pidfd_send_signal().

Just to get a very rough feel for this without detailing parameters right now:

/* process should have own mountns */
pidfd_config(fd, PROC_SET_NAMESPACE,  CLONE_NEWNS | CLONE_NEWPID | CLONE_NEWUSR, <potentially additional arguments>)

/* process should get SIGKILL when all procfds are closed */
pidfd_config(fd, PROC_SET_CLOSE, SIGKILL,     <potentially additional arguments>)

After the caller is done configuring the process there would be a final step:

pidfd_config(fd, PROC_CREATE, 0, <potentially additional arguments>)

which would create the process and (either as return value or through a
parameter) return the pid of the newly created process.

I had more thoughts on this and had started prototyping some of it but
then there wasn't much interest it seemed. Maybe because it's crazy.

[1]: https://lore.kernel.org/lkml/20181118174148.nvkc4ox2uorfatbm@brauner.io/

> the "dumpable" flag has always been a complete hack, and very unreliable
> with random meanings (and random ways to then get around it).
> 
> We have actually had lots of people wanting to run "lists of system calls"
> kinds of things. Sometimes for performance reasons, sometimes for other
> random reasons  Maybe that "atomicity" angle would be another one, although
> we would have to make the setuid etc things be something that happens at
> the end.
> 
> So rather than "spawn", is much rather see people think about ways to just
> batch operations in general, rather than think it is about batching things
> just before a process change.
> 
> b) Change all my UIDs and GIDs to match a container, enter that
> > container's namespaces, and run some binary that is *not* in the
> > container's filesystem.
> >
> 
> Hey, you could probably do something very close to that by opening the
> executable you want to run first, making it O_CLOEXEC, then doing all the
> other things (which now makes the executable inaccessible), and finally
> doing execveat() on the file descriptor..

I think that's somewhat similar to what I've suggested above.

> 
> I say "something very close" because even though it's O_CLOEXEC, only the
> file would be closed, and /proc/self/exe would still exist.
> 
> But we really could make that execveat of a O_CLOEXEC file thing also
> disable access to /proc/*/exe, and it sounds like a sane and simple
> extension in general to do..
> 
>        Linus
> 
> >
