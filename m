From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v5] Input: Add userio module
Date: Sat, 19 Sep 2015 10:39:20 -0700
Message-ID: <20150919173920.GC7081@dtor-ws>
References: <1442530810-28519-1-git-send-email-cpaul@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442530810-28519-1-git-send-email-cpaul@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cpaul@redhat.com
Cc: David Herrmann <dh.herrmann@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, "open list:HID CORE LAYER" <linux-input@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>, Vishnu Patekar <vishnupatekar0510@gmail.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, Hans de Goede <hdegoede@redhat.com>, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Stephen,

On Thu, Sep 17, 2015 at 07:00:10PM -0400, cpaul@redhat.com wrote:
> 				   Responses
> * Re: if (!userio) in userio_device_write(): it happens if we close the file
>   descriptor while the input driver is trying to talk to the device, since we
>   can't immediately bring down the driver. Removing the condition breaks the
>   driver

...

> +/**
> + * userio_device_write - Write data from serio to a userio device in userspace
> + * @id: The serio port for the userio device
> + * @val: The data to write to the device
> + */
> +static int userio_device_write(struct serio *id, unsigned char val)
> +{
> +	struct userio_device *userio = id->port_data;
> +
> +	if (!userio)
> +		return -1;

1. I do not see where we reset port data.
2. I do not see what prevents object to which you now have a pointer to
from disappearing at any moment past your check.

> +
> +	mutex_lock(&userio->lock);

serio_write() must allow to be called from interrupt context, so you
can't use mutex here.

Thanks.

-- 
Dmitry
