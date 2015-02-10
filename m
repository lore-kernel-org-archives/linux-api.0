From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Wed, 11 Feb 2015 06:30:27 +0800
Message-ID: <20150210223027.GA27269@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
 <20150206125916.GB26247@kroah.com>
 <20150206154157.GD1143@localhost.localdomain>
 <20150207040743.GB29944@kroah.com>
 <20150210142719.GA1437@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150210142719.GA1437-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "James E.J. Bottomley (JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org)" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 10, 2015 at 02:27:20PM +0000, Bryn M. Reeves wrote:
> On Sat, Feb 07, 2015 at 12:07:43PM +0800, Greg KH wrote:
> 
> $ cat /sys/fs/selinux/avc/cache_stats 
> lookups hits misses allocations reclaims frees
> 18938916 18921707 17209 17209 17328 22215
> 38164283 38146514 17769 17769 16800 19049
> 18078108 18056991 21117 21117 21344 19305
> 15168204 15150079 18125 18125 17776 13149
> 0 0 0 0 0 0
> 0 0 0 0 0 0
> 0 0 0 0 0 0
> 0 0 0 0 0 0
> 
> $ cat /sys/fs/selinux/avc/hash_stats
> entries: 506
> buckets used: 290/512
> longest chain: 5

Ugh, those look like they should be debugfs interfaces.  Thanks, I'll
add them to my list of things to nag people about...

greg k-h
