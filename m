From: Krzysztof Opasiak <k.opasiak-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Thu, 26 Nov 2015 10:19:29 +0100
Message-ID: <5656CEA1.9010203@samsung.com>
References: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1448466334-21346-1-git-send-email-emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Emilio_L=c3=b3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org



On 11/25/2015 04:45 PM, Emilio L=C3=B3pez wrote:
> Hi everyone,
>
> This patch introduces a new ioctl, USBDEVFS_DROP_PRIVILEGES,
> to voluntarily forgo the ability to issue ioctls which may
> interfere with other users of the USB device.
>
> This feature allows a privileged process (in the case of Chrome OS,
> permission_broker) to open a USB device node and then drop a number
> of capabilities that are considered "privileged".

We had the same idea in Tizen but for now we didn't have time to=20
implement it.

  These privileges
> include the ability to reset the device if there are other users
> (most notably a kernel driver) or to disconnect a kernel driver
> from the device. The file descriptor can then be passed to an
> unprivileged process.

And how about switching configuration? This can be also harmful even if=
=20
the are no other users for any interface in this configuration.
(Just imagine the situation in which only second config contains an HID=
=20
function and when app switch configuration it is activated without user=
=20
knowing about this;))

>
> This is useful for granting a process access to a device with
> multiple functions. It won't be able to use its access to one
> function to disrupt or take over control of another function.

I run through your code and as far as I understand above is not exactly=
=20
true. Your patch allows only to prevent userspace from accessing=20
interfaces which has kernel drivers, there is no way to stop an=20
application from taking control over all free interfaces.

Let's say that your device has 3 interfaces. First of them has a kernel=
=20
driver but second and third doesn't. You have 2 apps. One should=20
communicate using second interface and another one third. But first app=
=20
is malicious and it claims all free interfaces of received device (your=
=20
patch doesn't prevent this). And when second app starts it is unable to=
=20
do anything with the device because all interfaces are taken. How would=
=20
you like to handle this?

Moreover I'm not convinced to this patch as it hardcodes the *policy* i=
n=20
kernel code. Generally our approach (with passing fd from broker to=20
unprivileged process) was similar but we found out that if we would lik=
e=20
to do this correctly there is much more things to filter than in this=20
patch. We had two main ideas:

- implement some LSM hooks in ioctls() but this leads to a lot of=20
additional callbacks in lsm ops struct which even now is very big. But=20
as a benefit we would get a very flexible policy consistent with other=20
system policies

- split single usb device node into multiple files which could represen=
t=20
single endpoins only for io and separate control file for privileged bu=
t=20
it's quite a lot of work and I don't know if any one is going to accept=
=20
such a change

Best regards,
--=20
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
