From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 09:13:42 -0700
Message-ID: <CAKOZuethE6Yv9xrw6jjDncanbggqm1Phyy=i5hx-c-GPXF9JOA@mail.gmail.com>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net> <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com> <CAHk-=wgKOJTdN9TqyjW6FngEZvgUTmCDzJPRrtekW_1SD0gfhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wgKOJTdN9TqyjW6FngEZvgUTmCDzJPRrtekW_1SD0gfhw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-fou>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 9:01 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
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

In my exithand patch last year, I took a minimal approach and just had
read(2) read EOF once the process exited and blocked until then. Maybe
we could do that? But if we're supported waitid(2) on pidfds instead,
then we don't need read(2) at all on pidfds, right? Right now, I don't
see a situation in which I'd take advantage of a pidfd read(2) that
just gave me the running/sleeping/zombie state.

I'm also a bit worried about the implications of making a directory FD
also readable. Didn't problems with that come up in one of the
multiple-named-streams proposals?

> Eg we could make it return the same thing that /proc/<pid>/status
> reads right now.
>
> But it sounds like you need pretty much all of /proc/<pid>/xyz:
>
> > We do a lot of process state inspection and manipulation, including
> > reading and writing the oom killer adjustment score, reading smaps,
> > and the occasional cgroup manipulation. More generally, I'd also like
> > to be able to write a race-free pkill(1)
>
> I suspect most of what pkill wants is indeed in that 'status' file,
> but other things aren't.

Right. It's hard to predict what we might need. pkill also needs
/proc/pid/cmdline, FWIW.
