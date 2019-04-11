From: Christian Brauner <christian@brauner.io>
Subject: Re: [RFC PATCH] fork: add CLONE_PIDFD
Date: Thu, 11 Apr 2019 20:09:12 +0200
Message-ID: <645D6280-C442-4ECF-84DC-24788D1E57FF@brauner.io>
References: <20190410234045.29846-1-christian@brauner.io> <CAHk-=wifyY+XGNW=ZC4MyTHD14w81F8JjQNH-GaGAm2RxZ_S8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wifyY+XGNW=ZC4MyTHD14w81F8JjQNH-GaGAm2RxZ_S8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Andrew Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel
List-Id: linux-api@vger.kernel.org

On April 11, 2019 6:50:47 PM GMT+02:00, Linus Torvalds <torvalds@linux-foun=
dation=2Eorg> wrote:
>On Wed, Apr 10, 2019 at 4:43 PM Christian Brauner
><christian@brauner=2Eio> wrote:
>>
>> RFC-2:
>> This alternative patchset uses anonymous file descriptors instead of
>> file descriptors from /proc/<pid>=2E
>
>I think I prefer this one=2E Your diffstat makes it look bigger, but
>that's because you added the example code to use this to that rfc=2E=2E

Jann and I think this is the correct way to proceed as well=2E
And this will be way more acceptable for Al too we think=2E
I have spoken to Joel just now and he's
happy to change RFC patchsets related to
pidfds he has to the anon inode approach as well=2E
I'll take care to do the necessary coordination before anything
gets sent your way before the next merge window=2E

>
>Plus making anon_inodes unconditional makes sense anyway=2E  They are
>always selected in practice to begin with=2E

Yes, indeed=2E I coordinated this with David and Al=2E
They need anonymous inodes for the mount API as well
and thus need anon inodes useable in core vfs functions=2E

Christian
