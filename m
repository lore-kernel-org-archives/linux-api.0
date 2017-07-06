From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v10 1/3] x86/syscalls: Check address limit on user-mode
 return
Date: Thu, 6 Jul 2017 22:48:46 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1707062247520.3239@nanos>
References: <20170615011203.144108-1-thgarnie@google.com> <CAGXu5j+byHUn_rb9jOTZqMYrc4ngmDj=a3k8QRTYrZYNSjhCkw@mail.gmail.com> <CAGXu5jKrJv0y70e5JiafKGcGzWoJPZM_HruZ=Y0rM1m0J4tZAA@mail.gmail.com>
 <CAJcbSZE6Og4gwhFwhy_-Jaq6GovwN3y1B6O89JmkpXHtVfDLBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJcbSZE6Og4gwhFwhy_-Jaq6GovwN3y1B6O89JmkpXHtVfDLBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Pratyush Anand <panand-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 6 Jul 2017, Thomas Garnier wrote:
> On Wed, Jun 28, 2017 at 10:52 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> >
> > On Tue, Jun 20, 2017 at 1:24 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> > > On Wed, Jun 14, 2017 at 6:12 PM, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > >> Ensure the address limit is a user-mode segment before returning to
> > >> user-mode. Otherwise a process can corrupt kernel-mode memory and elevate
> > >> privileges [1].
> > >>
> > >> The set_fs function sets the TIF_SETFS flag to force a slow path on
> > >> return. In the slow path, the address limit is checked to be USER_DS if
> > >> needed.
> > >>
> > >> The addr_limit_user_check function is added as a cross-architecture
> > >> function to check the address limit.
> > >>
> > >> [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
> > >>
> > >> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > >
> > > Thanks for reworking this series!
> > >
> > > The bad state correctly BUGs under the LKDTM test:
> > >
> > > [   21.171586] lkdtm: Performing direct entry CORRUPT_USER_DS
> > > [   21.172791] lkdtm: setting bad task size limit
> > > [   21.173742] ------------[ cut here ]------------
> > > [   21.174641] kernel BUG at ./include/linux/syscalls.h:220!
> > > ...
> > > [   21.193166] Call Trace:
> > > [   21.193617]  ? trace_hardirqs_on_thunk+0x1a/0x1c
> > > [   21.194443]  entry_SYSCALL64_slow_path+0x25/0x25
> > >
> > >
> > > Tested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> >
> > Is everyone happy with this patch for x86? Does this need anything
> > more/different?
> 
> Asking again. Additional feedback? Anyone wants to pick-it up?

Can do. This needs to be a combo of all 3 I assume as the x86 one contains
the function used by all of them, right?

Thanks,

	tglx
