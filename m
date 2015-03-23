From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Mon, 23 Mar 2015 17:17:25 +0100
Message-ID: <20150323171725.5c459dec.cornelia.huck@de.ibm.com>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	<1426756391-26585-2-git-send-email-kraxel@redhat.com>
	<20150319123940-mutt-send-email-mst@redhat.com>
	<1426847327.32097.60.camel@nilsson.home.kraxel.org>
	<20150321225356-mutt-send-email-mst@redhat.com>
	<1427097238.6365.27.camel@nilsson.home.kraxel.org>
	<1427118292.27137.39.camel@nilsson.home.kraxel.org>
	<20150323144803-mutt-send-email-mst@redhat.com>
	<1427120855.27137.55.camel@nilsson.home.kraxel.org>
	<20150323155106-mutt-send-email-mst@redhat.com>
	<1427123129.27137.62.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427123129.27137.62.camel-3OfP5uLMi4C46o+2HkPkLj4oCIwMql/M@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 23 Mar 2015 16:05:29 +0100
Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mo, 2015-03-23 at 15:54 +0100, Michael S. Tsirkin wrote:
> > On Mon, Mar 23, 2015 at 03:27:35PM +0100, Gerd Hoffmann wrote:
> > >   Hi,
> > > 
> > > > > > > You are doing leXXX everywhere, that's VERSION_1 dependency.
> > > > > > > virtio_cread will do byteswaps differently without VERSION_1.
> > > > > > > Just don't go there.
> > > 
> > > > So to clarify, you dislike using __virtio32 in virtio input header?
> > > 
> > > Well, as I understand things __virtio32 implies byteorder depends on
> > > whenever we are using VERSION_1 or not.  And non-transitional drivers
> > > should not need it as everything is by definition little endian.
> > > 
> > > So, yes, your suggestion to just require VERSION_1 in the driver implies
> > > in my eyes that there should be no reason to use __virtio32 instead of
> > > __le32.
> > > 
> > > Or do I miss something here?
> > > 
> > > cheers,
> > >   Gerd
> > > 
> > 
> > You are right but then if you do require VERSION_1 then
> > __virtio32 becomes identical to __le32.
> 
> Except that sparse doesn't know that and throws errors when I mix the
> two.
> 
> > There's some runtime overhead as we check on each access,
> > but it shouldn't matter here, right?
> 
> Correct, config space is used at initialization time only.
> 
> > I guess we could add virtio_cread_le - is this what
> > you'd like?
> 
> I just want something that makes both you and sparse happy.  I don't
> care much whenever that is adding virtio_cread_le() or using __virtio32
> even though it'll effectively is __le32 due to VERSION_1 being required.

I think it is clearer if you use __virtio32: The fact that virtio-input
is VERSION_1 only is not apparent from looking at the config space
definition, and explicitly forcing le accesses makes it look similar to
the oddballs like virtio-balloon. Just my two cents.
