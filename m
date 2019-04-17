From: Christian Brauner <christian@brauner.io>
Subject: Re: RFC: on adding new CLONE_* flags [WAS Re: [PATCH 0/4] clone: add
 CLONE_PIDFD]
Date: Wed, 17 Apr 2019 14:54:23 +0200
Message-ID: <20190417125422.bhyrmzom4kwuenwm@brauner.io>
References: <20190414201436.19502-1-christian@brauner.io>
 <dc05ffe3-c2ff-8b3e-d181-e0cc620bf91d@metux.net>
 <20190415195911.z7b7miwsj67ha54y@yavin>
 <CALCETrWxMnaPvwicqkMLswMynWvJVteazD-bFv3ZnBKWp-1joQ@mail.gmail.com>
 <c783a83a-01a1-9813-e2f7-0516cf7a1c16@metux.net>
 <CALCETrWWoEvnzx6oLTEajBmiArScX5sSt74o2VO+aTiwEi_9mQ@mail.gmail.com>
 <e58d1694-c143-3465-512d-43301422bd8b@metux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e58d1694-c143-3465-512d-43301422bd8b@metux.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc: Andy Lutomirski <luto@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Joel Fernandes <joel@joelfernandes.org>, Daniel Colascione <dancol@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 17, 2019 at 02:03:16PM +0200, Enrico Weigelt, metux IT consult wrote:
> On 16.04.19 23:31, Andy Lutomirski wrote:
> 
> >> How exactly would the pidfd improve this scenario ?
> >> IMHO, would just need to pass the inherited fd's to that daemon (eg.
> >> via unix socket) which then sets them up in the new child process.
> > 
> > It makes it easier to wait until the privileged program exits.
> > Without pidfd, you can't just wait(2) because the program that gets
> > spawned isn't a child.  
> 
> Ah, that is a cool thing !
> I suppose that also works across namespaces ?

Yes, it should. If you hand off the pidfd to another pidns (e.g. via SCM
credentials) for example.

> 
> What other things can be done via pidfd ?

Very basic things right now and until CLONE_PIDFD is accepted (possibly
for 5.2) we won't enable any more features.
I'm not a fan of wild speculations and grand schemes that then don't
come to fruition. :) Right now it's about focussing on somewhat cleanly
covering the basics. Coming to a consensus there was hard enough. We
have no intention in making this more complex right now as it needs to
be.

Christian
