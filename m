From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 0/5] pid: add pidfd_open()
Date: Mon, 1 Apr 2019 02:21:49 +0200
Message-ID: <20190401002147.vv23md5spi34uyjz@brauner.io>
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
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wi39-Ozq5zb22s7ZB4J_Nd6nTwE_9A3+qjp5nCY4iTSEg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>, Daniel Colascione <dancol@google.com>, Jann Horn <jannh@google.com>, Andrew Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Jonathan Kowalski <bl0pbl33p@gmail.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Andrew Morton <akpm@linux-found>
List-Id: linux-api@vger.kernel.org

On Sun, Mar 31, 2019 at 05:18:10PM -0700, Linus Torvalds wrote:
> On Sun, Mar 31, 2019 at 5:09 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Ugh...  Which vfsmount would you have to go with it?
> 
> I'd literally just do a lookup of "/proc" in the current root
> directory in the lookup() function for that special pseudo-dentry.
> 
> If it's not mounted, or not a /proc filesystem, screw it.
> 
> > Except that we never let unattached _directory_ dentries out - if
> > we can't reattach them to the tree, open-by-handle will tell you to
> > take a hike.
> 
> Absolutely. Which is why I said it's _conceptually_ similar to the alias lookup.
> 
> And I suspect we can even use some of the same practical logic, but
> it's definitely not _exactly_ the same. This thing very much involves
> magic hooking into the lookup() function (but we then have to look up
> the alias not for the path we're looking up, but for the _parent_
> we're looking that path up in, which is very different from the normal
> case).
> 
> > It's more than a tiny bit too clever for mine...
> 
> Fair enough. The whole "just do the whole lookup at pidfd creation
> time" is certainly a whole lot simpler.

Even just from a pure maintenance perspective this sounds a better to me.
