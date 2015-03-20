From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Fri, 20 Mar 2015 10:54:33 +0100
Message-ID: <1426845273.32097.39.camel@nilsson.home.kraxel.org>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	 <1426756391-26585-2-git-send-email-kraxel@redhat.com>
	 <CANq1E4TDj4pq3J_BVc=Yuzo5dVR=QcNexVUqaqwjg7Qi5_xX4Q@mail.gmail.com>
	 <20150319162704.GE30732@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-644-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20150319162704.GE30732@dtor-ws>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: David Herrmann <dh.herrmann@gmail.com>, virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, mst@redhat.com, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open
 list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

  Hi,

> > > +static ssize_t serial_show(struct device *dev,
> > > +                          struct device_attribute *attr, char *buf)
> > > +{
> > > +       struct input_dev *idev = to_input_dev(dev);
> > > +       struct virtio_input *vi = input_get_drvdata(idev);
> > > +       return sprintf(buf, "%s\n", vi->serial);
> > > +}
> > > +static DEVICE_ATTR_RO(serial);
> 
> What is serial? Serial number?

Yes.  You can (optionally) configure a serial number on the host side,
and if that is the case it'll show up here.

> > Can you set vi->idev->uniq to the virtio-bus path?
> 
> No, uniq can't be phys as phys is unique within the system while uniq is
> like serial number or UUID and should never repeat.

Ok, so I guess I should just fill uniq with serial (if present).

cheers,
  Gerd
