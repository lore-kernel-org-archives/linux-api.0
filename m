From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v5] Add virtio-input driver.
Date: Thu, 26 Mar 2015 13:10:40 +0100
Message-ID: <20150326130644-mutt-send-email-mst@redhat.com>
References: <1427366965-32549-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427366965-32549-1-git-send-email-kraxel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org, David Herrmann <dh.herrmann@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 26, 2015 at 11:49:25AM +0100, Gerd Hoffmann wrote:
> virtio-input is basically evdev-events-over-virtio, so this driver isn't
> much more than reading configuration from config space and forwarding
> incoming events to the linux input layer.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Still a bit worried about using input.h as host/guest
interface (can't we use some formal standard, e.g. USB HID?),
but I'll let Rusty decide that.

Otherwise mostly looks good. One nit below.

> ---

Could you pls include changelog in the future?
You are sending multiple versions per day and it's hard to keep up.

> +static unsigned int features[] = {
> +	/* none */
> +};

An empty line wouldn't hurt here about variable definition.

> +static struct virtio_device_id id_table[] = {
> +	{ VIRTIO_ID_INPUT, VIRTIO_DEV_ANY_ID },
> +	{ 0 },
> +};
