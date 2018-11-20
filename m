From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 16:34:00 -0800
Message-ID: <CALCETrU+_MkDR4AYkbTB72vDRteOY3TDhQkARL0PyXzc3KUgfQ@mail.gmail.com>
References: <20181119103241.5229-1-christian@brauner.io> <20181119103241.5229-3-christian@brauner.io>
 <20181119223954.GA4992@cisco> <CAKOZuetQDziWeRLydHbDNv1abGM3LyF=WohLFvbzmtdT_+nBdg@mail.gmail.com>
 <20181119230709.GB4992@cisco> <CALCETrWyuQvTtksN1J1XbCFPka_rLOaFqa5W==EvGQvoaf9f3Q@mail.gmail.com>
 <20181120003247.a776bej54baxqoxv@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181120003247.a776bej54baxqoxv@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Andrew Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Daniel Colascione <dancol@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 4:33 PM Christian Brauner <christian@brauner.io> wrote:
>
> On Mon, Nov 19, 2018 at 04:27:49PM -0800, Andy Lutomirski wrote:
> > On Mon, Nov 19, 2018 at 3:07 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > These tools also care about ioctls. Adding a system call is a pain,
> > > > but the solution is to make adding system calls less of a pain, not to
> > > > permanently make the Linux ABI worse.
> > >
> > > For user-defined values of "worse" :)
> > >
> >
> > I tend to agree with Tycho here.  But I'm wondering if it might be
> > worth considering a better ioctl.
> >
> > /me dons flame-proof hat
> >
> > We could do:
> >
> > long better_ioctl(int fd, u32 nr, const void *inbuf, size_t inlen,
> > const void *outbuf, size_t outlen);
>
> I'm the writer of this patch so take this with a grain of salt.
> I think it is a bad idea to stop this patch and force us to introduce a
> new type of ioctl().

I agree completely.

> An ioctl() is also not easy to use for this task because we want to add
> a siginfo_t argument which I actually think provides value and makes
> this interface more useful.
>

You could always have a struct procfd_kill and pass a pointer to
*that*.  But sure, it's ugly.
