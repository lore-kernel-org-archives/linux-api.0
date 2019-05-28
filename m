From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 1/2] fork: add clone6
Date: Tue, 28 May 2019 07:15:37 -0700
Message-ID: <CALCETrU0wXuefHFzRNrQjQ+xgTz6tbPa-sLcBV=dV58QEcA6HQ@mail.gmail.com>
References: <20190526102612.6970-1-christian@brauner.io> <CAHk-=wieuV4hGwznPsX-8E0G2FKhx3NjZ9X3dTKh5zKd+iqOBw@mail.gmail.com>
 <20190527104239.fbnjzfyxa4y4acpf@brauner.io> <CAHk-=wjnbK5ob9JE0H1Ge_R4BL6D0ztsAvrM6DN+S+zyDWE=7A@mail.gmail.com>
 <20190528100802.sdfqtwrowrmulpml@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528100802.sdfqtwrowrmulpml@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 28, 2019 at 3:08 AM Christian Brauner <christian@brauner.io> wrote:
>
> On Mon, May 27, 2019 at 12:27:08PM -0700, Linus Torvalds wrote:
> > On Mon, May 27, 2019 at 3:42 AM Christian Brauner <christian@brauner.io> wrote:
> > >
> > > Hm, still pondering whether having one unsigned int argument passed
> > > through registers that captures all the flags from the old clone() would
> > > be a good idea.
> >
> > That sounds like a reasonable thing to do.
> >
> > Maybe we could continue to call the old flags CLONE_XYZ and continue
> > to pass them in as "flags" argument, and then we have CLONE_EXT_XYZ
> > flags for a new 64-bit flag field that comes in through memory in the
> > new clone_args thing?
>
> Hm. I think I'll try a first version without an additional register
> flags argument. And here's why: I'm not sure it buys us a lot especially
> if we're giving up on making this convenient for seccomp anyway.
> And with that out of the way (at least for the moment) I would really
> like to make this interface consistent. But we can revisit this when I
> have the code.
>

Seems reasonable.  Once the interface is nailed down, we can see if it
makes sense to break out some flags into a register.  I would guess
that all the unsharing flags are a good candidate.
