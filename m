From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH 2/5] pidfd: add pidfd_wait()
Date: Wed, 24 Jul 2019 19:52:08 +0200
Message-ID: <D9BD06E2-576A-4627-8047-0AA86B6CCDA9@brauner.io>
References: <20190724144651.28272-1-christian@brauner.io> <20190724144651.28272-3-christian@brauner.io> <CAHk-=whZPKzbPQftNGFB=iaSZGTSXNkhUASWF2V53MwB+A4zAQ@mail.gmail.com> <95CD0533-576F-4B3A-8E80-D3D89967EE2C@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <95CD0533-576F-4B3A-8E80-D3D89967EE2C@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Joel Fernandes <joel@joelfernandes.org>, Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Android Kernel Team <kernel-team@android.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On July 24, 2019 7:50:49 PM GMT+02:00, Christian Brauner <christian@brauner=
=2Eio> wrote:
>On July 24, 2019 7:45:38 PM GMT+02:00, Linus Torvalds
><torvalds@linux-foundation=2Eorg> wrote:
>>On Wed, Jul 24, 2019 at 7:47 AM Christian Brauner
>><christian@brauner=2Eio> wrote:
>>>
>>> This adds the pidfd_wait() syscall=2E
>>
>>I despise this patch=2E
>>
>>Why can't this just be a new P_PIDFD flag, and then use
>>"waitid(P_PIDFD, pidfd, =2E=2E=2E);"
>>
>>Yes, yes, yes, I realize that "pidfd" is of type "int", and waitid()
>>takes an argument of type pid_t, but it's the same type in the end,
>>and it does seem like the whole *point* of "waitid()" is that
>>"idtype_t idtype" which tells you what kind of ID you're passing it=2E
>>
>>               Linus
>
>Well in that case we could add P_PIDFD=2E
>But then I would like to _only_ enable it for waitid()=2E How's that
>sound?
>
>Christian

Ah, sorry, just saw that that's what you suggested=2E

Christian
