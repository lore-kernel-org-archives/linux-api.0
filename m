From: Florian Weimer <fweimer@redhat.com>
Subject: Re: For review: documentation of clone3() system call
Date: Mon, 11 Nov 2019 16:20:36 +0100
Message-ID: <875zjqwibf.fsf@oldenburg2.str.redhat.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
        <87tv7awj4g.fsf@oldenburg2.str.redhat.com>
        <CAG48ez3zpBwU6vHSuY6VoP+Uw_Jz6uxYN1Teg2wSpwZrPmAn-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez3zpBwU6vHSuY6VoP+Uw_Jz6uxYN1Teg2wSpwZrPmAn-g@mail.gmail.com>
        (Jann Horn's message of "Mon, 11 Nov 2019 16:15:58 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

* Jann Horn:

> On Mon, Nov 11, 2019 at 4:03 PM Florian Weimer <fweimer@redhat.com> wrote=
:
>>
>> * Michael Kerrisk:
>>
>> >        Another  difference  for  the  raw clone() system call is that =
the
>> >        stack argument may be NULL, in which case the child uses a  dup=
li=E2=80=90
>> >        cate  of the parent's stack.  (Copy-on-write semantics ensure t=
hat
>> >        the child gets separate copies of stack pages when either  proc=
ess
>> >        modifies  the  stack.)   In  this case, for correct operation, =
the
>> >        CLONE_VM option should not be specified.  (If the child shares =
the
>> >        parent's  memory  because of the use of the CLONE_VM flag, then=
 no
>> >        copy-on-write duplication occurs and chaos is likely to result.=
)
>>
>> I think sharing the stack also works with CLONE_VFORK with CLONE_VM, as
>> long as measures are taken to preserve the return address in a register.
>
> That basically just requires that the userspace function declaration
> for clone3 includes __attribute__((returns_twice)), right?

The clone3 implementation itself would have to store the return address
in a register because at the time of the second return, a return address
on the stack may have been corrupted by the subprocess because what used
to be the stack frame of the clone function has since been reused for
something else.

__attribute__ ((returns_twice)) is likely needed as well, but that
benefits the caller.  It's also not clear that it is sufficient for this
to work in all cases.  (But the mandatory-to-implement vfork function
faces the same problems.)

Thanks,
Florian
