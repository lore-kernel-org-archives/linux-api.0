From: Vojtech Pavlik <vojtech@suse.com>
Subject: Re: [PATCH v4] Add virtio-input driver.
Date: Wed, 25 Mar 2015 06:36:13 +0100
Message-ID: <20150325053613.GA4572@suse.com>
References: <1427198927-1745-1-git-send-email-kraxel@redhat.com>
 <877fu5iwxk.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877fu5iwxk.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Gerd Hoffmann <kraxel@redhat.com>, virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, mst@redhat.com, David Herrmann <dh.herrmann@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Mar 25, 2015 at 01:51:43PM +1030, Rusty Russell wrote:

> Gerd Hoffmann <kraxel@redhat.com> writes:
> > virtio-input is basically evdev-events-over-virtio, so this driver isn't
> > much more than reading configuration from config space and forwarding
> > incoming events to the linux input layer.
> >
> > Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> Is the input layer sane?  I've never dealt with it, so I don't know.

I'm rather biased having designed it, but I'd say it's reasonable. It
certainly has limitations and design mistakes, but none are too bad.
One testimony to that Android has based its own Input API around it.

> What's it used for?

For all human input devices, like keyboards, mice, touchscreens, etc. 

> Imagine a future virtio standard which incorporates this.  And a Windows
> or FreeBSD implementation of the device and or driver.  How ugly would
> they be?

A windows translation layer is fairly easy, people porting software from
Windows to Linux told me numerous times that adapting isn't hard. I also
believe that at least one of the BSD's has a compatible implementation
these days based on the fact that I was asked to allow copying the
headers in the past.

-- 
Vojtech Pavlik
Director SUSE Labs
