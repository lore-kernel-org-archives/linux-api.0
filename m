From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Thu, 4 Nov 2010 14:15:44 +0800
Message-ID: <20101104061544.GD5210@cr0.nay.redhat.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
 <20101103023422.GB5782@kroah.com>
 <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
 <20101103181634.GF7441@kroah.com>
 <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com>
 <4CD1C612.5080902@google.com>
 <1288817685.26428.1129.camel@calx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1288817685.26428.1129.camel@calx>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 03, 2010 at 03:54:45PM -0500, Matt Mackall wrote:
>On Wed, 2010-11-03 at 13:29 -0700, Mike Waychison wrote:
>> Mike Waychison wrote:
>> > FWIW, another semantic difference between netconsole and netoops (that
>> > I had missed in the last email) is filtering: we really do want to get
>> > the whole log when a crash happens, debug messages and all.
>> > Netconsole is subject to console filtering (which we _do_ want as
>> > debug messages going out the uart slows the whole world down).
>> > 
>> > netconsole and netoops _do_ have bits in common, for instance the
>> > handling of NETDEV events and source+target configuration.  I'd rather
>> > those bits become common between the two than figure out how to jam
>> > the semantics we need into netconsole.
>> 
>> Hi Matt,
>> 
>> I've been reading through the netconsole driver in response to Greg's 
>> comments on this thread, and it is definitely more robust in terms of 
>> configuration and handling of network device events than the netoops 
>> driver I proposed.
>
>I've been following the discussion to see if it went anywhere
>interesting..
>
>> What are your thoughts on extending netconsole with the same sort of 
>> semantics that are in the netoops patchset?
>
>My first thought is that it's a bit unfortunate that some of the the
>netconsole configgy bits weren't implemented in a generic way that would
>be applicable to other netpoll clients. Some people have never gotten it
>into their heads that netconsole isn't the only client.
>

Really? What are other clients? I remember netdump *was* one client,
but it is not in upstream and is deprecated, so netconsole is the only
client in tree, AFAIK.


>> I'd still like to have blit-dmesg-to-the-network-on-oops semantics, 
>> which seems doable by having a per-target flag for streaming of console 
>> messages (enabled by default) and a flag to emit a structured full dmesg 
>> dump (disabled by default).
>
>I'd actually like to see you go forward with netoops. It's clear to me
>that it's a different beast and complexifying netconsole with a bunch of
>weird new options doesn't really sit well. If that means abstracting
>some of the sysfs crap from netconsole, great. 
>

That would be good.


>That said, I don't think netoops is an ideal name, given how closely
>bound oops _events_ are with their textual output. Presumably it covers
>events other than oopsen like panics too. 
>
>Regarding rolling oopses: lots of machines regularly survive oopses, so 
>I think you ought to consider rate-limiting them (to a configurable rate
>with a very low default) rather than suppressing all but the first.
>

We have WARN_ONCE(), maybe we can make one oops_once()...
At least, that is not hard.
