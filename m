From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH 1/2] fork: add clone6
Date: Mon, 27 May 2019 21:36:18 +0200
Message-ID: <CAG48ez2wyDhM-V1hs5ya1R4x7wHT=T8XLOYCPUyw97kzzLhbhg@mail.gmail.com>
References: <20190526102612.6970-1-christian@brauner.io> <CAHk-=wieuV4hGwznPsX-8E0G2FKhx3NjZ9X3dTKh5zKd+iqOBw@mail.gmail.com>
 <20190527104239.fbnjzfyxa4y4acpf@brauner.io> <CAHk-=wjnbK5ob9JE0H1Ge_R4BL6D0ztsAvrM6DN+S+zyDWE=7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=wjnbK5ob9JE0H1Ge_R4BL6D0ztsAvrM6DN+S+zyDWE=7A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

+Kees

On Mon, May 27, 2019 at 9:27 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, May 27, 2019 at 3:42 AM Christian Brauner <christian@brauner.io> wrote:
> > Hm, still pondering whether having one unsigned int argument passed
> > through registers that captures all the flags from the old clone() would
> > be a good idea.
>
> That sounds like a reasonable thing to do.
>
> Maybe we could continue to call the old flags CLONE_XYZ and continue
> to pass them in as "flags" argument, and then we have CLONE_EXT_XYZ
> flags for a new 64-bit flag field that comes in through memory in the
> new clone_args thing?

With the current seccomp model, that would have the unfortunate effect
of making it impossible to filter out new clone flags - which would
likely mean that people who want to sandbox their code would not use
the new clone() because they don't want their sandboxed code to be
able to create time namespaces and whatever other new fancy things
clone() might support in the future. This is why I convinced Christian
to pass flags in registers for the first patch version.

The alternative I see would be to somehow extend seccomp to support
argument structures that are passed in memory - that would probably
require quite a bit of new plumbing though, both in the kernel and in
userspace code that configures seccomp filters.
