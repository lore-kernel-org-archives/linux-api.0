From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 09:11:22 -0700
Message-ID: <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nag>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 9:09 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Mar 29, 2019 at 8:54 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > /* Introduction */
> > This adds the pidfd_open() syscall.
> > pidfd_open() allows to retrieve file descriptors for a given pid. This
> > includes both file descriptors for processes and file descriptors for
> > threads.
>
> I'm ok with the pidfd_open() call to just get a pidfd, but that
> "pidfd_to_profs()" needs to go away.
>
> If you want to open the /proc/<pid>/status file, then just do that.
> This whole "do one and convert to the other" needs to die. No, no, no.

How do you propose that someone open the /proc/<pid>/status file in a
race-free manner starting with the result of calling pidfd_open?
