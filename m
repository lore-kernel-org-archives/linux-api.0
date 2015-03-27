From: Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>
Subject: Re: [PATCH v5] Add virtio-input driver.
Date: Fri, 27 Mar 2015 13:26:29 +1030
Message-ID: <87lhijqhb6.fsf@rustcorp.com.au>
References: <1427366965-32549-1-git-send-email-kraxel@redhat.com> <20150326130644-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150326130644-mutt-send-email-mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> On Thu, Mar 26, 2015 at 11:49:25AM +0100, Gerd Hoffmann wrote:
>> virtio-input is basically evdev-events-over-virtio, so this driver isn't
>> much more than reading configuration from config space and forwarding
>> incoming events to the linux input layer.
>> 
>> Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> Still a bit worried about using input.h as host/guest
> interface (can't we use some formal standard, e.g. USB HID?),
> but I'll let Rusty decide that.

I like the simplicity, and this API is pretty well proven.

Since this is under drivers/virtio rather than drivers/input, I've
applied it to my tree.

I have a dream where Denys Vlasenko adds this and the virtio gl device
to lguest, and we have X running under lguest :)

Applied!
Rusty.
