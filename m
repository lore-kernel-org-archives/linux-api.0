From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Wed, 24 Jul 2019 10:45:38 -0700
Message-ID: <CAHk-=whZPKzbPQftNGFB=iaSZGTSXNkhUASWF2V53MwB+A4zAQ@mail.gmail.com>
References: <20190724144651.28272-1-christian@brauner.io> <20190724144651.28272-3-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190724144651.28272-3-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Joel Fernandes <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Android Kernel Team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 24, 2019 at 7:47 AM Christian Brauner <christian@brauner.io> wrote:
>
> This adds the pidfd_wait() syscall.

I despise this patch.

Why can't this just be a new P_PIDFD flag, and then use
"waitid(P_PIDFD, pidfd, ...);"

Yes, yes, yes, I realize that "pidfd" is of type "int", and waitid()
takes an argument of type pid_t, but it's the same type in the end,
and it does seem like the whole *point* of "waitid()" is that
"idtype_t idtype" which tells you what kind of ID you're passing it.

               Linus
