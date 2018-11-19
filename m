From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 13:41:21 -0800
Message-ID: <CAKOZueup5L9Fd=tTK5g1415x0muLP_cPkxf4o26-kCPtH_caqw@mail.gmail.com>
References: <20181119103241.5229-1-christian@brauner.io> <20181119103241.5229-3-christian@brauner.io>
 <20181119202857.k5zw742xjfrw677j@yavin> <20181119205518.btew3vxwgva4w3zh@brauner.io>
 <20181119211810.73ptfhnwdmkngfi4@yavin> <20181119212126.u2nkijmula6wcfqi@brauner.io>
 <CAKOZuevEx6CbcxrR8eVZrUXDcN5y1GPsXdSoHfQteSQKypx0qw@mail.gmail.com> <20181119213722.z54huio5g4kuldxk@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119213722.z54huio5g4kuldxk@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Aleksa Sarai <cyphar@cyphar.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 1:37 PM Christian Brauner <christian@brauner.io> wrote:
>
> On Mon, Nov 19, 2018 at 01:26:22PM -0800, Daniel Colascione wrote:
> > On Mon, Nov 19, 2018 at 1:21 PM, Christian Brauner <christian@brauner.io> wrote:
> > > That can be done without a loop by comparing the level counter for the
> > > two pid namespaces.
> > >
> > >>
> > >> And you can rewrite pidns_get_parent to use it. So you would instead be
> > >> doing:
> > >>
> > >>     if (pidns_is_descendant(proc_pid_ns, task_active_pid_ns(current)))
> > >>         return -EPERM;
> > >>
> > >> (Or you can just copy the 5-line loop into procfd_signal -- though I
> > >> imagine we'll need this for all of the procfd_* APIs.)
> >
> > Why is any of this even necessary? Why does the child namespace we're
> > considering even have a file descriptor to its ancestor's procfs? If
>
> Because you can send file descriptors between processes and container
> runtimes tend to do that.

Right. But why *would* a container runtime send one of these procfs
FDs to a container?

> > it has one of these FDs, it can already *read* all sorts of
> > information it really shouldn't be able to acquire, so the additional
> > ability to send a signal (subject to the usual permission checks)
> > feels like sticking a finger in a dike that's already well-perforated.
> > IMHO, we shouldn't bother with this check. The patch would be simpler
> > without it.
>
> We will definitely not allow signaling processes in an ancestor pid
> namespace! That is a security issue! I can imagine container runtimes
> killing their monitoring process etc. pp. Not happening, unless someone
> with deep expertise in signals can convince me otherwise.

If parent namespace procfs FDs or mounts really can leak into child
namespaces as easily as Aleksa says, then I don't mind adding the
check. I was under the impression that if you find yourself in this
situation, you already have a big problem.
