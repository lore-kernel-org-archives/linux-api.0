From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 0/2] capability controlled user-namespaces
Date: Tue, 9 Jan 2018 18:08:58 -0800
Message-ID: <CAF2d9jh+xMW7_5dwAPkoAuDyx=k=FNh3VfiMvDkCOBD2KF5npw@mail.gmail.com>
References: <CAF2d9jiPYvMN=_guoZHyTA5FmMgaJb5mtxroi5D9NvcNrHc5gg@mail.gmail.com>
 <alpine.LFD.2.20.1801081131190.8436@localhost> <20180108062452.GA21717@mail.hallyn.com>
 <alpine.LFD.2.20.1801082040180.12014@localhost> <20180108154733.GA29416@mail.hallyn.com>
 <CAF2d9jgVJpuAH+jgK0v7sQ9Pr75xy=GSnqKDdpeE7d97O0EbcQ@mail.gmail.com>
 <20180108181121.GA32302@mail.hallyn.com> <CAF2d9jgar8J+mQjUfF=+XdvrcS=RvtOpKysxOiZkG-rXgm0KVw@mail.gmail.com>
 <20180108183610.GA562@mail.hallyn.com> <CAF2d9jjws=jEbybHs18J_xkduAWB+bh6BA_CkD5oYRWz7PwjZA@mail.gmail.com>
 <20180109222859.GA25956@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109222859.GA25956-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 9, 2018 at 2:28 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=
=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
):
>> On Mon, Jan 8, 2018 at 10:36 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> > Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=
=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@google.=
com):
>> >> On Mon, Jan 8, 2018 at 10:11 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> w=
rote:
>> >> > Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=
=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb@goog=
le.com):
>> >> >> On Mon, Jan 8, 2018 at 7:47 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> >> >> > Quoting James Morris (james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org):
>> >> >> >> On Mon, 8 Jan 2018, Serge E. Hallyn wrote:
>> >> >> >> I meant in terms of "marking" a user ns as "controlled" type --=
 it's
>> >> >> >> unnecessary jargon from an end user point of view.
>> >> >> >
>> >> >> > Ah, yes, that was my point in
>> >> >> >
>> >> >> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/01845.html
>> >> >> > and
>> >> >> > http://lkml.iu.edu/hypermail/linux/kernel/1711.1/02276.html
>> >> >> >
>> >> >> >> This may happen internally but don't make it a special case wit=
h a
>> >> >> >> different name and don't bother users with internal concepts: s=
imply
>> >> >> >> implement capability whitelists with the default having equival=
ent
>> >> >
>> >> > So the challenge is to have unprivileged users be contained, while
>> >> > allowing trusted workloads in containers created by a root user to
>> >> > bypass the restriction.
>> >> >
>> >> > Now, the current proposal actually doesn't support a root user star=
ting
>> >> > an application that it doesn't quite trust in such a way that it *i=
s*
>> >> > subject to the whitelist.
>> >>
>> >> Well, this is not hard since root process can spawn another process
>> >> and loose privileges before creating user-ns to be controlled by the
>> >> whitelist.
>> >
>> > It would have to drop cap_sys_admin for the container to be marked as
>> > "controlled", which may prevent the container runtime from properly st=
arting
>> > the container.
>> >
>> Yes, but that's a conflict of trusted operations (that requires
>> SYS_ADMIN) and untrusted processes it may spawn.
>
> Not sure I understand what you're saying, but
>
> I guess that in any case the task which is doing unshare(CLONE_NEWNS)
> can drop cap_sys_admin first.  Though that is harder if using clone,
> and it is awkward because it's not the container manager, but the user,
> who will judge whether the container workload should be restricted.
> So the container driver will add a flag like "run-controlled", and
> the driver will convert that to dropping a capability; which again
> is weird.  It would seem nicer to introduce a userns flag, 'caps-controll=
ed'
> For an unprivileged userns, it is always set to 1, and root cannot
> change it.  For a root-created userns, it stays 0, but root can set it
> to 1 (using /proc file?).  In this way a either container runtime or just=
 an
> admin script can say "no wait I want this container to still be controlle=
d".
>
> Or we could instead add a second sysctl to decide whether all or only
> 'controlled' user namespaces should be controlled.  That's not pretty tho=
ugh.
>
Yes, I like your idea of a flag to clone() which will force the
user-ns to be controlled. This will have effect only on the root user
and any other user specifying is actually a NOP since those will be
controlled with or without that flag. But this is still an enhancement
to the current patch-set and I don't mind doing it as a follow-up
after this patch-series.

At this moment James has asked for Eric's input, which I believe
hasn't been recorded.
