From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 2/4] clone: add CLONE_PIDFD
Date: Mon, 15 Apr 2019 12:39:01 -0700
Message-ID: <CAKOZuetPpE6-HrV0uV=fWosOnQkaq5eSQHyiARS6LUensuWBbg@mail.gmail.com>
References: <20190414201436.19502-1-christian@brauner.io> <20190414201436.19502-3-christian@brauner.io>
 <20190415105209.GA22204@redhat.com> <20190415114204.ydczeuwmi74wfsuv@brauner.io>
 <20190415132416.GB22204@redhat.com> <CAGLj2rHpZ92txk2=yf7dtHFcic2H0bGB0=FzEo7w2rNpC2zxDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rHpZ92txk2=yf7dtHFcic2H0bGB0=FzEo7w2rNpC2zxDA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <christian@brauner.io>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Joel Fernandes <joel@joelfernandes.org>
List-Id: linux-api@vger.kernel.org

On Mon, Apr 15, 2019 at 10:15 AM Jonathan Kowalski <bl0pbl33p@gmail.com> wrote:
> > Why else do we want pidfd?
>
> Apart from what others have already pointed out, there are two other
> things I am looking forward to:

Everything that Christian, Joel, and Jonathan have said is right.

If I can wax philosophical for a bit (as I've been accused to doing
:-)), there's a lot of value in consistency itself, a "more than the
sum of its parts" effect that arises from modeling all kernel-resource
handles as file descriptors. You get lifecycle consistency, API
consistency (e.g., dup, close), introspection consistency (via
/proc/pid/fd and friends), wait consistency, IPC consistency, and tons
of other benefits from using a file descriptor. The alternatives tend
to be very ugly: one of SysV IPC's* biggest mistakes, for example, was
having users manage its resources via non-file-descriptor kernel
handles. The process is, I think, the last major class of kernel
resource that users can't manipulate via file descriptor. Even if
using pidfds didn't provide strong immediate and direct benefits, it'd
*still* be worth moving to a file descriptor resource handle model for
the sake of making the system interface regular and uniform.

* Does anyone know *why* the SysV people didn't use FDs? The
consistency argument I'm making was just as relevant then as it is
now.
