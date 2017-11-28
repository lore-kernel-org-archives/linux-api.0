From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCHv2 2/2] userns: control capabilities of some user
 namespaces
Date: Tue, 28 Nov 2017 17:04:40 -0600
Message-ID: <20171128230440.GB28297@mail.hallyn.com>
References: <20171110053757.21170-1-mahesh@bandewar.net>
 <20171126064037.GB30279@mail.hallyn.com>
 <CAF2d9jhiZFiFODNXUY13F+4Pm+59+rZW=CnLPX1VUT3BAJdeeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF2d9jhiZFiFODNXUY13F+4Pm+59+rZW=CnLPX1VUT3BAJdeeA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (महेश बंडेवार) (maheshb@google.com):
...
> >> diff --git a/security/commoncap.c b/security/commoncap.c
> >> index fc46f5b85251..89103f16ac37 100644
> >> --- a/security/commoncap.c
> >> +++ b/security/commoncap.c
> >> @@ -73,6 +73,14 @@ int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
> >>  {
> >>       struct user_namespace *ns = targ_ns;
> >>
> >> +     /* If the capability is controlled and user-ns that process
> >> +      * belongs-to is 'controlled' then return EPERM and no need
> >> +      * to check the user-ns hierarchy.
> >> +      */
> >> +     if (is_user_ns_controlled(cred->user_ns) &&
> >> +         is_capability_controlled(cap))
> >> +             return -EPERM;
> >
> > I'd be curious to see the performance impact on this on a regular
> > workload (kernel build?) in a controlled ns.
> >
> Should it affect? If at all, it should be +ve since, the recursive
> user-ns hierarchy lookup is avoided with the above check if the
> capability is controlled.

Yes but I expect that to be the rare case for normal lxc installs
(which are of course what I am interested in)

>  The additional cost otherwise is this check
> per cap_capable() call.

And pipeline refetching?

Capability calls also shouldn't be all that frequent, but still I'm
left wondering...
