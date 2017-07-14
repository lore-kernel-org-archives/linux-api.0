From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/9] mm, page_alloc: rip out ZONELIST_ORDER_ZONE
Date: Fri, 14 Jul 2017 14:01:11 +0100
Message-ID: <20170714130111.vwnddyuypd2lcyu4@suse.de>
References: <20170714080006.7250-1-mhocko@kernel.org>
 <20170714080006.7250-2-mhocko@kernel.org>
 <20170714093650.l67vbem2g4typkta@suse.de>
 <20170714104756.GD2618@dhcp22.suse.cz>
 <20170714111633.gk5rpu2d5ghkbrrd@suse.de>
 <20170714113840.GI2618@dhcp22.suse.cz>
 <20170714125616.clbp4ezgtoon6cmk@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170714125616.clbp4ezgtoon6cmk-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Jul 14, 2017 at 01:56:16PM +0100, Mel Gorman wrote:
> >  	if (!write) {
> > -		int len = sizeof("Default");
> > -		if (copy_to_user(buffer, "Default", len))
> > +		int len = sizeof("Node");
> > +		if (copy_to_user(buffer, "Node", len))
> >  			return -EFAULT;
> 
> Ok for the name. But what's with using sizeof?

Bah, sizeof static compile-time string versus char *. Never mind.

-- 
Mel Gorman
SUSE Labs
