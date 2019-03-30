From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 09:34:02 -0700
Message-ID: <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io> <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nag>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 9:24 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Mar 30, 2019 at 9:19 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > From pure API perspective that's all I care about: independence of procfs.
> > Once we have pidfd_open() we can cleanly signal threads etc.
>
> But "independence from procfs" means that you damn well don't then do
> "oh, now I have a pidfd, I want to turn it into a /proc fd and then
> munge around there".
>
> So I'm literally saying that it had better really *be* independent
> from /proc. It is the standalone version, but it's most definitely
> also the version that doesn't then give you secret access to /proc.

Just to be clear, I'm not proposing granting secret access to procfs,
and as far as I can see, nobody else is either. We've been talking
about making it easier to avoid races when you happen to want a pidfd
and a procfs fd that point to the same process, not granting access
that you didn't have before. If you'd rather not connect procfs and
pidfds, we can take this functionality off the table.
