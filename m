From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [virtio-dev] Re: [PATCH v3] Add virtio-input driver.
Date: Tue, 24 Mar 2015 15:14:53 +0100
Message-ID: <20150324143839-mutt-send-email-mst@redhat.com>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
 <20150324105829-mutt-send-email-mst@redhat.com>
 <1427197581.18768.16.camel@nilsson.home.kraxel.org>
 <20150324135908-mutt-send-email-mst@redhat.com>
 <1427204244.18768.21.camel@nilsson.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427204244.18768.21.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 02:37:24PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > > input layer checks it and ignores events not supported (according to the
> > > support bitmaps).
> > 
> > Right but support bitmaps come from host too, no?
> 
> Yes, but the driver will not set invalid bits (bitcount argument for the
> virtinput_cfg_bits() function is the number of valid bits of the
> specific bitmap).
> 
> cheers,
>   Gerd
> 
> 
> 

Question: does linux ever get such events from userspace
as opposed to sending them to userspace?

-- 
MST
