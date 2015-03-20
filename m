From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] Add virtio-input driver.
Date: Fri, 20 Mar 2015 11:36:39 +0100
Message-ID: <1426847799.32097.66.camel@nilsson.home.kraxel.org>
References: <1426756391-26585-1-git-send-email-kraxel@redhat.com>
	 <1426756391-26585-2-git-send-email-kraxel@redhat.com>
	 <CANq1E4TDj4pq3J_BVc=Yuzo5dVR=QcNexVUqaqwjg7Qi5_xX4Q@mail.gmail.com>
	 <1426844885.32097.36.camel@nilsson.home.kraxel.org>
	 <CANq1E4QLPSK6NVeEx6yihYPdF-XPpXx4rKv0deHwX+s2RzFHCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANq1E4QLPSK6NVeEx6yihYPdF-XPpXx4rKv0deHwX+s2RzFHCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  Hi,

> > There will also be pass-through support, i.e. qemu
> > opening /dev/input/event<nr> and forwarding everything to the guest.
> > How should that be handled best?  Copy all four from the host?  Even
> > though the bustype is BUS_USB?  Not sure this actually improves things
> > because the guest can match the device, or whenever this confuses apps
> > due to BUS_USB being applied to virtio devices ...
> 
> Lemme give an example: We have databases in user-space, that allow
> applications to figure out the mouse DPI values of a device. Those
> databases match on all four, bus+vid+pid+ver (sometimes even more,
> like name and dmi). If one of those is not forwarded, it will not be
> detected.

Ok, so forward as much as possible.

> I'd like to see all four forwarded from the host. I'd be fine with
> "bus" being set to VIRTUAL, but I'm not sure why that would be a good
> thing to do?

I think for the emulated devices it's fine to use VIRTUAL.

For the passthrough case suspected we could confuse apps because ->phys
points to a virtio device whereas ->type says "I'm usb".

But at least the device database probably doesn't care much about the
physical path I guess, because the mouse is the same no matter which usb
port I plug it in, correct?

cheers,
  Gerd
