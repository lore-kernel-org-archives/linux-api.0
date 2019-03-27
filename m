From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 2/4] pid: add pidfd_open()
Date: Wed, 27 Mar 2019 20:17:14 +0000
Message-ID: <CAGLj2rFDvUiTpZcPdp_QgU11+KDZe0O8LcTRhRA_vBRJqJ81-g@mail.gmail.com>
References: <20190327162147.23198-1-christian@brauner.io> <20190327162147.23198-3-christian@brauner.io>
 <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rG8xMMt8-+r-pauA_qi4aun2y_kBZMCZGkXWQsKJrb-Ww@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 27, 2019 at 7:38 PM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
>  ...
> ... the process cannot get it out
> of thin air on its own (and you already mentioned it has nothing to do
> with security). What I do worry about is one can use NS_GET_PARENT

disregard this, it works as it should.

> ioctl to get the parent pidns if the owning userns is the same, and
> just passing that gives me back a pidfd for the task. **So, you might
> want to add the constraint that the PID is actually reachable by the
> current task as well, apart from being reachable in the passed in
> namespace.**
>
> Lastly, I also see no need of /proc/<PID> dir fd to pidfd conversion,
> I would even recommend getting rid of that, so we only have one type
> of pidfd, the anon inode one. What is the usecase behind that? It
> would only be needed if you did not have a way to be able to metadata
> access through a pidfd, which would be the case only prior to this
> patch.
>
> I think this would simplify a lot of things, and ioctl_ns(2) is
> probably already the place to do comparison operations and query
> operations on hierarichal namespaces, just adding the relative PID bit
> will make it gain feature parity with translate_pid.
