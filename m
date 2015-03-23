From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Mon, 23 Mar 2015 14:44:52 +0100
Message-ID: <1427118292.27137.39.camel@nilsson.home.kraxel.org>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	 <1426756391-26585-2-git-send-email-kraxel@redhat.com>
	 <20150319123940-mutt-send-email-mst@redhat.com>
	 <1426847327.32097.60.camel@nilsson.home.kraxel.org>
	 <20150321225356-mutt-send-email-mst@redhat.com>
	 <1427097238.6365.27.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-652-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <1427097238.6365.27.camel@nilsson.home.kraxel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open
 list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

  Hi,

> > At least, this needs a comment explaining what the function does,
> > and maybe wrap it in a helper like virtio_input_bitmap_copy or
> > virtio_bitmap_or.
> 
> Can do that, sure.

Well, the function where this is in already cares about the bitmap copy
only.  Can add a comment though.

> > You are doing leXXX everywhere, that's VERSION_1 dependency.
> > virtio_cread will do byteswaps differently without VERSION_1.
> > Just don't go there.
> 
> Changed that for v2, for the config space structs.  They have normal u32
> in there now.  virtio_cread() wants it this way.

I liked the __le32 in the config space structs more though, so I've
waded through the virtio_config.h header file.

To me it looks like we need separate virtio_cread() versions for
non-transitional drivers, which do __le32 -> u32 translation instead of
__virtio32 -> u32 translation, so I can have __le32 types in the config
space structs.

Or I could use vdev->config->get() directly instead of virtio_cread, but
I'll loose sparse checking that way.

Hmm.  Recommendations?  Better ideas?

cheers,
  Gerd
