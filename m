From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 22:59:12 -0600
Message-ID: <87muq4xs2n.fsf@xmission.com>
References: <20181119103241.5229-1-christian@brauner.io>
        <20181119103241.5229-3-christian@brauner.io>
        <20181119202857.k5zw742xjfrw677j@yavin>
        <20181119205518.btew3vxwgva4w3zh@brauner.io>
        <20181119211810.73ptfhnwdmkngfi4@yavin>
        <20181119212126.u2nkijmula6wcfqi@brauner.io>
        <CAKOZuevEx6CbcxrR8eVZrUXDcN5y1GPsXdSoHfQteSQKypx0qw@mail.gmail.com>
        <20181119213722.z54huio5g4kuldxk@brauner.io>
        <CAKOZueup5L9Fd=tTK5g1415x0muLP_cPkxf4o26-kCPtH_caqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueup5L9Fd=tTK5g1415x0muLP_cPkxf4o26-kCPtH_caqw@mail.gmail.com>
        (Daniel Colascione's message of "Mon, 19 Nov 2018 13:41:21 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, Aleksa Sarai <cyphar@cyphar.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

Daniel Colascione <dancol@google.com> writes:

> On Mon, Nov 19, 2018 at 1:37 PM Christian Brauner <christian@brauner.io> wrote:
>>
>> On Mon, Nov 19, 2018 at 01:26:22PM -0800, Daniel Colascione wrote:
>> > On Mon, Nov 19, 2018 at 1:21 PM, Christian Brauner <christian@brauner.io> wrote:
>> > > That can be done without a loop by comparing the level counter for the
>> > > two pid namespaces.
>> > >
>> > >>
>> > >> And you can rewrite pidns_get_parent to use it. So you would instead be
>> > >> doing:
>> > >>
>> > >>     if (pidns_is_descendant(proc_pid_ns, task_active_pid_ns(current)))
>> > >>         return -EPERM;
>> > >>
>> > >> (Or you can just copy the 5-line loop into procfd_signal -- though I
>> > >> imagine we'll need this for all of the procfd_* APIs.)
>> >
>> > Why is any of this even necessary? Why does the child namespace we're
>> > considering even have a file descriptor to its ancestor's procfs? If
>>
>> Because you can send file descriptors between processes and container
>> runtimes tend to do that.
>
> Right. But why *would* a container runtime send one of these procfs
> FDs to a container?
>
>> > it has one of these FDs, it can already *read* all sorts of
>> > information it really shouldn't be able to acquire, so the additional
>> > ability to send a signal (subject to the usual permission checks)
>> > feels like sticking a finger in a dike that's already well-perforated.
>> > IMHO, we shouldn't bother with this check. The patch would be simpler
>> > without it.
>>
>> We will definitely not allow signaling processes in an ancestor pid
>> namespace! That is a security issue! I can imagine container runtimes
>> killing their monitoring process etc. pp. Not happening, unless someone
>> with deep expertise in signals can convince me otherwise.
>
> If parent namespace procfs FDs or mounts really can leak into child
> namespaces as easily as Aleksa says, then I don't mind adding the
> check. I was under the impression that if you find yourself in this
> situation, you already have a big problem.

There is one big reason to have the check, and I have not seen it
mentioned yet in this thread.

When SI_USER is set we report the pid of the sender of the signal in
si_pid.  When the signal comes from the kernel si_pid == 0.  When signal
is sent from an ancestor pid namespace si_pid also equals 0 (which is
reasonable).

A signal out to a process in a parent pid namespace such as SIGCHLD is
reasonable as we can map the pid.  I really don't see the point of
forbidding that.  From the perspective of the process in the parent pid
namespace it is just another process in it's pid namespace.  So it
should pose no problem from the perspective of the receiving process.

A signal to a process in a pid namespace that is neither a parent nor a
descendent pid namespace would be a problem, as there is no well defined
notion of what si_pid should be set to.  So for that case perhaps we
should have something like a noprocess pid that we can set.  Perhaps we
could set si_pid to 0xffffffff.  That would take a small extension to
pid_nr_ns.

File descriptors are not namespaced.  It is completely legitimate to use
file descriptors to get around limitations of namespaces.

Adding limitations to a file descriptor based api because someone else
can't set up their processes in such a way as to get the restrictions
they are looking for seems very sad.

Frankly I think it is one of the better features of namespaces that we
have to carefully handle and define these cases so that when the
inevitable leaks happen you are not immediately in a world of hurt.  All
of the other permission checks etc continue to do their job.  Plus you
are prepared for the case when someone wants their containers to have an
interesting communication primitive.

Eric
