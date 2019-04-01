From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 09:45:22 -0700
Message-ID: <CAKOZuet2QCoW1XMpTAzXS868PhF-gh14czFn4gwE4A=oX=Yr8w@mail.gmail.com>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
 <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
 <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net> <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
 <CAGLj2rF85hZLAR79oEA1dQARadw1OHr8bxqCLbvO6g9B6ou2Qw@mail.gmail.com>
 <CAKOZuetovU9NawSjUfGTAwXVfnmKC9GFtmS8FxAE5Hjmzq0HHA@mail.gmail.com> <CAHk-=wjgENV0pT8=MjB1UVBeWCrECCNXv15AKKX7Kfg7Eak7qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjgENV0pT8=MjB1UVBeWCrECCNXv15AKKX7Kfg7Eak7qw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-fou>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 9:30 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Apr 1, 2019 at 9:22 AM Daniel Colascione <dancol@google.com> wrote:
> >
> > There's a subtlety: suppose I'm a library and I want to create a
> > private subprocess. I use the new clone facility, whatever it is, and
> > get a pidfd back. I need to be able to read the child's exit status
> > even if the child exits before clone returns in the parent. Doesn't
> > this requirement imply that the pidfd, kernel-side, contain something
> > a bit more than a struct pid?
>
> Note that clone() has always supported this, but it has basically
> never been used.
>
> One of the early thinkings behind clone() was that it could be used
> for basically "AIO in user space", by having exactly these kinds of
> library-private internal subthreads that are hidden as real threads.
>
> It's why we have that special CSIGNAL mask for setting the exit
> signal. It doesn't *just* set the signal to be sent when the thread
> exits - setting the signal to something else than SIGCHLD actually
> changes behavior in other ways too.
>
> In particular a non-SIGCHLD thread won't be found by a regular
> "waitpid()". You have to explicitly wait for it with __WCLONE (which
> in turn is supposed to be used with the explicit pid to be waited
> for).

But doesn't the CSIGNAL approach still require that libraries somehow
coordinate which non-SIGCHLD signal they use? (Signal coordination a
separate problem, unfortunately.) If you don't set a signal, you don't
get any notification at all, and in that case, you have to burn a
thread on a blocking wait, right? And you don't *have* to wait for a
specific PID with __WCLONE. If two libraries each did a separate
__WCLONE or __WALL wait on all subprocesses, they'd still interfere,
AIUI, even if the interface isn't supposed to be used that way.

I like the pidfd way of doing private subprocesses a bit more than the
CSIGNAL approach because it's more "natural" (in that a pidfd is just
a handle like we have handles to tons of other things), integrates
with existing event and wait facilities, doesn't require any global
coordination at all, and works for more than this one use case.
(CSIGNAL is limited to immediate parents. You could, in principle,
SCM_RIGHTS a pidfd to someone else.)

> Now, none of this was ever really used. The people who wanted AIO
> wanted the brain-damaged POSIX kind of AIO, not something cool and
> clever. So I suspect the whole exit-signal thing was just used for
> random small per-project things.

AIO is a whole other ball of wax. :-)
