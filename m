From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] arch: add pidfd and io_uring syscalls everywhere
Date: Wed, 24 Apr 2019 09:16:26 +0200
Message-ID: <CAK8P3a2vmEkqN2FLu6C5TPGyDZ4F=tUENJXz_E_oeqdN1RDqQA@mail.gmail.com>
References: <CAK8P3a3bT=HO=YQ7PY7wOEsJTzf0jS4PkqNHSqYX4JjwmbhY+g@mail.gmail.com>
 <20190424004131.GA19764@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190424004131.GA19764@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 24, 2019 at 2:41 AM Dmitry V. Levin <ldv@altlinux.org> wrote:
> On Tue, Apr 23, 2019 at 09:28:48PM +0200, Arnd Bergmann wrote:
> > The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:
> >
> >   Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)
> >
> > are available in the Git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
> > syscalls-5.1
> >
> > for you to fetch changes up to 39036cd2727395c3369b1051005da74059a85317:
> >
> >   arch: add pidfd and io_uring syscalls everywhere (2019-04-15 16:31:17 +0200)
> >
> > ----------------------------------------------------------------
> > arch: add pidfd and io_uring syscalls everywhere
> >
> > This comes a bit late, but should be in 5.1 anyway: we want the newly
> > added system calls to be synchronized across all architectures in
> > the release.
> >
> > I hope that in the future, any newly added system calls can be added
> > to all architectures at the same time, and tested there while they
> > are in linux-next, avoiding dependencies between the architecture
> > maintainer trees and the tree that contains the new system call.
>
> Is "everywhere" really means everywhere?
> The reason I'm asking this question is that sh64 seems to be excluded:
> arch/sh/kernel/syscalls_64.S hasn't got any syscall entries since commit
> v4.8-rc1~15^2~3.  Is sh64 supported in any way at all?

sh64 is dead, the only reason those files are still there is because nobody
has bothered to create the patch to remove them.

It has not been possible to even build an sh64 kernel for many years,
and I'm sure none of the prototypes have been turned on for even longer
if they are still in someone's board pile.

     Arnd
