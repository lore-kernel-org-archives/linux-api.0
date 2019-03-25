From: Jonathan Kowalski <bl0pbl33p@gmail.com>
Subject: Re: [PATCH 0/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 21:14:54 +0000
Message-ID: <CAGLj2rGMHfNkRKmb1+BFTuJb+wpXg09so-52Hsb0tMiQ0beMfA@mail.gmail.com>
References: <20190325162052.28987-1-christian@brauner.io> <CAKOZueuJSAiKU7fZR2FNDKKCktdyE-sADtWprpsNMAqYQvD9Jw@mail.gmail.com>
 <20190325173614.GB25975@google.com> <CAKOZuetbZOs1Yur4OrW6hh3wVYdoKNkSqTszbpTWnuRBTmT9zA@mail.gmail.com>
 <CAGLj2rE1f4x36KFUjFLiFq8tF1RUmFuCSRTg_tCQ9W2G6LtizA@mail.gmail.com>
 <CAKOZuetCFgu0B53+mGmQ3+539MPT_tiu-PACx2ATvihHrrmUKg@mail.gmail.com>
 <CAGLj2rHETs+FjkOVP6PJ_EiePP7FKiDwxaWyjwg1gMZPYpU1fQ@mail.gmail.com>
 <CAKOZueuYMKdkt8BoSj1+p7=mpe2PA8r7xT5QiF6q3cTK+6HsAA@mail.gmail.com>
 <CAG48ez1ZVKgwfQDYT1k4pB4-8Y8Ywv12dabh5KFFxtKmT-e7Cw@mail.gmail.com> <CAGLj2rE7k-p=ZniyV6bDm-VbhAdzSSwxYcVV=X_Rsky5nixGvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGLj2rE7k-p=ZniyV6bDm-VbhAdzSSwxYcVV=X_Rsky5nixGvw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Daniel Colascione <dancol@google.com>, Joel Fernandes <joel@joelfernandes.org>, Christian Brauner <christian@brauner.io>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux API <linux-api@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathn>
List-Id: linux-api@vger.kernel.org

Also,  extending this further, instead of new ioctl flags over to
translate a tidfd one might introduce later for thread targetted
signals (which would still be a pidfd in the struct pid terms, but
with a bit set in its reference to target the selected TID in
particular), you could resolve this neatly to the proc entry of the
task itself, which would be subject to restrictions similar to a
regular open call, minus all the races involved.

This also means you can get rid of having to support the /proc/<PID>
dir fd in pidfd_send_signal, because there is no incentive to, any
longer. The kernel now has just one pidfd object, well scoped in its
purpose, and this "feature" is tied to procfs itself, disabling which
takes away the feature as well.

Otherwise, the ioctl will be conditionally available and/or work only
when procfs is present, and you'd tie procfs to pidfds eternally as
ABI.
