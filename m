From: Jann Horn <jannh@google.com>
Subject: Re: For review: documentation of clone3() system call
Date: Mon, 11 Nov 2019 16:15:58 +0100
Message-ID: <CAG48ez3zpBwU6vHSuY6VoP+Uw_Jz6uxYN1Teg2wSpwZrPmAn-g@mail.gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <87tv7awj4g.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87tv7awj4g.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 11, 2019 at 4:03 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Michael Kerrisk:
>
> >        Another  difference  for  the  raw clone() system call is that t=
he
> >        stack argument may be NULL, in which case the child uses a  dupl=
i=E2=80=90
> >        cate  of the parent's stack.  (Copy-on-write semantics ensure th=
at
> >        the child gets separate copies of stack pages when either  proce=
ss
> >        modifies  the  stack.)   In  this case, for correct operation, t=
he
> >        CLONE_VM option should not be specified.  (If the child shares t=
he
> >        parent's  memory  because of the use of the CLONE_VM flag, then =
no
> >        copy-on-write duplication occurs and chaos is likely to result.)
>
> I think sharing the stack also works with CLONE_VFORK with CLONE_VM, as
> long as measures are taken to preserve the return address in a register.

That basically just requires that the userspace function declaration
for clone3 includes __attribute__((returns_twice)), right?
