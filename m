From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: Re: [RFC][PATCH 2/2] usb: gadget: configfs: notify userspace of usb
 state changes
Date: Thu, 13 Aug 2015 21:42:17 +0200
Message-ID: <55CCF319.1070604@samsung.com>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
 <1439493140-22207-3-git-send-email-amit.pundir@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1439493140-22207-3-git-send-email-amit.pundir@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Pundir <amit.pundir@linaro.org>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>, Benoit Goby <benoit@android.com>, Colin Cross <ccross@android.com>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Peter Oh <poh@broadcom.com>, Greg Hackmann <ghackmann@google.com>, Badhri Jagan Sridharan <Badhri@google.com>, Android Kernel Team <kernel-team@android.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Yegor Yefremov <yegorslists@googlemail.com>, Philippe Reynes <tremyfr@gmail.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org

Hello,

On 08/13/2015 09:12 PM, Amit Pundir wrote:
> This is more of an RFC than an actual submission. There are few
> scattered #ifdefs..#endifs here and there which still need to be
> taken care of before going for actual submission.
>
> Currently there is no way with the upstream ConfigFS gadget to
> communicate state changes (connected, disconnected, configured), at
> the gadget level. Instead such state changes are handled function by
> function independently I presume. This is problematic, because some
> coordination between the functions, across the state changes, may be
> desired at the userspace level. Thus to address this issue, this
> patch send uevents to allow userspace to be notified of these usb
> state changes, allowing userspace to respond and configure the
> configfs gadget appropriately.
>
> This patch is based on an Android patchset originaly authored by
> Badhri Jagan Sridharan<Badhri@google.com>  to send uevent notificatio=
ns
> to Android userpace for USB state changes. I've folded his patches
> together and modified it enough that I don't want him to be blamed fo=
r
> any mistakes I've made condensing his patches down.
>
> This patch introduces USB_CONFIGFS_UEVENT Kconfig to handle userspace
> notifications of usb state changes, and add setup and disconnect
> functions to intercept the setup requests from the usb_core. It also
> creates a sysfs device class entry and a device attribute (state) to
> read and respond to gadget's current state from userspace. As of now
> this sysfs device class (/sys/class/android_usb) and gadget device
> (/sys/class/android_usb/android0) with state attribute
> (/sys/class/android_usb/android0/state) are strictly tied up to
> facilitate Android userspace requests. But going forward we may want
> to bring all function devices (hid, printer etc) under a unified usb
> gadget device class e.g. /sys/class/usb_gadget/g_{func0,func1} etc..
>
> Also I think it make sense to add this state attribute to the configf=
s
> usb gadget itself i.e. have something like /config/usb_gadget/g1/stat=
e
> to read USB gadget's current state. Since it is going to be consisten=
t
> throughout all the functions tied up to that gadget.
>
> Again this is just an initial RFC, thoughts and feedback would be
> greatly appreciated.
>
> Cc: Mike Lockwood<lockwood@android.com>
> Cc: Benoit Goby<benoit@android.com>
> Cc: Colin Cross<ccross@android.com>
> Cc: Arve Hj=C3=B8nnev=C3=A5g<arve@android.com>
> Cc: Peter Oh<poh@broadcom.com>
> Cc: Greg Hackmann<ghackmann@google.com>
> Cc: Badhri Jagan Sridharan<Badhri@google.com>
> Cc: Android Kernel Team<kernel-team@android.com>
> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> Cc: Jonathan Corbet<corbet@lwn.net>
> Cc: Felipe Balbi<balbi@ti.com>
> Cc: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
> Cc: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> Cc: Yegor Yefremov<yegorslists@googlemail.com>
> Cc: Philippe Reynes<tremyfr@gmail.com>
> Cc: John Stultz<john.stultz@linaro.org>
> Cc: Sumit Semwal<sumit.semwal@linaro.org>
> Signed-off-by: Amit Pundir<amit.pundir@linaro.org>

Generally I agree that there should be some way of notifying userspace=20
about gadget state but I'm not sure if this is proper way to go. In my=20
opinion gadget-bus which has been discussed some time ago on linux-usb=20
makes much more sense than this.

Maybe I will be wrong but I guess that you are adding this feature to=20
make android mtp-responder working properly in Linux (not android).=20
Again if we use FFS instead of adding mtp function we don't need this=20
notification as mtp-responder can get all the required informations=20
about gadget (function) via ep0 using functionfs events.

Best regards,

--=20
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
