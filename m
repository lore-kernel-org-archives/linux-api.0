From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 0/3] ABI CHANGE!!! Remove questionable remote SP reads
Date: Mon, 3 Oct 2016 16:08:24 -0700
Message-ID: <CALCETrULWhzph=kpbQUQSEkmsm6ZaRtp_bV9j5LFaFjLkawwMw@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1475257877.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 30, 2016 at 10:58 AM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Jann Horn noticed that KSTK_ESP + eager task stack freeing was a bad
> combination and could crash.  I could very easily fix it to not
> crash, but I think that using KSTK_ESP on a remote task is
> questionable in general.  Therefore, I propose to get rid of the
> major users for 4.9.

Ping!

We need to decide fairly soon whether to apply these (or perhaps just
patch 1 or just patches 2 and 3) for 4.9.  For any parts that aren't
applied, I'll send quick fixups to pin the stack in the offending
code.

--Andy
