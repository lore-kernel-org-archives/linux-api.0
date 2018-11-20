From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 16:27:49 -0800
Message-ID: <CALCETrWyuQvTtksN1J1XbCFPka_rLOaFqa5W==EvGQvoaf9f3Q@mail.gmail.com>
References: <20181119103241.5229-1-christian@brauner.io> <20181119103241.5229-3-christian@brauner.io>
 <20181119223954.GA4992@cisco> <CAKOZuetQDziWeRLydHbDNv1abGM3LyF=WohLFvbzmtdT_+nBdg@mail.gmail.com>
 <20181119230709.GB4992@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119230709.GB4992@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Daniel Colascione <dancol@google.com>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 3:07 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > These tools also care about ioctls. Adding a system call is a pain,
> > but the solution is to make adding system calls less of a pain, not to
> > permanently make the Linux ABI worse.
>
> For user-defined values of "worse" :)
>

I tend to agree with Tycho here.  But I'm wondering if it might be
worth considering a better ioctl.

/me dons flame-proof hat

We could do:

long better_ioctl(int fd, u32 nr, const void *inbuf, size_t inlen,
const void *outbuf, size_t outlen);

and have a central table in the kernel listing all possible nr values
along with which driver they belong to.  We could have a sane
signature and get rid of the nr collision problem.

The major problem I see is that u32 isn't really enough to have a sane
way to allow out-of-tree drivers to use this, and that we can't
readily use anything bigger than u32 without indirection because we're
out of syscall argument space.
