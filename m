From: Amit Pundir <amit.pundir@linaro.org>
Subject: [RFC][PATCH 0/2] usb: gadget: add MTP function and Uevent userspace notifications
Date: Fri, 14 Aug 2015 00:42:18 +0530
Message-ID: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>, Benoit Goby <benoit@android.com>, Colin Cross <ccross@android.com>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Peter Oh <poh@broadcom.com>, Greg Hackmann <ghackmann@google.com>, Badhri Jagan Sridharan <Badhri@google.com>, Android Kernel Team <kernel-team@android.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Yegor Yefremov <yegorslists@googlemail.com>, Philippe Reynes <tremyfr@gmail.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org

RFC on Android's ConfigFS based MTP function implementation and usage
of Uevents to notify the userspace about the USB state changes.

The MTP function is based on years of work originally done in the
Android kernel tree by:
    Mike Lockwood <lockwood@android.com>
    Benoit Goby <benoit@android.com>
    Colin Cross <ccross@android.com>
    Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
    Peter Oh <poh@broadcom.com>
    Greg Hackmann <ghackmann@google.com>
    Badhri Jagan Sridharan <Badhri@google.com>

The Uevent notification patch is more of an RFC than an actual
submission. It is based on Android patchset originaly authored by
Badhri to send uevent notifications to Android userpace for USB
state changes.

I've folded the series up to make it easier to review, provided a
coherent patch description and modified it enough that I don't want
them to be blamed for any mistakes I've made condensing their patches
down.

Thoughts and feedback would be appreciated.

Thanks,
Amit Pundir

Cc: Mike Lockwood <lockwood@android.com>
Cc: Benoit Goby <benoit@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Peter Oh <poh@broadcom.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Badhri Jagan Sridharan <Badhri@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Philippe Reynes <tremyfr@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>

Amit Pundir (2):
  usb: gadget: configfs: add MTP function
  usb: gadget: configfs: notify userspace of usb state changes

 Documentation/ABI/testing/configfs-usb-gadget-mtp |    7 +
 Documentation/usb/gadget-testing.txt              |   24 +
 drivers/usb/gadget/Kconfig                        |   21 +
 drivers/usb/gadget/configfs.c                     |  201 ++-
 drivers/usb/gadget/function/Makefile              |    2 +
 drivers/usb/gadget/function/f_mtp.c               | 1365 +++++++++++++=
++++++++
 include/linux/usb/f_mtp.h                         |   23 +
 include/uapi/linux/usb/f_mtp.h                    |   61 +
 8 files changed, 1702 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-mtp
 create mode 100644 drivers/usb/gadget/function/f_mtp.c
 create mode 100644 include/linux/usb/f_mtp.h
 create mode 100644 include/uapi/linux/usb/f_mtp.h

--=20
1.9.1
