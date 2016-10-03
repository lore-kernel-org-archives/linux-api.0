From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 0/3] ABI CHANGE!!! Remove questionable remote SP reads
Date: Mon, 3 Oct 2016 16:17:49 -0700
Message-ID: <CA+55aFzo0xpbxbajpgcfyYoLyKihCiyMfgc+yCJ+b9ohw6wycQ@mail.gmail.com>
References: <cover.1475257877.git.luto@kernel.org> <CALCETrULWhzph=kpbQUQSEkmsm6ZaRtp_bV9j5LFaFjLkawwMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrULWhzph=kpbQUQSEkmsm6ZaRtp_bV9j5LFaFjLkawwMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 3, 2016 at 4:08 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>
> Ping!
>
> We need to decide fairly soon whether to apply these (or perhaps just
> patch 1 or just patches 2 and 3) for 4.9.  For any parts that aren't
> applied, I'll send quick fixups to pin the stack in the offending
> code.

I think we should apply it. Hopefully nothing uses it, and nobody will
notice. And if somebody *does* notice, the sooner we find out, the
better.

             Linus
