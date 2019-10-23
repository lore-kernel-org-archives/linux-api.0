From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Wed, 23 Oct 2019 16:01:53 -0700
Message-ID: <EB0634BD-AAF4-4805-8178-30FFA94B7B58@amacapital.net>
References: <20191023224110.GE9902@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191023224110.GE9902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
List-Id: linux-api@vger.kernel.org



> On Oct 23, 2019, at 3:41 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:=

>=20
> =EF=BB=BFOn Wed, Oct 23, 2019 at 02:25:35PM -0700, Andy Lutomirski wrote:
>> That doesn't solve the problem.  With your time machine, you should
>=20
> Would you elaborate what problem remains if execve closes all uffd
> so that read() cannot run post execve?
>=20

fcntl() can clear the CLOEXEC flag. And CLOEXEC has no effect on SCM_RIGHTS.=


>> instead use ioctl() or recvmsg().
>=20
> The event delivery is modeled after eventfd.c per userfaultfd.c header
> file, so would then eventfd also need to be converted to ioctl or
> recvmsg to deliver its event any better? Initially I evaluated to use
> eventfd for it in fact, but it wasn't possible. I didn't look like it
> could get any better than eventfd in terms of event delivery.
>=20
> Or do you refer to single out only the delivery of the UFFD_EVENT_FORK
> event not through read()?

Delivering events through read() is just fine. The problem is when deliverin=
g an event does more than just returning bytes. As far as I=E2=80=99ve notic=
ed, uffd=E2=80=99s read() just returns bytes as long as FORK is disabled.
