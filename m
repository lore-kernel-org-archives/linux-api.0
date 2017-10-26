From: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] Add /proc/PID/{smaps, numa_maps} support for DAX
Date: Thu, 26 Oct 2017 07:51:20 -0700
Message-ID: <83cb9f0e-cd37-5355-9b03-aef9e62e7200@intel.com>
References: <1508891255-15427-1-git-send-email-fan.du@intel.com>
 <1508891255-15427-2-git-send-email-fan.du@intel.com>
 <20171025093045.s3rpcuovld22bhqu@dhcp22.suse.cz>
 <1f673f36-74b0-3321-32a4-a8031d5f268a@intel.com>
 <20171026141604.susqkaniglc5aqw2@dhcp22.suse.cz>
 <97774073-1df0-328a-68f8-f59667bce168@intel.com>
 <20171026143133.7rm5wcgikjgmx4sc@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171026143133.7rm5wcgikjgmx4sc-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Fan Du <fan.du-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/26/2017 07:31 AM, Michal Hocko wrote:
> On Thu 26-10-17 07:24:14, Dave Hansen wrote:
>> Actually, I don't remember whether it was tooling or just confused
>> humans.  I *think* Dan was trying to write test cases for huge page DAX
>> support and couldn't figure out whether or not it was using large pages.
> 
> That sounds like a very weak justification to adding new stuff to smaps
> to be honest.

Yep, agreed.  It can't go in _just_ for DAX, and Fan and the other DAX
folks need to elaborate on their needs here.

Do you have any better ideas?  If we did this, we could probably make an
argument that the AnonHuge fields could go away some day.  They haven't
always been there.

The only other alternative I can think of are truly DAX-specific
interfaces, which also seem like a really bad idea.

> Not only that. There have been reports that reading smaps is too
> expensive. Curiously enough the overhead doesn't come up from
> the data collection but rather copying to the userspace. So we should be
> careful to not print data that is not of general use.

Yikes!  I just did a quick:

	while true; do cat /proc/*/smaps | wc ; done

and the copying out to userspace is ~1/15th the overhead of
smaps_account().  Something sounds screwy if you're seeing the overhead
at copying to userspace.

What else can we do than continue to bloat smaps?  Could we do a file
per VMA?

	/proc/$pid/smap/0x123000-0x456000
