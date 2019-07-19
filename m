From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Date: Fri, 19 Jul 2019 10:32:13 -0500
Message-ID: <874l3ighvm.fsf@xmission.com>
References: <20190529153427.GB8959@cisco>
        <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
        <20190529222835.GD8959@cisco>
        <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
        <20190530170913.GA16722@mail.hallyn.com>
        <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
        <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
        <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
        <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
        <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
        <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca> (Richard
        Guy Briggs's message of "Wed, 17 Jul 2019 20:51:45 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, "Serge E. Hallyn" <serge@hallyn.com>, Tycho Andersen <tycho@tycho.ws>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> On 2019-07-16 19:30, Paul Moore wrote:
>> On Tue, Jul 16, 2019 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2019-07-15 17:04, Paul Moore wrote:
>> > > On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> 
>> > > > At this point I would say we are at an impasse unless we trust
>> > > > ns_capable() or we implement audit namespaces.
>> > >
>> > > I'm not sure how we can trust ns_capable(), but if you can think of a
>> > > way I would love to hear it.  I'm also not sure how namespacing audit
>> > > is helpful (see my above comments), but if you think it is please
>> > > explain.
>> >
>> > So if we are not namespacing, why do we not trust capabilities?
>> 
>> We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
>> ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
>
> Ok.  So does a process in a non-init user namespace have two (or more)
> sets of capabilities stored in creds, one in the init_user_ns, and one
> in current_user_ns?  Or does it get stripped of all its capabilities in
> init_user_ns once it has its own set in current_user_ns?  If the former,
> then we can use capable().  If the latter, we need another mechanism, as
> you have suggested might be needed.

The latter.  There is only one set of capabilities and it is in the
processes current user namespace.

Eric
