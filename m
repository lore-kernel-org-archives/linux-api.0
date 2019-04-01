From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 15:13:23 -0700
Message-ID: <CAHk-=wiDjdoS4erUTjWaHMY+ZT28omwA24pPMRoQEE-rtNcRpw@mail.gmail.com>
References: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net> <20190401114059.7gdsvcqyoz2o5bbz@yavin>
 <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
 <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
 <CAHk-=wgKOJTdN9TqyjW6FngEZvgUTmCDzJPRrtekW_1SD0gfhw@mail.gmail.com>
 <20190401194214.4rbvmwogpke3cjcx@brauner.io> <CAHk-=wgjndAqzMBxgXZxbSRXLRqdXtNM3aHc9X-xj+Px1fsG-Q@mail.gmail.com>
 <CAGLj2rFvWE6ENFyKSbZMrhqSrLjkm0YrRh2+O0LC04HmJuEY5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rFvWE6ENFyKSbZMrhqSrLjkm0YrRh2+O0LC04HmJuEY5g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-found>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 1, 2019 at 2:58 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
>
> You mention the race about learning the PID, PID being recycled, and
> pidfd_open getting the wrong reference.
>
> This exists with the /proc model to way. How do you propose to address this?

Note that that race exists _regardless_ of any interfaces.
pidfd_open() has the same race: any time you have a pid, the lifetime
of it is only as long as the process existing.

That's why we talked about the CLONE_PIDFD flag, which would return
the pidfd itself when creating a new process. That's one truly
race-free way to handle it.

Or just do the fork(), and know that the pid won't be re-used until
you've done the wait() for it, and block SIGCHLD until you've done the
lookup.

That said, in *practice*, you can probably use any of the racy "look
up pidfd using pid" models, as long as you just verify the end result
after you've opened it.

That verification could be as simple as "look up the parent pid of the
pidfd I got", if you know you created it with fork() (and you can
obviously track what _other_ thread you yourself created, so you can
verify whether it is yours or not).

For example, using "openat(pidfd, "status", ..)", but also by just
tracking what you've done waitpid() on (but you need to look out for
subtle races with another thread being in the process of doing so).

Or you can just say that as long as you got the pidfd quickly after
the fork(), any pid wrapping attack is practically not possible even
if it might be racy in theory.

                         Linus
