From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 2/2] arch: wire-up clone3() syscall
Date: Mon, 1 Jul 2019 17:14:51 +0200
Message-ID: <CAK8P3a0f_=q88JB=t7fbmweAbZ2E2_uCMt+2JoBYx3od_M6fHQ@mail.gmail.com>
References: <20190604160944.4058-1-christian@brauner.io> <20190604160944.4058-2-christian@brauner.io>
 <20190620184451.GA28543@roeck-us.net> <20190620221003.ciuov5fzqxrcaykp@brauner.io>
 <CAK8P3a2iV7=HkHBVL_puvCQN0DmdKEnVs2aG9MQV_8Q58JSfTA@mail.gmail.com>
 <20190621111839.v5yqlws6iw7mx4aa@brauner.io> <CAK8P3a0T1=eg5ONbMFhHi=vmk1K5uogZ+5=wpsXvjVDzn6vS=Q@mail.gmail.com>
 <20190621153012.fxwhx25mzmzueqh7@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190621153012.fxwhx25mzmzueqh7@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Guenter Roeck <linux@roeck-us.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Linux API <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Ley Foon Tan <lftan@altera.com>, "moderated list:NIOS2 ARCHITECTURE" <nios2-dev@lists.rocketboards.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 5:30 PM Christian Brauner <christian@brauner.io> wrote:
> On Fri, Jun 21, 2019 at 04:20:15PM +0200, Arnd Bergmann wrote:
> > On Fri, Jun 21, 2019 at 1:18 PM Christian Brauner <christian@brauner.io> wrote:
> Hm, if you believe that this is fine and want to "vouch" for it by
> whipping up a patch that replaces the wiring up done in [1] I'm happy to
> take it. :) Otherwise I'd feel more comfortable not adding all arches at
> once.
>
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=clone

Sorry for my late reply. I had actually looked at the implementations
in a little
more detail and I think you are right that adding these are better
left to the arch
maintainers in case of clone3.

      Arnd
