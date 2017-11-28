From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 2/2] userns: control capabilities of some user namespaces
Date: Tue, 28 Nov 2017 15:50:48 -0800
Message-ID: <CAF2d9jhCDasnf2tbaGA04MV5ygZ9o1FaVRCEU2TkHjZR7d1ifw@mail.gmail.com>
References: <20171110053757.21170-1-mahesh@bandewar.net> <20171126064037.GB30279@mail.hallyn.com>
 <CAF2d9jhiZFiFODNXUY13F+4Pm+59+rZW=CnLPX1VUT3BAJdeeA@mail.gmail.com> <20171128230440.GB28297@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171128230440.GB28297-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 28, 2017 at 3:04 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=87=E0=A4=B6 =E0=A4=AC=
=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=B0) (maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org=
):
> ...
>> >> diff --git a/security/commoncap.c b/security/commoncap.c
>> >> index fc46f5b85251..89103f16ac37 100644
>> >> --- a/security/commoncap.c
>> >> +++ b/security/commoncap.c
>> >> @@ -73,6 +73,14 @@ int cap_capable(const struct cred *cred, struct us=
er_namespace *targ_ns,
>> >>  {
>> >>       struct user_namespace *ns =3D targ_ns;
>> >>
>> >> +     /* If the capability is controlled and user-ns that process
>> >> +      * belongs-to is 'controlled' then return EPERM and no need
>> >> +      * to check the user-ns hierarchy.
>> >> +      */
>> >> +     if (is_user_ns_controlled(cred->user_ns) &&
>> >> +         is_capability_controlled(cap))
>> >> +             return -EPERM;
>> >
>> > I'd be curious to see the performance impact on this on a regular
>> > workload (kernel build?) in a controlled ns.
>> >
>> Should it affect? If at all, it should be +ve since, the recursive
>> user-ns hierarchy lookup is avoided with the above check if the
>> capability is controlled.
>
> Yes but I expect that to be the rare case for normal lxc installs
> (which are of course what I am interested in)
>
>>  The additional cost otherwise is this check
>> per cap_capable() call.
>
> And pipeline refetching?
>
> Capability calls also shouldn't be all that frequent, but still I'm
> left wondering...

Correct, and capability checks are part of the control-path and not
the data-path so shouldn't matter but I guess it doesn't hurt to
find-out the number. Do you have any workload in mind, that we can use
for this test/benchmark?
