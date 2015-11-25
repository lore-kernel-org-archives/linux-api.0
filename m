From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
Subject: [PATCH v1 0/1] ioctl to disallow detaching kernel USB drivers
Date: Wed, 25 Nov 2015 12:45:33 -0300
Message-ID: <1448466334-21346-1-git-send-email-emilio.lopez@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org, kborer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: reillyg-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jorgelo-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio.lopez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi everyone,

This patch introduces a new ioctl, USBDEVFS_DROP_PRIVILEGES,
to voluntarily forgo the ability to issue ioctls which may
interfere with other users of the USB device.

This feature allows a privileged process (in the case of Chrome OS,
permission_broker) to open a USB device node and then drop a number
of capabilities that are considered "privileged". These privileges
include the ability to reset the device if there are other users
(most notably a kernel driver) or to disconnect a kernel driver
from the device. The file descriptor can then be passed to an
unprivileged process.

This is useful for granting a process access to a device with
multiple functions. It won't be able to use its access to one
function to disrupt or take over control of another function.

This patch is currently being used in Chrome OS; I have updated it
to be in line with changes in v4.4-rc.

Cheers!
Emilio


Reilly Grant (1):
  usb: devio: Add ioctl to disallow detaching kernel USB drivers.

 drivers/usb/core/devio.c          | 50 +++++++++++++++++++++++++++++++++++----
 include/uapi/linux/usbdevice_fs.h |  1 +
 2 files changed, 47 insertions(+), 4 deletions(-)

-- 
2.5.0
