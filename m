From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 09:16:46 -0700
Message-ID: <CAHk-=wjka0W1g3asQp2H=5ot=kkS-Mp+Cx6KHr0rNkGFfCOLYA@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueuDWWYtg9gUpUgTG2k-gVPE1KBEkstr5eP=FC2EzdmaoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nag>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 9:11 AM Daniel Colascione <dancol@google.com> wrote:
>
> How do you propose that someone open the /proc/<pid>/status file in a
> race-free manner starting with the result of calling pidfd_open?

CXhrist.

If you want to open a /proc file, then open a /proc file. Don't use
pidfd_open().

Just open /proc/<pid>/

Then you can use openat() to open whatever sub-files you want.

You have two choices: either you use /proc, or you don't. Don't mix the two.

And no, we are *NOT* making pidfd_open() into some "let's expose /proc
even when it's not mounted" horror. Seriously. That's disgusting,
wrong, insecure and stupid.

                           Linus
