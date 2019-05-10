From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v6 5/6] binfmt_*: scope path resolution of interpreters
Date: Sat, 11 May 2019 01:36:37 +0200
Message-ID: <CAHrFyr5vjTZfgtMsHwr6iwVVFxVsU3UCOiEq=FM-rjr0kPGHUw@mail.gmail.com>
References: <20190506165439.9155-1-cyphar@cyphar.com> <20190506165439.9155-6-cyphar@cyphar.com>
 <CAG48ez0-CiODf6UBHWTaog97prx=VAd3HgHvEjdGNz344m1xKw@mail.gmail.com>
 <20190506191735.nmzf7kwfh7b6e2tf@yavin> <20190510204141.GB253532@google.com>
 <CALCETrW2nn=omqJb4p+m-BDsCOhg+YZQ3ELd4BdhODV3G44gfA@mail.gmail.com> <20190510225527.GA59914@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190510225527.GA59914@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Containers <containers@lists.linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.ke>
List-Id: linux-api@vger.kernel.org

On Sat, May 11, 2019 at 12:55 AM Jann Horn <jannh@google.com> wrote:
>
> On Fri, May 10, 2019 at 02:20:23PM -0700, Andy Lutomirski wrote:
> > On Fri, May 10, 2019 at 1:41 PM Jann Horn <jannh@google.com> wrote:
> > >
> > > On Tue, May 07, 2019 at 05:17:35AM +1000, Aleksa Sarai wrote:
> > > > On 2019-05-06, Jann Horn <jannh@google.com> wrote:
> > > > > In my opinion, CVE-2019-5736 points out two different problems:
> > > > >
> > > > > The big problem: The __ptrace_may_access() logic has a special-case
> > > > > short-circuit for "introspection" that you can't opt out of; this
> > > > > makes it possible to open things in procfs that are related to the
> > > > > current process even if the credentials of the process wouldn't permit
> > > > > accessing another process like it. I think the proper fix to deal with
> > > > > this would be to add a prctl() flag for "set whether introspection is
> > > > > allowed for this process", and if userspace has manually un-set that
> > > > > flag, any introspection special-case logic would be skipped.
> > > >
> > > > We could do PR_SET_DUMPABLE=3 for this, I guess?
> > >
> > > Hmm... I'd make it a new prctl() command, since introspection is
> > > somewhat orthogonal to dumpability. Also, dumpability is per-mm, and I
> > > think the introspection flag should be per-thread.
> >
> > I've lost track of the context here, but it seems to me that
> > mitigating attacks involving accidental following of /proc links
> > shouldn't depend on dumpability.  What's the actual problem this is
> > trying to solve again?
>
> The one actual security problem that I've seen related to this is
> CVE-2019-5736. There is a write-up of it at
> <https://blog.dragonsector.pl/2019/02/cve-2019-5736-escape-from-docker-and.html>
> under "Successful approach", but it goes more or less as follows:
>
> A container is running that doesn't use user namespaces (because for
> some reason I don't understand, apparently some people still do that).
> An evil process is running inside the container with UID 0 (as in,
> GLOBAL_ROOT_UID); so if the evil process inside the container was able
> to reach root-owned files on the host filesystem, it could write into
> them.
>
> The container engine wants to spawn a new process inside the container.
> It forks off a child that joins the container's namespaces (including
> PID and mount namespaces), and then the child calls execve() on some
> path in the container.
> The attacker replaces the executable in the container with a symlink
> to /proc/self/exe and replaces a library inside the container with a
> malicious one.
> When the container engine calls execve(), intending to run an executable
> inside the container, it instead goes through ptrace_may_access() using
> the introspection short-circuit and re-executes its own executable
> through the jumped symlink /proc/self/exe (which is normally unreachable
> for the container). After the execve(), the process loads an evil
> library from inside the container and is under the control of the
> container.
> Now the container controls a process whose /proc/self/exe is a jumped
> symlink to a host executable, and the container can write into it.
>
> Some container engines are now using an extremely ugly hack to work
> around this - whenever they want to enter a container, they copy the
> host binary into a new memfd and execute that to avoid exposing the
> original host binary to containers:
> <https://github.com/opencontainers/runc/commit/0a8e4117e7f715d5fbeef398405813ce8e88558b>
>
>
> In my opinion, the problems here are:
>
>  - Apparently some people run untrusted containers without user
>    namespaces. It would be really nice if people could not do that.
>    (Probably the biggest problem here.)

I know I sound like a broken record since I've been going on about this
forever together with a lot of other people but honestly,
the fact that people are running untrusted workloads in privileged containers
is the real issue here.

Aleksa is a good friend of mine and we have discussed this a lot so I hope
he doesn't hate me for saying this again: it is crazy that there are container
runtimes out there that promise (or at least do not state the opposite)
containers without user namespaces or containers with user namespaces
that allow to map the host root id to anything can be safe. They cannot.

Even if this /proc/*/exe thing is somehow blocked there
are other ways of escaping from a privileged container.
We (i.e. LXC) literally do not accept CVEs for privileged containers
because we do not consider them safe by design.
It seems to me to be heading in the wrong direction to keep up the
illusion that with enough effort we can make this all nice and safe.
Yes, the userspace memfd hack we came up with is as ugly as a security
patch can be but if you make promises you can't keep you better be
prepared to pay the price when things start to fall apart.
So if this part of the patch is just needed to handle this do we really
want to do all that tricky work or is there more to gain from this that
makes it worth it.

Christian
