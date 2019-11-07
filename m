From: Florian Weimer <fweimer@redhat.com>
Subject: Re: For review: documentation of clone3() system call
Date: Thu, 07 Nov 2019 17:10:51 +0100
Message-ID: <87y2wrbras.fsf@oldenburg2.str.redhat.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
        <20191107151941.dw4gtul5lrtax4se@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191107151941.dw4gtul5lrtax4se@wittgenstein> (Christian
        Brauner's message of "Thu, 7 Nov 2019 16:19:43 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> I've always been confused by the "..." for the glibc wrapper. The glibc
> prototype in bits/sched.h also looks like this:
>
> extern int clone (int (*__fn) (void *__arg), void *__child_stack, int __f=
lags, void *__arg, ...) __THROW;
>
> The additionl args parent_tid, tls, and child_tid are present in _all_
> clone version in the same order. In fact the glibc wrapper here give the
> illusion that it's parent_tid, tls, child_tid. The underlying syscall
> has a different order parent_tidptr, child_tidptr, tls.
>
> Florian, can you advise what prototype we should mention for the glibc
> clone() wrapper here. I'd like it to be as simple as possible and get
> rid of the ...
> Architectural differences are explained in detail below anyway.

Our header has:

/* Clone current process.  */
extern int clone (int (*__fn) (void *__arg), void *__child_stack,
                  int __flags, void *__arg, ...) __THROW;

I have not checked all assembler implementations.  In theory there could
be one that relies on the different calling convention for variadic
functions (e.g., the existence of a parameter save area on POWER).  Or
that swaps arguments in some architecure-specific way. 8-(

I don't have much guidance on this matter, sorry.  I expect that for
clone3, we'll provide a same-stack variant as well (for fork/vfork-like
usage), which will be much closer to the kernel interface.  clone/clone2
doesn't seem very fixable to me at this point.

Thanks,
Florian
