From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 17:19:32 +0100
Message-ID: <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io> <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, serge@hallyn.com, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, bl0pbl33p@gmail.com, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, nagarathnam.muthusamy@oracle.com, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Joel Fernandes <joel@>
List-Id: linux-api@vger.kernel.org

On March 30, 2019 5:09:10 PM GMT+01:00, Linus Torvalds <torvalds@linux-foun=
dation=2Eorg> wrote:
>On Fri, Mar 29, 2019 at 8:54 AM Christian Brauner
><christian@brauner=2Eio> wrote:
>>
>> /* Introduction */
>> This adds the pidfd_open() syscall=2E
>> pidfd_open() allows to retrieve file descriptors for a given pid=2E
>This
>> includes both file descriptors for processes and file descriptors for
>> threads=2E
>
>I'm ok with the pidfd_open() call to just get a pidfd, but that

From=20pure API perspective that's all I care about: independence of procfs=
=2E
Once we have pidfd_open() we can cleanly signal threads etc=2E

>"pidfd_to_profs()" needs to go away=2E
>
>If you want to open the /proc/<pid>/status file, then just do that=2E
>This whole "do one and convert to the other" needs to die=2E No, no, no=
=2E
>
>                   Linus
