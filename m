From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 01 Apr 2019 10:47:11 +0200
Message-ID: <65440fd9977a2e1f0467b7ece38240e5dac2b736.camel@opteya.com>
References: <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
         <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
         <20190330171215.3yrfxwodstmgzmxy@brauner.io>
         <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
         <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
         <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
         <20190331211041.vht7dnqg4e4bilr2@brauner.io>
         <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
         <20190331220259.qntxynluk765hpnt@brauner.io>
         <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
         <20190331223355.vfbnnkmevl63etvv@brauner.io>
         <CAG48ez0OnfkrEc5SmeaPpuv2aQ31kxkoFeaSVFwu7z1m=tN-9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez0OnfkrEc5SmeaPpuv2aQ31kxkoFeaSVFwu7z1m=tN-9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg
List-Id: linux-api@vger.kernel.org

Hi,

Le lundi 01 avril 2019 à 02:52 +0200, Jann Horn a écrit :

> One minor detail to keep in mind for the future is that in a
> straightforward implementation of this concept, if a non-capable
> process is running in a mount namespace, but in the initial network
> namespace, without any reachable /proc mount, it will be able to look
> at information about other processes' network connections by first
> using pidfd_open() on itself or by using clone(CLONE_PIDFD), then
> looking at the "net" directory under the resulting file descriptor.

I also think it would punch a hole in chroot() ... (but in 2019, nobody
should rely on it for security purpose).

Regards.

-- 
Yann Droneaud
OPTEYA
