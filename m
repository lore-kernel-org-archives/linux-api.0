From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Mon, 8 Jan 2018 12:36:10 -0600
Message-ID: <20180108183610.GA562@mail.hallyn.com>
References: <CAF2d9jit74_VCdD-pEFy3bJo2W1-0cDo0BOJC5beJiy8yFPCWg@mail.gmail.com>
 <alpine.LFD.2.20.1712301931360.24310@localhost>
 <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost>
 <20180108062452.GA21717@mail.hallyn.com>
 <alpine.LFD.2.20.1801082040180.12014@localhost>
 <20180108154733.GA29416@mail.hallyn.com>
 <CAF2d9jgVJpuAH+jgK0v7sQ9Pr75xy=GSnqKDdpeE7d97O0EbcQ@mail.gmail.com>
 <20180108181121.GA32302@mail.hallyn.com>
 <CAF2d9jgar8J+mQjUfF=+XdvrcS=RvtOpKysxOiZkG-rXgm0KVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jgar8J+mQjUfF=+XdvrcS=RvtOpKysxOiZkG-rXgm0KVw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <james.l.morris@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>, Mahesh Bandewar <mahesh@bandewar.net>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
> On Mon, Jan 8, 2018 at 10:11 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
> >> On Mon, Jan 8, 2018 at 7:47 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >> > Quoting James Morris (james.l.morris@oracle.com):
> >> >> On Mon, 8 Jan 2018, Serge E. Hallyn wrote:
> >> >> I meant in terms of "marking" a user ns as "controlled" type -- it's
> >> >> unnecessary jargon from an end user point of view.
> >> >
> >> > Ah, yes, that was my point in
> >> >
> >> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/01845.html
> >> > and
> >> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/02276.html
> >> >
> >> >> This may happen internally but don't make it a special case with a
> >> >> different name and don't bother users with internal concepts: simply
> >> >> implement capability whitelists with the default having equivalent
> >
> > So the challenge is to have unprivileged users be contained, while
> > allowing trusted workloads in containers created by a root user to
> > bypass the restriction.
> >
> > Now, the current proposal actually doesn't support a root user starting
> > an application that it doesn't quite trust in such a way that it *is*
> > subject to the whitelist.
> 
> Well, this is not hard since root process can spawn another process
> and loose privileges before creating user-ns to be controlled by the
> whitelist.

It would have to drop cap_sys_admin for the container to be marked as
"controlled", which may prevent the container runtime from properly starting
the container.

> You need an ability to preserve the creation of user-namespaces that
> exhibit 'the uncontrolled behavior' and only trusted/privileged (root)
> user should have it which is maintained here.
> 
> > Which is unfortunate.  But apart from using
> > ptags or a cgroup, I can't think of a good way to get us everything we
> > want:
> >
> > 1. unprivileged users always restricted
> > 2. existing unprivileged containers become restricted when whitelist
> > is enabled
> > 3. privileged users are able to create containers which are not restricted
> 
> all this is achieved by the patch-set without any changes to the
> application with the above knob.
> 
> > 4. privileged users are able to create containers which *are* restricted
> >
> With this patch-set; the root user process can fork another process
> with less privileges before creating a user-ns if the exec-ed process
> cannot be trusted. So there is a way with little modification as
> opposed to nothing available at this moment for this scenario.
