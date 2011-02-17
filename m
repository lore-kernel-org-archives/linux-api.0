From: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/5] Exporting DMI entries via syfs
Date: Thu, 17 Feb 2011 13:27:55 -0800
Message-ID: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patchset applies to v2.6.38-rc5.

The following series exports information the DMI / SMBIOS tables via
sysfs under the path /sys/firmware/dmi.

For our purposes, we actively use the System Event Log, as described by
DMI entry Type 15.  Currently, we have to grub around /dev/mem to find
this thing, and potentially need to issue IOs directly from userland to
get at the event log, which is suboptimal in terms of security and
architecture.

This series implements the basics needed to iterate through the DMI
entries safely from userland.  Each entry has the handle, the formatted
length and the raw bytes exposed in their own sub-directory under
/sys/firmware/dmi/entries/<type>-<instance>.

As well, this series explodes type 15 as a proof-of-concept of how we
can expose kernel interpretations of the entry data.  For most entries,
there isn't much sense in parsing the entry and exposing each field it
as a sysfs attribute as they can be interpreted from userland by
accessing the raw entry itself.  Type 15 however describes an
indirection (pointing at the system event log), and it is generally
useful to export this log in raw form to the user (which requires
interpreting the DMI entry).

This driver relies solely on dmi_walk() for access to the dmi entries.
They are not kept mapped in the "rest" state.  The only bits memo-ized
by the objects in sysfs are the dmi headers, which are used to the find
the entries via dmi_walk on read.   Reading the raw bytes however is
'uncached' by this driver, so that any changes to the entries themselves
are reflected properly by the user-exposed interface.

We intend to use this on our production servers, though it seems to
also be sufficient to suit Chrome OS's needs
(http://code.google.com/p/chromium-os/issues/detail?id=6795) as well.

Thanks,

Mike Waychison

Related discussions
===================

   - Andi Kleen suggesting that perhaps this data could be exported via
     sysfs:

http://kerneltrap.org/mailarchive/linux-kernel/2010/9/28/4625643/thread

   - Tim Hockin suggesting a potential layout:

https://lkml.org/lkml/2011/2/10/550



Patchset summary
================

firmware: Add DMI entry types to the headers
firmware: Basic dmi-sysfs support
firmware: Break out system_event_log in dmi-sysfs
firmware: Expose DMI type 15 System Event Log
firmware: Add documentation for /sys/firmware/dmi

Diffstat
========

 Documentation/ABI/testing/sysfs-firmware-dmi |  101 ++++
 drivers/firmware/Kconfig                     |   11 
 drivers/firmware/Makefile                    |    1 
 drivers/firmware/dmi-sysfs.c                 |  664 +++++++++++++++++++++++++++
 include/linux/dmi.h                          |   47 +
 5 files changed, 824 insertions(+)

changeLog:
==========
- v1
   - Initial public send-out.
