From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 1/2] pid: add pidfd_open()
Date: Mon, 20 May 2019 16:59:16 +0200
Message-ID: <CAK8P3a2u2gftAuzTfspAUCvWPPE0YVNOATFPN__tEQoO4GXg-g@mail.gmail.com>
References: <20190520134605.29116-1-christian@brauner.io> <CAK8P3a1cZZ6SQe5mGjhga=MgTvCGF6OKyjvosR8J6z6EpH+rVA@mail.gmail.com>
 <20190520144822.xfaifawi65jus6ng@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520144822.xfaifawi65jus6ng@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, cyphar@cyphar.com, David Howells <dhowells@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, alpha <linux-alpha@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-ia64@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>, linux-mips@vger.kernel.org, Parisc List <linux-parisc@v>
List-Id: linux-api@vger.kernel.org

On Mon, May 20, 2019 at 4:48 PM Christian Brauner <christian@brauner.io> wrote:
>
> On Mon, May 20, 2019 at 04:37:03PM +0200, Arnd Bergmann wrote:
> > On Mon, May 20, 2019 at 3:46 PM Christian Brauner <christian@brauner.io> wrote:
> > >
> > > In line with Arnd's recent changes to consolidate syscall numbers across
> > > architectures, I have added the pidfd_open() syscall to all architectures
> > > at the same time.
> >
> > Thanks! I've checked that the ones you have added are all
> > done correctly. However, double-checking that you got all of them,
> > I noticed that you missed mips-o32 and mips-n64. With those added:
> >
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> Perfect, will plumb mips-o32 and mips-n64 and resend once more with your
> ack added.
> Sidenote: You plan on merging the common syscall tables or will there be
> a script to do this work per-arch in the future?

David Howells also asked about this. I think having a common table will
be best in the long run, patches welcome.

As you noticed, there are still a few minor differences between the files
on mips, arm, x86, alpha and s390, and we are missing the .tbl files
for arm-compat and asm-generic, as well as an architecture independent
script.

Once that is all taken care of, we can move the entries for syscall
403 and higher into a common file, and change the script to pick
up the contents from there in addition to the architecture specific
file.

      Arnd
