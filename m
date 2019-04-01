From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 08:55:00 -0700
Message-ID: <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net> <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-fou>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 8:36 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Apr 1, 2019 at 4:41 AM Aleksa Sarai <cyphar@cyphar.com> wrote:
> >
> > Eric pitched a procfs2 which would *just* be the PIDs some time ago (in
> > an attempt to make it possible one day to mount /proc inside a container
> > without adding a bunch of masked paths), though it was just an idea and
> > I don't know if he ever had a patch for it.

Couldn't this mode just be a relatively simple procfs mount option
instead of a whole new filesystem? It'd be a bit like hidepid, right?
The internal bind mount option and the no-dotdot-traversal options
also look good to me.

> I wonder if we really want a fill procfs2, or maybe we could just make
> the pidfd readable (yes, it's a directory file descriptor, but we
> could allow reading).

What would read(2) read?

> What are the *actual* use cases for opening /proc files through it? If
> it's really just for a small subset that android wants to do this
> (getting basic process state like "running" etc), rather than anything
> else, then we could skip the whole /proc linking entirely and go the
> other way instead (ie open_pidfd() would get that limited IO model,
> and we could make the /proc directory node get the same limited IO
> model).

We do a lot of process state inspection and manipulation, including
reading and writing the oom killer adjustment score, reading smaps,
and the occasional cgroup manipulation. More generally, I'd also like
to be able to write a race-free pkill(1). Doing this work via pidfd
would be convenient. More generally, we can't enumerate the specific
use cases, because what we want to do with processes isn't bounded in
advance, and we regularly find new things in /proc/pid that we want to
read and write. I'd rather not prematurely limit the applicability of
the pidfd interface, especially when there's a simple option (the
procfs directory file descriptor approach) that doesn't require
in-advance enumeration of supported process inspection and
manipulation actions or a separate per-option pidfd equivalent. I very
much want a general-purpose API that reuses the metadata interfaces
the kernel already exposes. It's not clear to me how this rich
interface could be matched by read(2) on a pidfd.
