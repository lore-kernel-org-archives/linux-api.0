From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Tue, 02 Apr 2019 13:03:24 +0200
Message-ID: <878swsr7nn.fsf@oldenburg2.str.redhat.com>
References: <CAHk-=whcA0kAWGqet9oJdyttjhP7J4PcU2Ly=n_Qyo6rMJNxRg@mail.gmail.com>
        <CAKOZuevv_QgvzmusA+yey76vo4hn9bEVwud2RumuOr0K4++15A@mail.gmail.com>
        <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
        <20190330171215.3yrfxwodstmgzmxy@brauner.io>
        <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
        <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
        <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
        <20190331211041.vht7dnqg4e4bilr2@brauner.io>
        <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
        <18C7FCB9-2CBA-4237-94BB-9C4395A2106B@amacapital.net>
        <20190401114059.7gdsvcqyoz2o5bbz@yavin>
        <CAHk-=wgKqBQznZdTQaM6yQ+_5dcz-+q8=2sbQsAoDh55hQTLMA@mail.gmail.com>
        <CAKOZuev4Q4CY0-2rUpTujSKMVJ9L9Exv=_divFC0G0_OaQHaGw@mail.gmail.com>
        <CAGLj2rF85hZLAR79oEA1dQARadw1OHr8bxqCLbvO6g9B6ou2Qw@mail.gmail.com>
        <CAKOZuetovU9NawSjUfGTAwXVfnmKC9GFtmS8FxAE5Hjmzq0HHA@mail.gmail.com>
        <CAHk-=wjgENV0pT8=MjB1UVBeWCrECCNXv15AKKX7Kfg7Eak7qw@mail.gmail.com>
        <CAKOZuet2QCoW1XMpTAzXS868PhF-gh14czFn4gwE4A=oX=Yr8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZuet2QCoW1XMpTAzXS868PhF-gh14czFn4gwE4A=oX=Yr8w@mail.gmail.com>
        (Daniel Colascione's message of "Mon, 1 Apr 2019 09:45:22 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jonathan Kowalski <bl0pbl33p@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@amacapital.net>, Christian Brauner <christian@brauner.io>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

* Daniel Colascione:

> But doesn't the CSIGNAL approach still require that libraries somehow
> coordinate which non-SIGCHLD signal they use? (Signal coordination a
> separate problem, unfortunately.)

There's already an allocation mechanism for realtime signals in glibc,
via __libc_allocate_rtsig.  I don't know what it is about: It's clearly
intended as an external interface, yet there isn't a declaration in any
installed header file.  ALSA has some optional code to use it, but I
don't think distributions compile ALSA in that way; it always uses SIGIO.

Thanks,
Florian
