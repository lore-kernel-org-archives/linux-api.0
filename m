From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/12] netoops support
Date: Wed, 03 Nov 2010 13:29:06 -0700
Message-ID: <4CD1C612.5080902@google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>	<20101103023422.GB5782@kroah.com>	<AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>	<20101103181634.GF7441@kroah.com> <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mike Waychison wrote:
> FWIW, another semantic difference between netconsole and netoops (that
> I had missed in the last email) is filtering: we really do want to get
> the whole log when a crash happens, debug messages and all.
> Netconsole is subject to console filtering (which we _do_ want as
> debug messages going out the uart slows the whole world down).
> 
> netconsole and netoops _do_ have bits in common, for instance the
> handling of NETDEV events and source+target configuration.  I'd rather
> those bits become common between the two than figure out how to jam
> the semantics we need into netconsole.

Hi Matt,

I've been reading through the netconsole driver in response to Greg's 
comments on this thread, and it is definitely more robust in terms of 
configuration and handling of network device events than the netoops 
driver I proposed.

What are your thoughts on extending netconsole with the same sort of 
semantics that are in the netoops patchset?

I'd still like to have blit-dmesg-to-the-network-on-oops semantics, 
which seems doable by having a per-target flag for streaming of console 
messages (enabled by default) and a flag to emit a structured full dmesg 
dump (disabled by default).

I'd be happy to change this patchset to modify the netconsole driver if 
you agree.

Thanks,

Mike Waychison
