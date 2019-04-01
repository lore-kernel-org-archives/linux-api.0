From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 22:58:04 +0100
Message-ID: <CAGLj2rFvWE6ENFyKSbZMrhqSrLjkm0YrRh2+O0LC04HmJuEY5g@mail.gmail.com>
References: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net> <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
 <CAHk-=wgKOJTdN9TqyjW6FngEZvgUTmCDzJPRrtekW_1SD0gfhw@mail.gmail.com>
 <20190401194214.4rbvmwogpke3cjcx@brauner.io> <CAHk-=wgjndAqzMBxgXZxbSRXLRqdXtNM3aHc9X-xj+Px1fsG-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgjndAqzMBxgXZxbSRXLRqdXtNM3aHc9X-xj+Px1fsG-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-found>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 10:35 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Apr 1, 2019 at 12:42 PM Christian Brauner <christian@brauner.io> wrote:
> >
> > From what I gather from this thread we are still best of with using fds
> > to /proc/<pid> as pidfds. Linus, do you agree or have I misunderstood?

You mention the race about learning the PID, PID being recycled, and
pidfd_open getting the wrong reference.

This exists with the /proc model to way. How do you propose to address this?


>
> That does seem to be the most flexible option.
>
> > Yes, we can have an internal mount option to restrict access to various
> > parts of procfs from such pidfds
>
> I suspect you'd find that other parties might want such a "restrict
> proc" mount option too, so I don't think it needs to be anything
> internal.
>
> But it would be pretty much independent of the pidfd issue, of course.
>
> > One thing is that we also need something to disable access to the
> > "/proc/<pid>/net". One option could be to give the files in "net/" an
> > ->open-handler which checks that our file->f_path.mnt is not one of our
> > special clone() mounts and if it is refuse the open.
>
> I would expect that that would be part of the "restrict proc" mount options, no?

I was thinking if some part of /proc could be split in a procpidfs,
with possibly shared code, which means with the new mount API, you
could configure a superblock with restricted views by virtue of mount
options, per task. This only gives you the view as inside /proc/<PID>,
and you might not be able to lift restrctions depending on privileges
in owning userns of the task.

Now, this would mean we keep the notion of anon inode fds as pidfds,
and on supported systems, you could configure an instance, pass the
pidfd descriptor in the fsconfig stage (David Howells demonstrated
similar support for passing user and net namespace descriptors during
superblock configuration) and also the pidns descriptor. Without
mounting the fs, the mount fd can then be used to do metadata access
passing it to openat and friends, possibly passed to others. This is
more granular than restrcting access over the entire /proc instance,
and can be adjusted per process, and since you need the pidfd's pidns
descriptor, you cannot easily cross namespace boundaries with just a
single pidfd. You can also create many variants of restricted versions
of a single task's proc directory.

The pidfd API and /proc access can be connected while also keeping
them both separate, conceptually.

There are some details but this will wound up being much more powerful
(restricting /proc as a whole is ofcourse also fine, in addition to
this). There are some details on when and how someone should be able
to do this, but is something like this up for discussion?

>
> > Basically, if you have a system without CONFIG_PROC_FS it makes sense
> > that clone gives back an anon inode file descriptor as pidfds because
> > you can still signal threads in a race-free way. But it doesn't make a
> > lot of sense to have pidfd_open() in this scenario because you can't
> > really do anything with that pidfd apart from sending signals.
>
> Well, people might want that.
>
> But realistically, everybody enables /proc support anyway. Even if you
> don't actually fully *mount* it in some restricted area, the support
> is pretty much always there in any kernel config.
>
> But yes, in general I agree that that also most likely means that a
> separate system call for "open_pidfd()" isn't worth it.
>
> Because if the main objection to /proc is that it exposes too much,
> then I think a much better option is to see how to sanely restrict the
> "too much" parts.
>
> Because I think there might be a lot of people who want a restricted
> /proc, in various container models etc.
>
>                    Linus
