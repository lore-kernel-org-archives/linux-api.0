From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 07:37:42 +0100
Message-ID: <20190401063741.GH2217@ZenIV.linux.org.uk>
References: <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net>
 <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io>
 <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <20190331220259.qntxynluk765hpnt@brauner.io>
 <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
 <CAHk-=whw1cnWPSWw1tHXT5xTMbnJFbCtx9_re6U1RZ_7LE9gXA@mail.gmail.com>
 <20190401000937.GG2217@ZenIV.linux.org.uk>
 <CAHk-=wi39-Ozq5zb22s7ZB4J_Nd6nTwE_9A3+qjp5nCY4iTSEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wi39-Ozq5zb22s7ZB4J_Nd6nTwE_9A3+qjp5nCY4iTSEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <christian@brauner.io>, Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linu>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 05:18:10PM -0700, Linus Torvalds wrote:

> Yeah, I would like to see the actual aio.c pull request and the
> use-after-free fixes. All the patches look fine, I just don't have the
> final end result..

use-after-free fixes: ceph is already in mainline, Daniel's bpf fix is in
bpf tree (1da6c4d9140c "bpf: fix use after free in bpf_evict_inode"),
the rest is in vfs.git#fixes.

The following changes since commit 9e98c678c2d6ae3a17cb2de55d17f69dddaa231b:

  Linux 5.1-rc1 (2019-03-17 14:22:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git fixes

for you to fetch changes up to 93b919da64c15b90953f96a536e5e61df896ca57:

  debugfs: fix use-after-free on symlink traversal (2019-04-01 00:31:02 -0400)

----------------------------------------------------------------
Al Viro (3):
      jffs2: fix use-after-free on symlink traversal
      ubifs: fix use-after-free on symlink traversal
      debugfs: fix use-after-free on symlink traversal

 fs/debugfs/inode.c   | 13 +++++++++----
 fs/jffs2/readinode.c |  5 -----
 fs/jffs2/super.c     |  5 ++++-
 fs/ubifs/super.c     |  4 +---
 4 files changed, 14 insertions(+), 13 deletions(-)
