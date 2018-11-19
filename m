From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 16:07:09 -0700
Message-ID: <20181119230709.GB4992@cisco>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181119223954.GA4992@cisco>
 <CAKOZuetQDziWeRLydHbDNv1abGM3LyF=WohLFvbzmtdT_+nBdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuetQDziWeRLydHbDNv1abGM3LyF=WohLFvbzmtdT_+nBdg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 02:49:22PM -0800, Daniel Colascione wrote:
> On Mon, Nov 19, 2018 at 2:40 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > Can I just register an objection here that I think using a syscall
> > just for this is silly?
> 
> Yes, you can argue that the bikeshed should be ioctl-colored and not
> syscall-colored.
> 
> > My understanding is that the concern is that some code might do:
> >
> > unknown_fd = recv_fd();
> > ioctl(unknown_fd, SOME_IOCTL, NULL); // where SOME_IOCTL == PROC_FD_KILL
> > // whoops, unknown_fd was a procfd and we killed a task!
> >
> > In my experience when writing fd sending/receiving code, the sender and
> > receiver are fairly tightly coupled. Has anyone ever actually fixed a
> > bug where they had an fd that they lost track of what "type" it was
> > and screwed up like this? It seems completely theoretical to me.
> 
> Yes, I have fixed bugs of this form.
> 
> > The ioctl() approach has the benefit of being extensible.
> 
> The system call table is also extensible.

But not infinitely so. The x32 ABI starts at 512, and right now I see
334 syscalls on x86_64. So the next 178 people can say "let's just
define a syscall", and after that? I suppose we could move to setting
BIT(10), but how much userspace assumes > 512 => compat syscall and
blocks it via seccomp or whatever?

Contrast that with the ioctl space, which is an unsigned long and
fairly sparse still (Documentation/ioctl/ioctl-number.txt).

> ioctl is for when a given piece of functionality *can't*
> realistically get its own system call because it's separated from
> the main kernel somehow. procfs is a core part of the kernel, so we
> can and should expose interfaces to it using system calls.

I suppose it's obvious, but I disagree.

> > Adding a
> > syscall means that everyone has to do all the boilerplate for each new
> > pid op in the kernel, arches, libc, strace, etc.
> 
> These tools also care about ioctls. Adding a system call is a pain,
> but the solution is to make adding system calls less of a pain, not to
> permanently make the Linux ABI worse.

For user-defined values of "worse" :)

Tycho
