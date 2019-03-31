From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 00:03:00 +0200
Message-ID: <20190331220259.qntxynluk765hpnt@brauner.io>
References: <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io>
 <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
 <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io>
 <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@red>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 02:17:48PM -0700, Linus Torvalds wrote:
> On Sun, Mar 31, 2019 at 2:10 PM Christian Brauner <christian@brauner.io> wrote:
> >
> > I don't think that we want or can make them equivalent since that would
> > mean we depend on procfs.
> 
> Sure we can.
> 
> If /proc is enabled, then you always do that dance YOU ALREADY WROTE
> THE CODE FOR to do the stupid ioctl.
> 
> And if /procfs isn't enabled, then you don't do that.
> 
> Ta-daa. Done. No stupid ioctl, and now /proc and pidfd_open() return
> the same damn thing.
> 
> And guess what? If /proc isn't enabled, then obviously pidfd_open()
> gives you the /proc-less thing, but at least there is no crazy "two
> different file descriptors for the same thing" situation, because then
> the /proc one doesn't exist.
> 
> Notice? No incompatibility. No crazy stupid new "convert one to the
> other", because "the other model" NEVER EXISTS. There is only one
> pidfd - it might be proc-less if CONFIG_PROC isn't there, but let's
> face it, nobody even cares, because nobody ever disabled /proc anyway.

Thanks for the input. The problem Jann and I saw with this is that it
would be awkward to have the kernel open a file in some procfs instance,
since then userspace would have to specify which procfs instance the fd
should come from.  Yes, it could probably always be the callers procfs
instance. But I'm concerned how this will interact with procfs mount
options such as hidepid={1,2} and pid namespaces.
One concern is what should happen when there's no procfs mount in the
callers mount namespace. Do we check for that in pidfd_open() and at
CLONE_PIDFD time and then refuse to give the caller a pidfd in that case
or do they still get a dirfd to /proc/<pid>? If we refuse it would mean
that having procfs mounted is necessary to get a pidfd if we don't
refuse it would mean that we're making process metadata available
without procfs being mounted which an administrator migh not want by not
having mounted procfs.
Another question is what happens when procfs is mounted with
hidepid={1,2}. If the caller accidently learns a pid they could
pidfd_open() it and circumvent hidepid={1,2}. So we would need to verify
the procfs mount options as well. I think these problems would be gone
if pidfds were opaque handles.

Christian
