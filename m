From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Wed, 23 Oct 2019 19:27:08 -0400
Message-ID: <20191023232708.GA433@redhat.com>
References: <20191023224110.GE9902@redhat.com>
 <EB0634BD-AAF4-4805-8178-30FFA94B7B58@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EB0634BD-AAF4-4805-8178-30FFA94B7B58@amacapital.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Daniel Colascione <dancol@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Pavel Emelyanov <xemul@virtuozzo.com>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Tim Murray <timmurray@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 23, 2019 at 04:01:53PM -0700, Andy Lutomirski wrote:
> Delivering events through read() is just fine. The problem is when
> delivering an event does more than just returning bytes. As far as
> I=E2=80=99ve noticed, uffd=E2=80=99s read() just returns bytes as long as=
 FORK is
> disabled.

Yes, fork is the only case where read doesn't return bytes.

Moving only the fd creation to a separate syscall would then avoid
involuntary creation of the fd.
