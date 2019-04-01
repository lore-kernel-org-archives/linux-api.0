From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 17:27:39 +0100
Message-ID: <CAGLj2rHdv1rvx++Vf5LaAnZENMoq2+b-OPYmgGMnuOnaCzav3A@mail.gmail.com>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net> <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
 <CAGLj2rF85hZLAR79oEA1dQARadw1OHr8bxqCLbvO6g9B6ou2Qw@mail.gmail.com> <CAHk-=wi1UEsMv5wmBZB5S+5YiCbxd-AtVsoz1TfuD-KrdcLQew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wi1UEsMv5wmBZB5S+5YiCbxd-AtVsoz1TfuD-KrdcLQew@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Colascione <dancol@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-found>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 5:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Apr 1, 2019 at 9:07 AM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
> >
> > With the POLLHUP model on a simple pidfd, you'd know when the process
> > you were referring to is dead (and one can map POLLPRI to dead and
> > POLLHUP to zombie, etc).
>
> Adding ->poll() to the pidfd should be easy. Again, it would be
> trivially be made to work for the directory fd you get from
> /proc/<pid> too.
>
> Yeah, yeah, pollable directories are odd, but the vfs layer doesn't
> care about things like "is this a directory or not". It will just call
> the f_op->poll() method.

I know, Andy even sent a patch for that long back. The question is,
this sure solves the immediate usecase, but it inhibits some very
powerful (and natural) things from being realised in the future, and
makes some choices harder.

Currently, pidfd_send_signal doesn't work across PID namespaces. It
would be possible to make it work, but some things need to be taken
care of, precisely, that one allows a task to open pidfds for tasks
*it* can see. Why? because you essentially isolate the PID namespace,
so your open() for this namespace suddenly doesn't start opening
things it cannot see through some other namespace (i.e. /proc),
precisely how you cannot open sockets in network namespaces from the
outside, though if you can setns, you should be able to (same with
pidfds). This makes for a nice delegation model, I can essentially put
a task in a namespace with no other tasks, keep pushing pidfds into
the damn thing, and subject to kernel permissions and capabilities it
can yield in the owner userns, signal the said task. You can extend
this to ptrace and other things, by making them accept a pidfd. This
means userspace has to explicitly pass such descriptors around to make
this work, like it does today (and how I can use an open socket and
accept connections whilst living in totally isolated network
namespace).

Besides that, /proc comes with too much stuff, it should be possible
to go from pidfd to /proc/<PID> and do whatever you wish to, but
atleast two things that require varying levels of capabilities of
inspection, the latter of which can be isolated by mount namespaces
even if the process would usially be allowed to peek into it and read
the entire thing, do not end being munged together. I can choose to
pass both, but if /proc dir fds *are* pidfds, you need the entire
complexity of masking and whatnot (which would be usable on its own,
no doubt), making directory descriptors pollable and readable, etc
etc.

>
>               Linus
