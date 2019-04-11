From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] fork: add CLONE_PIDFD
Date: Thu, 11 Apr 2019 09:50:47 -0700
Message-ID: <CAHk-=wifyY+XGNW=ZC4MyTHD14w81F8JjQNH-GaGAm2RxZ_S8Q@mail.gmail.com>
References: <20190410234045.29846-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190410234045.29846-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andrew Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel
List-Id: linux-api@vger.kernel.org

On Wed, Apr 10, 2019 at 4:43 PM Christian Brauner <christian@brauner.io> wrote:
>
> RFC-2:
> This alternative patchset uses anonymous file descriptors instead of
> file descriptors from /proc/<pid>.

I think I prefer this one. Your diffstat makes it look bigger, but
that's because you added the example code to use this to that rfc..

Plus making anon_inodes unconditional makes sense anyway.  They are
always selected in practice to begin with.

               Linus
