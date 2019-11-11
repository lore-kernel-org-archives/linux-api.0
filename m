From: Florian Weimer <fweimer@redhat.com>
Subject: Re: For review: documentation of clone3() system call
Date: Mon, 11 Nov 2019 16:03:11 +0100
Message-ID: <87tv7awj4g.fsf@oldenburg2.str.redhat.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
        (Michael Kerrisk's message of "Fri, 25 Oct 2019 18:59:31 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

* Michael Kerrisk:

>        Another  difference  for  the  raw clone() system call is that the
>        stack argument may be NULL, in which case the child uses a  dupli=
=E2=80=90
>        cate  of the parent's stack.  (Copy-on-write semantics ensure that
>        the child gets separate copies of stack pages when either  process
>        modifies  the  stack.)   In  this case, for correct operation, the
>        CLONE_VM option should not be specified.  (If the child shares the
>        parent's  memory  because of the use of the CLONE_VM flag, then no
>        copy-on-write duplication occurs and chaos is likely to result.)

I think sharing the stack also works with CLONE_VFORK with CLONE_VM, as
long as measures are taken to preserve the return address in a register.

Thanks,
Florian
