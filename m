From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Sun, 31 Mar 2019 17:18:10 -0700
Message-ID: <CAHk-=wi39-Ozq5zb22s7ZB4J_Nd6nTwE_9A3+qjp5nCY4iTSEg@mail.gmail.com>
References: <CAHk-=wj0o8BiUrYiM5ZcTS6JxBh1M60O36Ms8-EqLQ139=1L4g@mail.gmail.com>
 <20190330171215.3yrfxwodstmgzmxy@brauner.io> <CAHk-=whF6gnRVbJaArZna4e=tejfrzmNQtRbWjnuSSKpBn+jQg@mail.gmail.com>
 <132107F4-F56B-4D6E-9E00-A6F7C092E6BD@amacapital.net> <CAHk-=wiaLtH41Mc5qAjOeCWavPqV0DhS581KYa0QBt8uraTK1Q@mail.gmail.com>
 <20190331211041.vht7dnqg4e4bilr2@brauner.io> <CAHk-=wi3AE1-iRQ_7LOeSMNAMrGxRdC=gTjD30duVw4XRchcNQ@mail.gmail.com>
 <20190331220259.qntxynluk765hpnt@brauner.io> <CAHk-=wh0jgRkZiNdFD96Zpjx+_G+NVSHieAt+QgWCQBJ2A-5Aw@mail.gmail.com>
 <CAHk-=whw1cnWPSWw1tHXT5xTMbnJFbCtx9_re6U1RZ_7LE9gXA@mail.gmail.com> <20190401000937.GG2217@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190401000937.GG2217@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian@brauner.io>, Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linu>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 5:09 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Ugh...  Which vfsmount would you have to go with it?

I'd literally just do a lookup of "/proc" in the current root
directory in the lookup() function for that special pseudo-dentry.

If it's not mounted, or not a /proc filesystem, screw it.

> Except that we never let unattached _directory_ dentries out - if
> we can't reattach them to the tree, open-by-handle will tell you to
> take a hike.

Absolutely. Which is why I said it's _conceptually_ similar to the alias lookup.

And I suspect we can even use some of the same practical logic, but
it's definitely not _exactly_ the same. This thing very much involves
magic hooking into the lookup() function (but we then have to look up
the alias not for the path we're looking up, but for the _parent_
we're looking that path up in, which is very different from the normal
case).

> It's more than a tiny bit too clever for mine...

Fair enough. The whole "just do the whole lookup at pidfd creation
time" is certainly a whole lot simpler.

> Al, back to normal life and digging through several flamefests from
> hell...

Yeah, I would like to see the actual aio.c pull request and the
use-after-free fixes. All the patches look fine, I just don't have the
final end result..

And that takes precedence anyway. Right now the "open_pidfd()" is a
future discussion.

                Linus
