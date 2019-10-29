From: Florian Weimer <fweimer@redhat.com>
Subject: Re: For review: documentation of clone3() system call
Date: Tue, 29 Oct 2019 15:36:37 +0100
Message-ID: <87wocn39fu.fsf@oldenburg2.str.redhat.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
        <CAG48ez3q=BeNcuVTKBN79kJui4vC6nw0Bfq6xc-i0neheT17TA@mail.gmail.com>
        <20191028172143.4vnnjpdljfnexaq5@wittgenstein>
        <CAG48ez20hn8vToY+=C62nA-rbUfxh=JD6N-f7XVS3_GZOoPjxw@mail.gmail.com>
        <20191029112706.p5dd5yzpcgouo6n5@wittgenstein>
        <20191029142622.jxmssu4s4ndui7bw@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191029142622.jxmssu4s4ndui7bw@wittgenstein> (Christian
        Brauner's message of "Tue, 29 Oct 2019 15:26:23 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Jann Horn <jannh@google.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> @Florian, do you have an opinion about always passing the stack from the
> lowest address with clone3()?

Do you mean that the stack extends from stack to stack_size?  I guess
that makes sense.  What about architectures which need two stacks (I
think ia64 is one)?

There is also the matter whose responsibility is the alignment of the
initial stack pointer.

Thanks,
Florian
