From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 3/5] signal: use fdget() since we don't allow O_PATH
Date: Thu, 18 Apr 2019 08:37:28 -0700
Message-ID: <CAHk-=whB0A_WsBpr3MFujWKi7WW9XLxUpq=z_uYTv+J7uE0wRw@mail.gmail.com>
References: <20190418101841.4476-1-christian@brauner.io> <20190418101841.4476-4-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190418101841.4476-4-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andrew Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>, Jann Horn <jann@thejh.net>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 18, 2019 at 3:19 AM Christian Brauner <christian@brauner.io> wrote:
>
>     It's just semantically correct to use fdget()
> and return an error right from there instead of taking a reference and
> returning an error later.

I've applied this one directly, because it ends up affecting the
existing code, and I'd rather just have the initial release of
pidfd_send_signal() right.

The other patches I consider to be "future release" material.

                    Linus
