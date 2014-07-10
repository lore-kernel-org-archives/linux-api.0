From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v9 09/11] seccomp: introduce writer locking
Date: Thu, 10 Jul 2014 19:35:52 +0200
Message-ID: <20140710173552.GA27410@redhat.com>
References: <1403911380-27787-1-git-send-email-keescook@chromium.org> <1403911380-27787-10-git-send-email-keescook@chromium.org> <20140709184215.GA4866@redhat.com> <20140709185549.GB4866@redhat.com> <CAGXu5jL6q1d16uA1Yu+QO4eV7zWwcWEWgkZrwmsfymbMvEr6+Q@mail.gmail.com> <20140710152418.GB20861@redhat.com> <CAGXu5jKNUn0OcXPyTmqbHwQ_GPMNTeajyrxpd2xAtzjTRFyhpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jKNUn0OcXPyTmqbHwQ_GPMNTeajyrxpd2xAtzjTRFyhpg@mail.gmail.com>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Kees Cook <keescook@chromium.org>
Cc: linux-arch <linux-arch@vger.kernel.org>, linux-mips@linux-mips.org, Will Drewry <wad@chromium.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <dborkman@redhat.com>, Julien Tinnes <jln@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, David Drysdale <drysdale@google.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On 07/10, Kees Cook wrote:
>
> On Thu, Jul 10, 2014 at 8:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Just to simplify. Suppose TIF_SECCOMP was set a long ago. This thread
> > has a single filter F1 and it enters seccomp_run_filters().
> >
> > Right before it does ACCESS_ONCE() to read the pointer, another thread
> > does seccomp_sync_threads() and sets .filter = F2.
> >
> > If ACCESS_ONCE() returns F1 - everything is fine. But it can see the new
> > pointer F2, and in this case we need a barrier to ensure that, say,
> > LOAD(F2->prog) will see all the preceding changes in this memory.
>
> And the rmb() isn't sufficient for that?

But it has no effect if the pointer was changed _after_ rmb() was already
called.

And, you need a barrier _after_ ACCESS_ONCE().

(Unless, again, we know that this is the first filter, but this is only
 by accident).

> Is another barrier needed
> before assigning the filter pointer to make sure the contents it
> points to are flushed?

I think smp_store_release() should be moved from seccomp_attach_filter()
to seccomp_sync_threads(). Although probably it _should_ work either way,
but at least this looks confusing because a) "current" doesn't need a
barrier to serialize wuth itself, and b) it is not clear why it is safe
to change the pointer dereferenced by another thread without a barrier.

> What's the least time-consuming operation I can use in run_filters?

As I said smp_read_barrier_depends() (nop unless alpha) or
smp_load_acquire() which you used in the previous version.

And to remind, afaics smp_load_acquire() in put_filter() should die ;)

Oleg.
