From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [virtio-dev] Re: [PATCH v3] Add virtio-input driver.
Date: Tue, 24 Mar 2015 14:37:24 +0100
Message-ID: <1427204244.18768.21.camel@nilsson.home.kraxel.org>
References: <1427182321-19451-1-git-send-email-kraxel@redhat.com>
	 <20150324105829-mutt-send-email-mst@redhat.com>
	 <1427197581.18768.16.camel@nilsson.home.kraxel.org>
	 <20150324135908-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150324135908-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  Hi,

> > input layer checks it and ignores events not supported (according to the
> > support bitmaps).
> 
> Right but support bitmaps come from host too, no?

Yes, but the driver will not set invalid bits (bitcount argument for the
virtinput_cfg_bits() function is the number of valid bits of the
specific bitmap).

cheers,
  Gerd
