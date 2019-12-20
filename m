From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v4 2/5] pid: Add PIDFD_IOCTL_GETFD to fetch file
 descriptors from processes
Date: Fri, 20 Dec 2019 10:20:07 +0100
Message-ID: <CAHrFyr6oWgeQGS9Yh4akorWyrfdYt6j6Y6v=v9=rDVgf5TbMQg@mail.gmail.com>
References: <20191218235459.GA17271@ircssh-2.c.rugged-nimbus-611.internal> <CALCETrUK-SHA=sOUrBscpf+Bpxxff2L3RpXEaAfRHNnHGxa-LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUK-SHA=sOUrBscpf+Bpxxff2L3RpXEaAfRHNnHGxa-LQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Sargun Dhillon <sargun@sargun.me>, ealvarez@mozilla.com, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, gpascutto@mozilla.com, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, jld@mozilla.com, LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 20, 2019 at 2:43 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Wed, Dec 18, 2019 at 3:55 PM Sargun Dhillon <sargun@sargun.me> wrote:
> >
> > +
> > +       if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
> > +               file = ERR_PTR(-EPERM);
> > +               goto out;
> > +       }
>
> I don't think this is MODE_READ.  By copying an fd from the task, you
> can easily change its state.
>
> IMO it would be really nice if pidfd could act more like a capability

That's ultimately what I would like to get to.

> here and carry a ptrace mode, for example.  But I guess it doesn't
> right now.

It doesn't right now for mainly two reasons.
The way I think about it is that a pidfd gets a capability at process
creation time. Before v5.3 we couldn't have done that because legacy
clone() couldn't be extended anymore. Imho, this has changed with clone3().
The other reason was that the basic properties a process can be created
with right now do not lend itself to be turned into a capability. Even
if they did
suddenly treating them like such would prevent userspace from switching to
clone3() because it would regress usecases they had.
However, for new properties this is not a problem. I have some ideas around this
(e.g. spawning private processes only reapable through pidfds and auto-cleanup
if there's no pidfd anymore).
>From an implementation perspective clone3() could get a __aligned_u64 caps
(naming up for debate since we don't want people to think this is equivalent
to our current capabilities) field.
Where at process creation time you could e.g. specify PIDFD_CAP_GET_FD and
only then can you use that pidfd to get file descriptors from other processes.
You still need ptrace_access() to get the actual fd of course.

Christian
