From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/2] fork: add clone6
Date: Mon, 27 May 2019 12:27:08 -0700
Message-ID: <CAHk-=wjnbK5ob9JE0H1Ge_R4BL6D0ztsAvrM6DN+S+zyDWE=7A@mail.gmail.com>
References: <20190526102612.6970-1-christian@brauner.io> <CAHk-=wieuV4hGwznPsX-8E0G2FKhx3NjZ9X3dTKh5zKd+iqOBw@mail.gmail.com>
 <20190527104239.fbnjzfyxa4y4acpf@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190527104239.fbnjzfyxa4y4acpf@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 27, 2019 at 3:42 AM Christian Brauner <christian@brauner.io> wrote:
>
> Hm, still pondering whether having one unsigned int argument passed
> through registers that captures all the flags from the old clone() would
> be a good idea.

That sounds like a reasonable thing to do.

Maybe we could continue to call the old flags CLONE_XYZ and continue
to pass them in as "flags" argument, and then we have CLONE_EXT_XYZ
flags for a new 64-bit flag field that comes in through memory in the
new clone_args thing?

That would make the flag arguments less "unified", but might make for
a simpler patch, and might make it easier for the old interfaces to
just pass in the clone flags they already have in registers instead of
setting them up in the clone_args structure.

I don't think it's necessarily wrong for the interface to show some
effects of legacy models, as long as we don't have those kinds of "if
(is_clone6)" nasties.

                   Linus
