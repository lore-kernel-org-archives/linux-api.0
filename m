From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Mon, 8 Jan 2018 12:11:21 -0600
Message-ID: <20180108181121.GA32302@mail.hallyn.com>
References: <20171205223052.12687-1-mahesh@bandewar.net>
 <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <alpine.LFD.2.20.1712301931360.24310@localhost>
 <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost>
 <20180108062452.GA21717@mail.hallyn.com>
 <alpine.LFD.2.20.1801082040180.12014@localhost>
 <20180108154733.GA29416@mail.hallyn.com>
 <CAF2d9jgVJpuAH+jgK0v7sQ9Pr75xy=GSnqKDdpeE7d97O0EbcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jgVJpuAH+jgK0v7sQ9Pr75xy=GSnqKDdpeE7d97O0EbcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> On Mon, Jan 8, 2018 at 7:47 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting James Morris (james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org):
> >> On Mon, 8 Jan 2018, Serge E. Hallyn wrote:
> >> I meant in terms of "marking" a user ns as "controlled" type -- it's
> >> unnecessary jargon from an end user point of view.
> >
> > Ah, yes, that was my point in
> >
> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/01845.html
> > and
> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/02276.html
> >
> >> This may happen internally but don't make it a special case with a
> >> different name and don't bother users with internal concepts: simply
> >> implement capability whitelists with the default having equivalent

So the challenge is to have unprivileged users be contained, while
allowing trusted workloads in containers created by a root user to
bypass the restriction.

Now, the current proposal actually doesn't support a root user starting
an application that it doesn't quite trust in such a way that it *is*
subject to the whitelist.  Which is unfortunate.  But apart from using
ptags or a cgroup, I can't think of a good way to get us everything we
want:

1. unprivileged users always restricted
2. existing unprivileged containers become restricted when whitelist
is enabled
3. privileged users are able to create containers which are not restricted
4. privileged users are able to create containers which *are* restricted
