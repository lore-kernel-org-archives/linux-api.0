From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 09:09:10 -0700
Message-ID: <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
References: <20190329155425.26059-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190329155425.26059-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, serge@hallyn.com, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, nagarathnam.muthusamy@oracle.com, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Joel Fernandes <joel@>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 29, 2019 at 8:54 AM Christian Brauner <christian@brauner.io> wrote:
>
> /* Introduction */
> This adds the pidfd_open() syscall.
> pidfd_open() allows to retrieve file descriptors for a given pid. This
> includes both file descriptors for processes and file descriptors for
> threads.

I'm ok with the pidfd_open() call to just get a pidfd, but that
"pidfd_to_profs()" needs to go away.

If you want to open the /proc/<pid>/status file, then just do that.
This whole "do one and convert to the other" needs to die. No, no, no.

                   Linus
