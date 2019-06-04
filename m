From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 1/2] fork: add clone3
Date: Tue, 4 Jun 2019 12:49:40 +0200
Message-ID: <20190604104939.e7qhojiarfb2m3rh@brauner.io>
References: <20190603144331.16760-1-christian@brauner.io>
 <CAK8P3a0qBaQGu2h3yG45kvf=cgiQfkeiFw60WvD47H4BoEJiyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a0qBaQGu2h3yG45kvf=cgiQfkeiFw60WvD47H4BoEJiyQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 04, 2019 at 12:36:24PM +0200, Arnd Bergmann wrote:
> On Mon, Jun 3, 2019 at 4:44 PM Christian Brauner <christian@brauner.io> wrote:
> 
> > +
> > +#ifdef __ARCH_WANT_SYS_CLONE
> > +asmlinkage long sys_clone3(struct clone_args __user *uargs, size_t size);
> > +#endif
> 
> I would leave it outside of __ARCH_WANT_SYS_CLONE, as far
> as I can tell the only reason for that #ifdef is so architectures that
> have their own sys_clone implementation can opt out of the generic
> one, but we don't want that for new syscalls.
> 
> In fact, I'd prefer to drop the symbol entirely and have a different
> symbol with the opposite meaning such as
> __ARCH_NONSTANDARD_SYS_CLONE that only gets
> selected by sparc, ia64 and m68k. That should be a separate
> patch though, and I'm not asking you to do it, unless you
> want to clean up a little more.

I am totally up for this but I would prefer if we land clone3() in the
5.3 merge window and then for 5.3 rc{2,3} do the cleanups that David and
you suggested.
This leaves this patchset lean and easy to review.

Christian
