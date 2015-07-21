From: Stephen Chandler Paul <cpaul-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC] ps2emu - PS/2 emulation module
Date: Tue, 21 Jul 2015 15:07:13 -0400
Message-ID: <1437505634-8633-1-git-send-email-cpaul@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jiri Slaby <jslaby-IBi9RG/b67k@public.gmane.org>, Vishnu Patekar <vishnupatekar0510-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benjamin Tissoires <benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi! So, following this is a patch to add the ps2emu module to the kernel. This
module basically allows for us to create virtual PS/2 devices and control them
from userspace. With this, we can do useful things such as playing back
recordings of PS/2 devices in a similar manner to evemu-replay and hid-replay.
This lets us debug PS/2 devices that we may not have physical access to, such
as laptop touchpads. This is a huge help when we receive bug reports for devices that
we can't get access to. We've already used this module to assist with fixing
bugs[1] where we needed to be able to replicate the device on a lower level then
we could with evemu-replay or hid-replay. This module could also come into use
when trying to debug the initialization process of devices, along with testing
for regressions with various devices.

The module itself creates a character device at /dev/ps2emu, which userspace
applications can connect to and use to send/receive data straight through the
serio driver. It doesn't need to do much more then that, so it's not a very
large driver. There is a very basic command protocol used for this which has
room for potentially being extended upon in the future if the situation calls
for it.

Right now we make use of this module with the ps2emu userland tools[2] that I've
wrote recently. Recording of PS/2 devices is done by enabling the debugging
output from i8042, triggering a rescan of the PS/2 ports, and doing some clever
trimming of data to remove anything that goes across the i8042 chip that isn't
relevant to the PS/2 protocol. The replay application is pretty simple, and just
sends all of the events from the log through /dev/ps2emu. No additional
processing of the log has to be done, making the replay process very trivial so
long as the behavior of the driver in question is the same as it was when the
recording was done. This also means any bugs encountered during the recording
are easy to reproduce when we play the device back, and we don't need to be
concerned about a virtual device potentially exhibiting different behaviors in
the kernel than the physical one.

If you have any questions or comments, please don't hesitate.

Cheers,
	Stephen Chandler Paul

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1235175
[2] https://github.com/Lyude/ps2emu/releases/tag/v0.1.2

Stephen Chandler Paul (1):
  Input: Add ps2emu module

 Documentation/input/ps2emu.txt |  72 ++++++++++++
 MAINTAINERS                    |   6 +
 drivers/input/serio/Kconfig    |  10 ++
 drivers/input/serio/Makefile   |   1 +
 drivers/input/serio/ps2emu.c   | 251 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/ps2emu.h    |  42 +++++++
 6 files changed, 382 insertions(+)
 create mode 100644 Documentation/input/ps2emu.txt
 create mode 100644 drivers/input/serio/ps2emu.c
 create mode 100644 include/uapi/linux/ps2emu.h

--
2.4.3
