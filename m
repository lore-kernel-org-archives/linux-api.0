From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 20:40:19 +0000
Message-ID: <CAGLj2rE7k-p=ZniyV6bDm-VbhAdzSSwxYcVV=X_Rsky5nixGvw@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
 <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
 <CAKOZuetCFgu0B53+mGmQ3+539MPT_tiu-PACx2ATvihHrrmUKg@mail.gmail.com>
 <CAGLj2rHETs+FjkOVP6PJ_EiePP7FKiDwxaWyjwg1gMZPYpU1fQ@mail.gmail.com>
 <CAKOZueuYMKdkt8BoSj1+p7=mpe2PA8r7xT5QiF6q3cTK+6HsAA@mail.gmail.com> <CAG48ez1ZVKgwfQDYT1k4pB4-8Y8Ywv12dabh5KFFxtKmT-e7Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1ZVKgwfQDYT1k4pB4-8Y8Ywv12dabh5KFFxtKmT-e7Cw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <christian@brauner.io>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathn>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 25, 2019 at 8:34 PM Jann Horn <jannh@google.com> wrote:
>
>  [...SNIP...]
>
> Please don't do that. /proc/$pid/fd refers to the set of file
> descriptors the process has open, and semantically doesn't have much
> to do with the identity of the process. If you want to have a procfs
> directory entry for getting a pidfd, please add a new entry. (Although
> I don't see the point in adding a new procfs entry for this when you
> could instead have an ioctl or syscall operating on the procfs
> directory fd.)

There is no new entry. What I was saying (and I should have been
clearer) is that the existing entry for the fd when open'd with
O_DIRECTORY makes the kernel resolve the symlink to /proc/<PID> of the
process it maps to, so it would become:

  int dirfd = open("/proc/self/fd/3", O_DIRECTORY|O_CLOEXEC);

This also means you cannot cross the filesystem boundry, the said
process needs to have a visible entry (which would mean hidepid= and
gid= based access controls are honored), and you can only open the
dirfd of a process in the current ns (as the PID will not map to an
existent process if the pidfd maps to a process not in the same or
children pid ns, in fdinfo it lists -1 in the pid field (we might not
even need fdinfo anymore)).
