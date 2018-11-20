From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Mon, 19 Nov 2018 16:49:26 -0800
Message-ID: <CAKOZueu20C7A0qAuhSkyfqTGLFcVddb8Me=GLUZPDb4pzMoYWg@mail.gmail.com>
References: <20181119103241.5229-1-christian@brauner.io> <20181119103241.5229-3-christian@brauner.io>
 <20181119223954.GA4992@cisco> <CAKOZuetQDziWeRLydHbDNv1abGM3LyF=WohLFvbzmtdT_+nBdg@mail.gmail.com>
 <20181119230709.GB4992@cisco> <CALCETrWyuQvTtksN1J1XbCFPka_rLOaFqa5W==EvGQvoaf9f3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWyuQvTtksN1J1XbCFPka_rLOaFqa5W==EvGQvoaf9f3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Tycho Andersen <tycho@tycho.ws>, Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 4:28 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Mon, Nov 19, 2018 at 3:07 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > These tools also care about ioctls. Adding a system call is a pain,
> > > but the solution is to make adding system calls less of a pain, not to
> > > permanently make the Linux ABI worse.
> >
> > For user-defined values of "worse" :)
> >
>
> I tend to agree with Tycho here.  But I'm wondering if it might be
> worth considering a better ioctl.
>
> /me dons flame-proof hat
>
> We could do:
>
> long better_ioctl(int fd, u32 nr, const void *inbuf, size_t inlen,
> const void *outbuf, size_t outlen);
>
> and have a central table in the kernel listing all possible nr values
> along with which driver they belong to.  We could have a sane
> signature and get rid of the nr collision problem.

The essential difference between a regular system call and an ioctl is
that in the former, the invoked kernel-side code depends on the
operation number, and in the latter, the invoked kernel-side code
depends on the operation number and file descriptor type. By creating
a new kind of collision-free ioctl, all you've done is re-invent the
system call, but with a funky calling convention and less operand
space. It makes no sense. Previous system call multiplexers --- e.g.,
socketcall --- are widely regarded as mistakes, and there's no reason
to repeat these mistakes.

System call numbers are not scarce, and your other proposal to clean
up the x86 numbering will make wiring up a new system call less
annoying. The *only* purpose of an ioctl is to solve the system call
numbering coordination problem --- if the invoked kernel-side code
depends on (DRIVER, OPERATION_NUMBER), and DRIVER can vary out-of-tree
with ioctl, ioctl lets out-of-tree code expose interfaces. For in-tree
code, this problem doesn't exist, so there's no reason to use the
awkward ioctl workaround!
