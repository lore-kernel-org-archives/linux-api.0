From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] virtio_balloon: coding style fixes
Date: Thu, 15 Jan 2015 21:16:05 +0100
Message-ID: <20150115201605.GA24130@dhcp22.suse.cz>
References: <1421321941-21111-1-git-send-email-mst@redhat.com>
 <20150115130642.GC7008@dhcp22.suse.cz>
 <20150115134412.GA23874@redhat.com>
 <20150115141308.GH7000@dhcp22.suse.cz>
 <20150115185018.GA31068@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115185018.GA31068-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu 15-01-15 20:50:18, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2015 at 03:13:08PM +0100, Michal Hocko wrote:
> > On Thu 15-01-15 15:44:12, Michael S. Tsirkin wrote:
[...]
> > > Maybe send patch dropping include/uapi/ from there,
> > > should help drive the volumes down?
> > 
> > This would be an overkill IMO. It would be much more preferable if
> > people actually think about who from the suggested list (either from
> > MAINTAINERS or ./scripts/get_maintainer.pl) should be really added.
> > 
> > [...]
> 
> Yea, think about it, then what?  I've no idea what is linux-abi for, and
> what people subscribed there are interested in. How should I?

https://www.kernel.org/doc/man-pages/linux-api-ml.html

And by no means, I didn't intend to put critique just to you or only
this particular patch. I just grown frustrated because there are so many
patches which are no longer API/ABI related flying here. This was just
an example.

Hi volume of unrelated emails will turn this into another lkml, I am
afraid.
-- 
Michal Hocko
SUSE Labs
