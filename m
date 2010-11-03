From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Tue, 2 Nov 2010 20:37:42 -0700
Message-ID: <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com> <20101103023422.GB5782@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101103023422.GB5782-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 2, 2010 at 7:34 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Nov 02, 2010 at 06:29:25PM -0700, Mike Waychison wrote:
>> This patchset applies to v2.6.36.
>>
>> The following series implements support for 'netoops', a simple driver that
>> will deliver kmsg logs together with machine specifics over the network.
>
> We already have the ability to send oopses over the network today,
> through the network consolst stuff. What does this patch set do that is
> different from our existing stuff that warrants such a big change?
>

Hi Greg,

I am a little familiar with the netconsole suppport.  I should have
added a comparison to the cover email :(

We never adopted netconsole for a couple different reasons.  The
reasons have slightly changed over the years, but even today we find
that it isn't a substitute for netoops' semantics.

With the number of machines we have, streaming large amounts of
consoles within the data center can really add up.  This gets worse
when you take into account how reliant we are on kernel logging like
OOM conditions (which are very regular and very verbose).  Events in
the data center (such as application growth) tend to be temporally
correlated, which causes large bursts of logging when we are OOM.  We
aren't so interested in this kernel verbosity from a global collection
standpoint though, and haven't been keen on the amount of extra
un-regulated UDP traffic it would generate.  We are however interested
in kernel oopses though (which occur far less often).

In terms of the data received, we've really benefited by having
structured data in the payload.  We've been collecting kernel oopses
since sometime in 2006 and have a _vast_ collection of crashes that we
have indexed by just about anything you could ever want (registers,
full dmesg text, backtraces, motherboards, CPU types, kernel versions,
bios versions, etc).  This has allowed us to quickly find 'big bugs'
vs 'rare bugs' (similar to kerneloops.org) and allow for automated
labeling of oopses/panics.  This sort of structured data is either not
present in the dmesg logs or it is, but is extremely difficult to
parse (especially across kernel versions).  Information like firmware
version information is also difficult to associate with crashes with
post-processing due to gaps in global sampling and the churn that
occurs in the lab where versions change quickly.

Another area where the two approaches have differed has been in
handling of network reliability.  Historically (though less and less
now), we found that we had to transmit data several times.  We also
used to explicitly space out packets with delays to handle switch chip
buffer overruns.  Both of these functions I presume could be added to
netconsole without too much of a problem.

Lastly, this patchset also introduces a 'one-shot' mode, which has
saved our bacon several times in the past as well.  It's not totally
uncommon for the kernel's crash path to be buggy, in turn causing the
kernel to emit Oopses until the cows come home (or rather, until the
hardware watchdogs trip).  One-shot keeps us from emitting too much
garbage on the network when this happens.


I hope the above comparison of semantics outlines the motivations we
have for not using netconsole and favoring an approach like that used
in netoops :)

Mike Waychison
