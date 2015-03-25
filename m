From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v3] Add virtio-input driver.
Date: Wed, 25 Mar 2015 06:36:11 +0100
Message-ID: <20150325063245-mutt-send-email-mst@redhat.com>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
 <20150324105829-mutt-send-email-mst@redhat.com>
 <20150324162337.GB34117@dtor-ws>
 <20150324180532-mutt-send-email-mst@redhat.com>
 <20150324172805.GA16445@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150324172805.GA16445@dtor-ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 24, 2015 at 10:28:05AM -0700, Dmitry Torokhov wrote:
> > > > > +	err = input_register_device(vi->idev);
> > > > > +	if (err)
> > > > > +		goto err_input_register;
> > > > > +
> > > > > +	return 0;
> > > > > +
> > > > > +err_input_register:
> > > > 
> > > > > +	input_free_device(vi->idev);
> > > > 
> > > > At this point you can already get interrupts
> > > > since you called virtio_device_ready, and
> > > > getting events from a freed device likely won't
> > > > DTRT.
> > > 
> > > Right. I guess you want to mark the virtio device ready only after
> > > registering input device.
> > 
> > No that's broken since you can get events after this
> > point, and you won't be able to forward them.
> 
> Who cares?

virtio cares: guest will crash if you attempt to
kick virtqueue before device ready call.

> What makes these events needed compared to ones sent 1 ms
> earlier before we had input device registered?
> 
> But I guess if you can call virtio_device_ready/virtio_device_broken
> several times then the best option is putting them into input_dev->open
> and input_dev->close callbacks.
> 
> Thanks.
> -- 
> Dmitry
