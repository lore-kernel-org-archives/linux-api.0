From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v4] Add virtio-input driver.
Date: Wed, 25 Mar 2015 13:51:43 +1030
Message-ID: <877fu5iwxk.fsf@rustcorp.com.au>
References: <1427198927-1745-1-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <virtio-dev-return-675-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <1427198927-1745-1-git-send-email-kraxel@redhat.com>
To: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org
Cc: mst@redhat.com, David Herrmann <dh.herrmann@gmail.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, Vojtech Pavlik <vojtech@suse.cz>
List-Id: linux-api@vger.kernel.org

Gerd Hoffmann <kraxel@redhat.com> writes:
> virtio-input is basically evdev-events-over-virtio, so this driver isn't
> much more than reading configuration from config space and forwarding
> incoming events to the linux input layer.
>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Is the input layer sane?  I've never dealt with it, so I don't know.

What's it used for?

Imagine a future virtio standard which incorporates this.  And a Windows
or FreeBSD implementation of the device and or driver.  How ugly would
they be?

Thanks,
Rusty.
