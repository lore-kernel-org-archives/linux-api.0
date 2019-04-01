From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 21:42:15 +0200
Message-ID: <20190401194214.4rbvmwogpke3cjcx@brauner.io>
References: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
 <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io>
 <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net>
 <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
 <CAHk-=wgKOJTdN9TqyjW6FngEZvgUTmCDzJPRrtekW_1SD0gfhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wgKOJTdN9TqyjW6FngEZvgUTmCDzJPRrtekW_1SD0gfhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>
Cc: Daniel Colascione <dancol@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 01, 2019 at 09:01:29AM -0700, Linus Torvalds wrote:
> On Mon, Apr 1, 2019 at 8:55 AM Daniel Colascione <dancol@google.com> wrote:
> >
> >
> > > I wonder if we really want a fill procfs2, or maybe we could just make
> > > the pidfd readable (yes, it's a directory file descriptor, but we
> > > could allow reading).
> >
> > What would read(2) read?
> 
> We could make it read anything, but it would have to be something
> people agree is sufficient (and not so expensive to create that rare
> users of that data would find the overhead excessive).
> 
> Eg we could make it return the same thing that /proc/<pid>/status
> reads right now.
> 
> But it sounds like you need pretty much all of /proc/<pid>/xyz:

>From what I gather from this thread we are still best of with using fds
to /proc/<pid> as pidfds. Linus, do you agree or have I misunderstood?
Yes, we can have an internal mount option to restrict access to various
parts of procfs from such pidfds or do the parent-less bind-mount trick
but I think this beats having a stunted dummy dirfd that we implement a
read method on.
One thing is that we also need something to disable access to the
"/proc/<pid>/net". One option could be to give the files in "net/" an
->open-handler which checks that our file->f_path.mnt is not one of our
special clone() mounts and if it is refuse the open.

To clarify the way forward:
Jann and I were discussing whether pidfd_open() still makes sense and
whether I shouldn't just jump straight to a first version of
CLONE_PIDFD.
Basically, if you have a system without CONFIG_PROC_FS it makes sense
that clone gives back an anon inode file descriptor as pidfds because
you can still signal threads in a race-free way. But it doesn't make a
lot of sense to have pidfd_open() in this scenario because you can't
really do anything with that pidfd apart from sending signals. And on a
system like that sending a signal is still racy. Since the process can
be recycled between learning the pid number and calling pidfd_open()
[1]. So it only makes sense to have _clone()_ give back anon_inode() fds
on a system without CONFIG_PROC_FS but it doesn't make sense for
pidfd_open() In other news, I think it makes more sense if I jump to the
implementation of CLONE_PIDFD instead of working on pidfd_open().

[1]: The only case - that seems rather far-fetched - where it makes
     sense is when the parent wants to create that pidfd and hand it to
     someone else.

Christian
