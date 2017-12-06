From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 2/2] userns: control capabilities of some user
 namespaces
Date: Wed, 6 Dec 2017 17:59:42 -0600
Message-ID: <20171206235942.GA10689@mail.hallyn.com>
References: <20171110053757.21170-1-mahesh@bandewar.net>
 <20171126064037.GB30279@mail.hallyn.com>
 <CAF2d9jhiZFiFODNXUY13F+4Pm+59+rZW=CnLPX1VUT3BAJdeeA@mail.gmail.com>
 <20171128230440.GB28297@mail.hallyn.com>
 <CAF2d9jhCDasnf2tbaGA04MV5ygZ9o1FaVRCEU2TkHjZR7d1ifw@mail.gmail.com>
 <20171129175712.GB14545@mail.hallyn.com>
 <CAF2d9jgsSZ6mCE8QwxPpoO7GoO4zeQzNfZuZwM9Gqqdi8uP4fw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jgsSZ6mCE8QwxPpoO7GoO4zeQzNfZuZwM9Gqqdi8uP4fw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> On Wed, Nov 29, 2017 at 9:57 AM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> >> On Tue, Nov 28, 2017 at 3:04 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> >> > Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org):
> >> > ...
> >> >> >> diff --git a/security/commoncap.c b/security/commoncap.c
> >> >> >> index fc46f5b85251..89103f16ac37 100644
> >> >> >> --- a/security/commoncap.c
> >> >> >> +++ b/security/commoncap.c
> >> >> >> @@ -73,6 +73,14 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
> >> >> >>  {
> >> >> >>       struct user_namespace *ns = targ_ns;
> >> >> >>
> >> >> >> +     /* If the capability is controlled and user-ns that process
> >> >> >> +      * belongs-to is 'controlled' then return EPERM and no need
> >> >> >> +      * to check the user-ns hierarchy.
> >> >> >> +      */
> >> >> >> +     if (is_user_ns_controlled(cred->user_ns) &&
> >> >> >> +         is_capability_controlled(cap))
> >> >> >> +             return -EPERM;
> >> >> >
> >> >> > I'd be curious to see the performance impact on this on a regular
> >> >> > workload (kernel build?) in a controlled ns.
> >> >> >
> >> >> Should it affect? If at all, it should be +ve since, the recursive
> >> >> user-ns hierarchy lookup is avoided with the above check if the
> >> >> capability is controlled.
> >> >
> >> > Yes but I expect that to be the rare case for normal lxc installs
> >> > (which are of course what I am interested in)
> >> >
> >> >>  The additional cost otherwise is this check
> >> >> per cap_capable() call.
> >> >
> >> > And pipeline refetching?
> >> >
> >> > Capability calls also shouldn't be all that frequent, but still I'm
> >> > left wondering...
> >>
> >> Correct, and capability checks are part of the control-path and not
> >> the data-path so shouldn't matter but I guess it doesn't hurt to
> >> find-out the number. Do you have any workload in mind, that we can use
> >> for this test/benchmark?
> >
> > I suppose if you did both (a) a kernel build and (b) a webserve
> > like https://github.com/m3ng9i/ran , being hit for a minute by a
> > heavy load of requests, those two together would be re-assuring.
> >
> Well, I did (a) and (b). Here are the results.
> 
> (a0) I used the ubuntu-artful (17.10) vm instance with standard kernel
> to compile the kernel
> 
> mahesh@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s clean
> mahesh@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s
> real 6m47.525s
> user 22m37.424s
> sys 2m44.745s
> 
> (b0) Now in an user-namespce create by an user that does not have
> SYS_ADMIN (just for apples-to-apples comparison)
> mahesh@mahesh-vm0-artful:~$ sysctl -q kernel.controlled_userns_caps_whitelist
> sysctl: cannot stat /proc/sys/kernel/controlled_userns_caps_whitelist:
> No such file or directory
> mahesh@mahesh-vm0-artful:~$ id
> uid=1000(mahesh) gid=1000(mahesh)
> groups=1000(mahesh),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),118(lpadmin),128(sambashare)
> mahesh@mahesh-vm0-artful:~/Work/Linux$ unshare -Uf -- bash
> nobody@mahesh-vm0-artful:~/Work/Linux$ id
> uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)
> nobody@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s clean
> nobody@mahesh-vm0-artful:~/Work/Linux$ time make -j4 -s
> real 9m10.115s

Got some serious noise in this run?

But the numbers look good - thanks!
