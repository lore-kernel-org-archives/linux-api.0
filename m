From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date: Tue, 5 Nov 2019 14:10:16 -0800
Message-ID: <CAKOZuetCqQa_be_2Ek-zo58TA5nLKVFb4f01ahcACxiQ9Th80A@mail.gmail.com>
References: <CAKOZuet+fgaJR72YwYrHFdFVSOo6EWpcT8jUoh7se4cZb0V2aw@mail.gmail.com>
 <273986A1-A4BE-4FE5-B547-49CAA44C6FD3@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <273986A1-A4BE-4FE5-B547-49CAA44C6FD3@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andy Lutomirski <luto@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 5, 2019 at 2:01 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > On Nov 5, 2019, at 9:02 AM, Daniel Colascione <dancol@google.com> wrote=
:
> >
> > =EF=BB=BFOn Tue, Nov 5, 2019 at 8:56 AM Andrea Arcangeli <aarcange@redh=
at.com> wrote:
> >>
> >>> On Tue, Nov 05, 2019 at 08:39:26AM -0800, Daniel Colascione wrote:
> >>> I'm not suggesting that we fail userfaultfd(2) without CAP_SYS_PTRACE=
.
> >>> That would, as you point out, break things. I'm talking about
> >>> recording *whether* we had CAP_SYS_PTRACE in an internal flag in the
> >>> uffd context when we create the thing --- and then, at ioctl time,
> >>> checking that flag, not the caller's CAP_SYS_PTRACE, to see whether
> >>> UFFD_FEATURE_EVENT_FORK should be made available. This way, the
> >>> security check hinges on whether the caller *at create time* was
> >>> privileged.
> >>
> >> Until now it wasn't clear to me you still wanted to do the permission
> >> check in UFFDIO_API time, and you only intended to move the
> >> "measurement" of the capability to the syscall.
> >>
> >> So you're suggesting to add more kernel complexity to code pending for
> >> removal to achieve a theoretically more pure solution in the band-aid
> >> required to defer the removal of the posix-breaking read
> >> implementation of the uffd fork feature?
> >
> > And you're suggesting making a security check work weirdly unlike most
> > other security checks because you hope it'll get removed one day?
> > Temporary solutions aren't, and if something goes into the kernel at
> > all, it's worth getting right. The general rule is that access checks
> > happen at open time. The kernel has already been bitten by UFFD
> > exempting itself from the normal rules (e.g., the
> > read(2)-makes-a-file-descriptor thing) in the name of expediency.
> > There shouldn't be any more exceptions.
>
> I don=E2=80=99t think ioctl() checking permission is particularly unusual=
. In principle, it=E2=80=99s better than open for a retrofit =E2=80=94 open=
 didn=E2=80=99t capture this permission in the past, so adding it makes an =
existing capability stronger than it was, which isn=E2=80=99t fantastic.

All right, let's do it the way the OP's patch does it then.
