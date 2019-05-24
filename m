From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 1/2] open: add close_range()
Date: Fri, 24 May 2019 11:57:04 +0200
Message-ID: <20190524095701.b7ioi5gg573vmajh@brauner.io>
References: <20190522155259.11174-1-christian@brauner.io>
 <67e4458a-9cc4-d1aa-608c-73ebe9e2f7a3@yandex-team.ru>
 <20190523163345.q5ynd2ytk7nxcvqf@brauner.io>
 <CAK8P3a26uvqmExJZsezhB+cp2ADM0Ai9jVUKWOFM6kg848bCKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a26uvqmExJZsezhB+cp2ADM0Ai9jVUKWOFM6kg848bCKg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <shuah@kernel.org>, David Howells <dhowells@redhat.com>, Todd Kjos <tkjos@android.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Miklos Szeredi <miklos@szeredi.hu>, alpha <linux-alpha@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-ia64@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.or>
List-Id: linux-api@vger.kernel.org

On Fri, May 24, 2019 at 09:43:53AM +0200, Arnd Bergmann wrote:
> On Thu, May 23, 2019 at 6:33 PM Christian Brauner <christian@brauner.io> wrote:
> > On Thu, May 23, 2019 at 07:22:17PM +0300, Konstantin Khlebnikov wrote:
> > > On 22.05.2019 18:52, Christian Brauner wrote:> This adds the close_range() syscall. It allows to efficiently close a range
> > > >   22 files changed, 100 insertions(+), 9 deletions(-)
> > > >
> > >
> > > It would be better to split arch/ wiring into separate patch for better readability.
> >
> > Ok. You mean only do x86 - seems to be the standard - and then move the
> > others into a separate patch? Doesn't seem worth to have a patch
> > per-arch, I'd think.
> 
> I think I would prefer the first patch to just add the call without wiring it up
> anywhere, and a second patch do add it on all architectures including x86.

I've split this into two patches and also bumped arm64
__NR_compat_syscalls that I've missed before as you mentioned!

Thanks!
Christian
