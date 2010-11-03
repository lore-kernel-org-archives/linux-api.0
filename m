From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Wed, 3 Nov 2010 11:16:34 -0700
Message-ID: <20101103181634.GF7441@kroah.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com> <20101103023422.GB5782@kroah.com> <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, adurbin@google.com, akpm@linux-foundation.org, chavey@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 02, 2010 at 08:37:42PM -0700, Mike Waychison wrote:
> On Tue, Nov 2, 2010 at 7:34 PM, Greg KH <greg@kroah.com> wrote:
> > On Tue, Nov 02, 2010 at 06:29:25PM -0700, Mike Waychison wrote:
> >> This patchset applies to v2.6.36.
> >>
> >> The following series implements support for 'netoops', a simple driver that
> >> will deliver kmsg logs together with machine specifics over the network.
> >
> > We already have the ability to send oopses over the network today,
> > through the network consolst stuff. What does this patch set do that is
> > different from our existing stuff that warrants such a big change?
> >
> 
> Hi Greg,
> 
> I am a little familiar with the netconsole suppport.  I should have
> added a comparison to the cover email :(
> 
> We never adopted netconsole for a couple different reasons.  The
> reasons have slightly changed over the years, but even today we find
> that it isn't a substitute for netoops' semantics.

Ah, but it sounds like it would be better to fix up netoops to handle
your needs.

> With the number of machines we have, streaming large amounts of
> consoles within the data center can really add up.  This gets worse
> when you take into account how reliant we are on kernel logging like
> OOM conditions (which are very regular and very verbose).  Events in
> the data center (such as application growth) tend to be temporally
> correlated, which causes large bursts of logging when we are OOM.  We
> aren't so interested in this kernel verbosity from a global collection
> standpoint though, and haven't been keen on the amount of extra
> un-regulated UDP traffic it would generate.  We are however interested
> in kernel oopses though (which occur far less often).

Understood, I'm sure that a change to allow this to the existing netoops
code would be appreciated by many.

> In terms of the data received, we've really benefited by having
> structured data in the payload.

I bet the whole world would benefit by having the oops messages in a
more "structured" manner.  We have done changes in the past to provide
this type of thing in a "more parsable" manner, to help stuff like
kerneloops.org.  I'm sure that adding this type of information to the
main oops core/messages would be a good overall goal, instead of only
having it available to only this one option/user, right?

> Another area where the two approaches have differed has been in
> handling of network reliability.  Historically (though less and less
> now), we found that we had to transmit data several times.  We also
> used to explicitly space out packets with delays to handle switch chip
> buffer overruns.  Both of these functions I presume could be added to
> netconsole without too much of a problem.

Yes, I agree netconsole would be good to get this type of change.

> Lastly, this patchset also introduces a 'one-shot' mode, which has
> saved our bacon several times in the past as well.  It's not totally
> uncommon for the kernel's crash path to be buggy, in turn causing the
> kernel to emit Oopses until the cows come home (or rather, until the
> hardware watchdogs trip).  One-shot keeps us from emitting too much
> garbage on the network when this happens.

I thought we had something like "only show the first oops" somewhere in
the kernel, perhaps I'm just imagining things...

If I am, adding this for all oopses would also be good.

> I hope the above comparison of semantics outlines the motivations we
> have for not using netconsole and favoring an approach like that used
> in netoops :)

I think you have just convinced me that you should add this type of
functionality for all oops messages even more, instead of only doing it
for your one type of oops transport :)

As for the user/kernel interface, perhaps exporting the data in a text
format that is "tagged" would be best?  Then the whole world can parse
it easily.

thanks,

greg k-h
