From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] virtio_balloon: coding style fixes
Date: Thu, 15 Jan 2015 15:13:08 +0100
Message-ID: <20150115141308.GH7000@dhcp22.suse.cz>
References: <1421321941-21111-1-git-send-email-mst@redhat.com>
 <20150115130642.GC7008@dhcp22.suse.cz>
 <20150115134412.GA23874@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115134412.GA23874-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 15-01-15 15:44:12, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2015 at 02:06:42PM +0100, Michal Hocko wrote:
> > On Thu 15-01-15 13:39:06, Michael S. Tsirkin wrote:
> > > Most of our code has
> > > struct foo {
> > > }
> > > 
> > > Fix two instances where balloon is inconsistent.
> > 
> > I hate to complain but is it really necessary to post such patches to
> > linux-api?
> 
> Well it's human to err, so it seems wise to copy parties
> interested in the ABI/API whenever we are changing files under include/uapi.
> Whitespace changes should mostly be safe, but it's not unknown
> e.g. to include unrelated changes in the same commit by mistake.
> 
> > I thought the list was primarily for API related discussions.
> 
> Basically this line in MAINTAINERS
> 
> ABI/API
> L:      linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> F:      Documentation/ABI/
> F:      include/linux/syscalls.h
> F:      include/uapi/
> F:      kernel/sys_ni.c
> 
> normally means "send all patches affecting files under include/uapi/ to
> this list", does it not?

Well, this should always be taken as a hint not a hard rule. So if there
is a change which is adding/removing or changing signature then sure but
not everything falls into that category.
 
> Wasn't this the intent?
> 
> > This is not the only mail sent here which doesn't fall into that
> > category IMO. It is far from low volume list for quite some time.
> > 
> > Please let's get back low volume and API only discussion!
> 
> Maybe send patch dropping include/uapi/ from there,
> should help drive the volumes down?

This would be an overkill IMO. It would be much more preferable if
people actually think about who from the suggested list (either from
MAINTAINERS or ./scripts/get_maintainer.pl) should be really added.

[...]
-- 
Michal Hocko
SUSE Labs
