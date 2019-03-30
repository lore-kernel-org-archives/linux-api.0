From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sat, 30 Mar 2019 17:37:51 +0100
Message-ID: <20190330163750.xrrqmcyfd2mchamf@brauner.io>
References: <20190329155425.26059-1-christian@brauner.io>
 <CAHk-=wjq4dTPcz-qsvhpm5F42SDHCoqEWv1V=rs_kt6MC=ZThA@mail.gmail.com>
 <BCD99947-5F55-4116-8F74-D6832E50340B@brauner.io>
 <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, Aleksa Sarai <cyph>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 30, 2019 at 09:24:23AM -0700, Linus Torvalds wrote:
> On Sat, Mar 30, 2019 at 9:19 AM Christian Brauner <christian@brauner.io> wrote:
> >
> > From pure API perspective that's all I care about: independence of procfs.
> > Once we have pidfd_open() we can cleanly signal threads etc.
> 
> But "independence from procfs" means that you damn well don't then do
> "oh, now I have a pidfd, I want to turn it into a /proc fd and then
> munge around there".
> 
> So I'm literally saying that it had better really *be* independent
> from /proc. It is the standalone version, but it's most definitely
> also the version that doesn't then give you secret access to /proc.
> 
> And it weorries me a lot that people are trying to play these kinds of
> games. I'm just seeing some android patch that adds this horror and
> then starts using it.

The original need for this conversion thing came from Android indeed. I
won't go forward with any such patches. 

Christian
