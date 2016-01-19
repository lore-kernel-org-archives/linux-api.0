From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Tue, 19 Jan 2016 17:04:21 +0100
Message-ID: <20160119160421.GM2742@c203.arch.suse.de>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C61263E-7nf3+EsVnp4EVr6dp/gChrOUoyqYp7Dr@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Singhal, Maneesh" <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "JBottomley-wo1vFcy6AUs@public.gmane.org" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 19, 2016 at 11:58:06AM +0000, Singhal, Maneesh wrote:
> Hello,
> Kindly review the following patch for the following driver to be adde=
d in SCSI subsystem -
>=20
> Regards
> Maneesh
>=20
> ---------------------------------------------------------------------=
-------
> From f3c4b836d6f130b1d7ded618002c8164f8f4a06d Mon Sep 17 00:00:00 200=
1
> From: "maneesh.singhal" <maneesh.singhal-mb1K0bWo544@public.gmane.org>
> Date: Tue, 19 Jan 2016 06:39:35 -0500
> Subject: [PATCH] [PATCH] drivers/scsi/emcctd: Client driver implement=
ation for
>  EMC-Symmetrix GuestOS emulated Cut-Through Device.
>=20
> The patch is a driver implementation  EMC-Symmetrix GuestOS emulated =
Cut-Through
> Device. The Cut-Through Device PCI emulation is implemented for Guest=
OS
> environments in the HyperMax OS. GuestOS environments allows loading =
of
> any x86 compliant operating systems like Linux/FreeBSD etc.
>=20
> The client driver is a SCSI HBA implementation which interfaces with =
SCSI
> midlayer in the north-bound interfaces and connects with the emulated=
 PCI device
> on the south side.
>=20
> The PCI vendor ID:product ID for emulated Cut-Through Device is 0x112=
0:0x1B00.
>=20
> Signed-off-by: maneesh.singhal <maneesh.singhal-mb1K0bWo544@public.gmane.org>
> ---
>  Documentation/scsi/emcctd.txt           |   57 +
>  MAINTAINERS                             |    9 +
>  drivers/scsi/Kconfig                    |    1 +
>  drivers/scsi/Makefile                   |    1 +
>  drivers/scsi/emcctd/Kconfig             |    7 +
>  drivers/scsi/emcctd/Makefile            |    1 +
>  drivers/scsi/emcctd/README              |   10 +
>  drivers/scsi/emcctd/emc_ctd_interface.h |  386 +++++
>  drivers/scsi/emcctd/emcctd.c            | 2840 +++++++++++++++++++++=
++++++++++
>  drivers/scsi/emcctd/emcctd.h            |  232 +++
>  10 files changed, 3544 insertions(+)
>  create mode 100644 Documentation/scsi/emcctd.txt
>  create mode 100644 drivers/scsi/emcctd/Kconfig
>  create mode 100644 drivers/scsi/emcctd/Makefile
>  create mode 100644 drivers/scsi/emcctd/README
>  create mode 100644 drivers/scsi/emcctd/emc_ctd_interface.h
>  create mode 100644 drivers/scsi/emcctd/emcctd.c
>  create mode 100644 drivers/scsi/emcctd/emcctd.h
>=20
> diff --git a/Documentation/scsi/emcctd.txt b/Documentation/scsi/emcct=
d.txt
> new file mode 100644
> index 0000000..bcafc87
> --- /dev/null
> +++ b/Documentation/scsi/emcctd.txt
> @@ -0,0 +1,56 @@
> +This file contains brief information about the EMC Cut-Through Drive=
r (emcctd).
> +The driver is currently maintained by Singhal, Maneesh (maneesh.sing=
hal-mb1K0bWo544@public.gmane.org)
> +
> +Last modified: Mon Jan 18 2016 by Maneesh Singhal
> +
> +BASICS
> +
> +Its a client driver implementation for EMC-Symmetrix GuestOS emulate=
d
> +Cut-Through Device. The Cut-Through Device PCI emulation is implemen=
ted for
> +GuestOS environments in the HyperMax OS. GuestOS environments allows=
 loading of
> +any x86 compliant operating systems like Linux/FreeBSD etc.
> +
> +The client driver is a SCSI HBA implementation which interfaces with=
 SCSI
> +midlayer in the north-bound interfaces and connects with the emulate=
d PCI device
> +on the south side.
> +
> +The PCI vendor ID:product ID for emulated Cut-Through Device is 0x11=
20:0x1B00.
> +
> +VERSIONING
> +
> +The Version of the driver is maintained as 2.0.0.X, where 2 refers t=
o the CTD
> +protocol in use, and X refers to the ongoing version of the driver.
> +
> +
> +SYSFS SUPPORT
> +
> +The driver creates the directory /sys/module/emcctd and populates it=
 with
> +version file and a directory for various parameters as described in =
MODULE
> +PARAMETERS section.
> +
> +PROCFS SUPPORT
> +
> +The driver creates the directory /proc/emc and creates files emcctd_=
stats_x
> +where 'x' refers to the PCI emulation number this client driver conn=
ected to.
> +These files cotains WWN information and IO statistics for the partic=
ular PCI
> +emulation.
> +
> +MODULE PARAMETERS
> +
> +The supported parameters which could add debuggability or change the=
 runtime
> +behavior of the driver are as following:
> +
> +ctd_debug=3D0 | 1		Enable driver debug messages(0=3Doff, 1=3Don)
> +
> +max_luns=3Dxx		Specify the maximum number of LUN's per
> +			host(default=3D16384)
> +
> +cmd_per_lun=3Dxx		Specify the maximum commands per lun(default=3D16)
> +
> +DEBUGGING HINTS
> +
> +Debugging code is now compiled in by default but debugging is turned=
 off
> +with the kernel module parameter debug_flag defaulting to 0.  To ena=
ble debug at
> +module load time add ctd_debug=3D1 to the module load options.
> +Debugging can also be enabled and disabled by writing a '0' (disable=
) or '1'
> +(enable) to the sysfs file /sys/module/emcctd/parameters/ctd_debug
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d23f70..671173a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6601,6 +6601,15 @@ F:	drivers/message/fusion/
>  F:	drivers/scsi/mpt2sas/
>  F:	drivers/scsi/mpt3sas/
>=20
> +EMC Cut-Through Driver
> +M:	fredette, matt <matt.fredette-mb1K0bWo544@public.gmane.org>
> +M:	Pirotte, Serge <serge.pirotte-mb1K0bWo544@public.gmane.org>
> +M:	Singh Animesh <Animesh.Singh-mb1K0bWo544@public.gmane.org>
> +M:	Singhal, Maneesh <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
> +L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +S:	Maintained
> +F:	drivers/scsis/emcctd/
> +
>  LSILOGIC/SYMBIOS/NCR 53C8XX and 53C1010 PCI-SCSI drivers
>  M:	Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
>  L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index c1fe0d2..cbc03d7 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -477,6 +477,7 @@ source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
>  source "drivers/scsi/aic94xx/Kconfig"
>  source "drivers/scsi/hisi_sas/Kconfig"
>  source "drivers/scsi/mvsas/Kconfig"
> +source "drivers/scsi/emcctd/Kconfig"
>=20
>  config SCSI_MVUMI
>  	tristate "Marvell UMI driver"
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 862ab4e..55bea65 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -132,6 +132,7 @@ obj-$(CONFIG_SCSI_IBMVFC)	+=3D ibmvscsi/
>  obj-$(CONFIG_SCSI_HPTIOP)	+=3D hptiop.o
>  obj-$(CONFIG_SCSI_STEX)		+=3D stex.o
>  obj-$(CONFIG_SCSI_MVSAS)	+=3D mvsas/
> +obj-$(CONFIG_SCSI_EMCCTD)	+=3D emcctd/
>  obj-$(CONFIG_SCSI_MVUMI)	+=3D mvumi.o
>  obj-$(CONFIG_PS3_ROM)		+=3D ps3rom.o
>  obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libiscsi.o libiscsi_tcp.o cxgbi/
> diff --git a/drivers/scsi/emcctd/Kconfig b/drivers/scsi/emcctd/Kconfi=
g
> new file mode 100644
> index 0000000..d995b53
> --- /dev/null
> +++ b/drivers/scsi/emcctd/Kconfig
> @@ -0,0 +1,7 @@
> +config SCSI_EMCCTD
> +	tristate "EMC Cut-Through client driver"
> +	depends on SCSI && PCI && X86
> +	help
> +		This driver supports EMC virtual PCI Cut-Through-Device.
> +		To compile this driver as a module, choose M here: the
> +		module will be called emcctd.
> diff --git a/drivers/scsi/emcctd/Makefile b/drivers/scsi/emcctd/Makef=
ile
> new file mode 100644
> index 0000000..74a070e
> --- /dev/null
> +++ b/drivers/scsi/emcctd/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_SCSI_EMCCTD) +=3D emcctd.o
> diff --git a/drivers/scsi/emcctd/README b/drivers/scsi/emcctd/README
> new file mode 100644
> index 0000000..496ce7f
> --- /dev/null
> +++ b/drivers/scsi/emcctd/README
> @@ -0,0 +1,10 @@
> +EMCCTD : Client driver implementation for EMC-Symmetrix GuestOS emul=
ated
> +Cut-Through Device. The Cut-Through Device PCI emulation is implemen=
ted for
> +GuestOS environments in the HyperMax OS. GuestOS environments allows=
 loading of
> +any x86 compliant operating systems like Linux/FreeBSD etc.
> +
> +The client driver is a SCSI HBA implementation which interfaces with=
 SCSI
> +midlayer in the north-bound interfaces and connects with the emulate=
d PCI device
> +on the south side.
> +
> +The PCI vendor ID:product ID for emulated Cut-Through Device is 0x11=
20:0x1B00.
> diff --git a/drivers/scsi/emcctd/emc_ctd_interface.h b/drivers/scsi/e=
mcctd/emc_ctd_interface.h
> new file mode 100644
> index 0000000..58a0276
> --- /dev/null
> +++ b/drivers/scsi/emcctd/emc_ctd_interface.h
> @@ -0,0 +1,386 @@
> +/*
> + * EMCCTD: EMC Cut-Through HBA Driver for SCSI subsystem.
> + *
> + * Copyright (C) 2015 by EMC Corporation, Hopkinton, MA.
> + *
> + * Authors:
> + *	fredette, matt <matt.fredette-mb1K0bWo544@public.gmane.org>
> + *	Pirotte, Serge <serge.pirotte-mb1K0bWo544@public.gmane.org>
> + *	Singh Animesh <Animesh.Singh-mb1K0bWo544@public.gmane.org>
> + *	Singhal, Maneesh <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _EMC_CTD_INTERFACE_H
> +#define _EMC_CTD_INTERFACE_H
> +/*
> + *
> + * DESCRIPTION: Data structures used by the Cut-through subsystem.
> + *
> + * NOTES: Changes to any of these structures will mean that any Clie=
nts that
> + *        depend on them will also need to be modified. Since many o=
f those
> + *        Clients are not part of the Enginuity build process, this =
will almost
> + *        certainly require new versions of Guest OS CTD Client code=
 to be
> + *        released.
> + *
> + *        Before modifying any data structures in this file please d=
iscuss the
> + *        change with the maintainers.
> + *
> + */
> +
> +
> +/* macros: */
> +
> +/* the PCI vendor ID for all devices: */
> +#define EMC_CTD_PCI_VENDOR				(0x1120)
> +
> +/* the PCI product ID for all version 1.x devices: */
> +#define EMC_CTD_V010_PCI_PRODUCT			(0x1b00)
> +
> +/* the PCI revision ID for the first version 1.0 device: */
> +#define EMC_CTD_V010_PCI_REVISION			(1)
> +
> +/* the 64-bit BAR pair for the transmit and receive rings: */
> +#define EMC_CTD_V010_BAR_RINGS				(0)
> +
> +/* the 64-bit BAR pair for the fast registers: */
> +#define EMC_CTD_V010_BAR_FREGS				(2)
> +
> +/* the 32-bit BAR for the slow registers: */
> +#define EMC_CTD_V010_BAR_SREGS				(4)
> +
> +/* the maximum number of immediate SGL entries: */
> +#define EMC_CTD_V010_SGL_IMMEDIATE_MAX			(7)
> +
> +/* the CTD v010 whats: */
> +#define EMC_CTD_V010_WHAT_DETECT			(0)
> +#define EMC_CTD_V010_WHAT_SCSI_COMMAND			(1)
> +#define EMC_CTD_V010_WHAT_SCSI_PHASE			(2)
> +#define EMC_CTD_V010_WHAT_SCSI_RESPONSE			(3)
> +
> +/* the CTD v010 detect flags.  all undefined flags must be zero: */
> +
> +/* if this is set, the name is a SCSI target: */
> +#define EMC_CTD_V010_DETECT_FLAG_SCSI_TARGET		(1 << 0)
> +
> +/* if this is set, the name is a SCSI initiator: */
> +#define EMC_CTD_V010_DETECT_FLAG_SCSI_INITIATOR		(1 << 1)
> +
> +/* the CTD v010 SCSI command flags.  all undefined flags must be zer=
o: */
> +
> +/* when the guest receives a SCSI command message, this flag is unde=
fined.
> + *
> + * If this is set, at the beginning of any data phase the target is =
the data
> + * source.  if this is clear, at the beginning of any data phase the=
 target is
> + * the data sink.
> + */
> +#define EMC_CTD_V010_SCSI_COMMAND_FLAG_SOURCE		(1 << 0)
> +
> +/* when the guest receives a SCSI command message, this flag is unde=
fined.
> + *
> + * if this is set, the first SGL entry in the message points to an e=
xtended SGL,
> + * and the remaining SGL entries in the message are undefined.  if t=
his is
> + * clear, the SGL entries in the message are used:
> + */
> +#define EMC_CTD_V010_SCSI_COMMAND_FLAG_ESGL		(1 << 1)
> +
> +/* the CTD v010 SCSI response flags.  all undefined flags must be ze=
ro: */
> +
> +/* if this is set, the SCSI command failed.  if this is clear, the
> + * command succeeded:
> + */
> +#define EMC_CTD_V010_SCSI_RESPONSE_FLAG_FAILED		(1 << 0)
> +
> +/* if this is set, any extra information is sense data.  if this is =
clear, any
> + * extra information is 64-bit timestamps:
> + */
> +#define EMC_CTD_V010_SCSI_RESPONSE_FLAG_SENSE		(1 << 1)
> +
> +/* the CTD v010 SCSI phase flags.  all undefined flags must be zero:=
 */
> +
> +/* when the guest receives a SCSI phase message, this flag is undefi=
ned.
> + *
> + * if this is set, at this point in the data phase the message recei=
ver is the
> + * data source.  if this is clear, at this point in the data phase t=
he message
> + * receiver is the data sink:
> + */
> +#define EMC_CTD_V010_SCSI_PHASE_FLAG_SOURCE		(1 << 0)
> +
> +/* when the guest receives a SCSI phase message, this flag is undefi=
ned.
> + *
> + * if this is set, the first SGL entry in the message points to an e=
xtended SGL,
> + * and the remaining SGL entries in the message are undefined.  if t=
his is
> + * clear, the SGL entries in the message are used:
> + */
> +#define EMC_CTD_V010_SCSI_PHASE_FLAG_ESGL		(1 << 1)
> +
> +/* if this is set, the message receiver is the target.  if this is c=
lear, the
> + * message receiver is the initiator:
> + */
> +#define EMC_CTD_V010_SCSI_PHASE_FLAG_TARGET		(1 << 2)
> +
> +/* if this is set, the SCSI command is aborted: */
> +#define EMC_CTD_V010_SCSI_PHASE_FLAG_ABORT		(1 << 3)
> +
> +/* the size of the log of errored transmit messages: */
> +#define EMC_CTD_V010_LOG_ERROR_TX_SIZE			(4)
> +
> +/* errors: */
> +
> +/* no error: */
> +#define EMC_CTD_V010_ERROR_NULL				(0)
> +
> +/* the guest tried to transmit a message on a disconnected channel: =
*/
> +#define EMC_CTD_V010_ERROR_TX_CHANNEL_DISCONNECTED	(1)
> +
> +/* the guest tried to transmit a message with a bad what: */
> +#define EMC_CTD_V010_ERROR_TX_MESSAGE_WHAT		(2)
> +
> +/* the guest tried to transmit a message with a reserved field set t=
o
> + * the wrong value:
> + */
> +#define EMC_CTD_V010_ERROR_TX_MESSAGE_RESERVED		(3)
> +
> +/* the guest tried to transmit an out-of-order message: */
> +#define EMC_CTD_V010_ERROR_TX_MESSAGE_ORDER		(4)
> +
> +/* the guest tried to transmit a message to an endpoint whose type
> + * doesn't support it:
> + */
> +#define EMC_CTD_V010_ERROR_TX_ENDPOINT_TYPE		(5)
> +
> +/* the guest tried to transmit a message with an unknown message
> + * receiver's opaque value:
> + */
> +#define EMC_CTD_V010_ERROR_TX_OPAQUE_RX_UNKNOWN		(6)
> +
> +/* types: */
> +
> +/* a CTD v010 scatter/gather list entry: */
> +struct emc_ctd_v010_sgl {
> +
> +	/* the physical address of the buffer: */
> +	emc_ctd_uint32_t emc_ctd_v010_sgl_paddr_0_31;
> +	emc_ctd_uint32_t emc_ctd_v010_sgl_paddr_32_63;
> +
> +	/* the size of the buffer: */
> +	emc_ctd_uint32_t emc_ctd_v010_sgl_size;
> +};
> +
> +/* a CTD v010 header: */
> +struct emc_ctd_v010_header {
> +
> +	/* the other address: */
> +	emc_ctd_uint16_t emc_ctd_v010_header_address;
> +
> +	/* the minor version: */
> +	emc_ctd_uint8_t emc_ctd_v010_header_minor;
> +
> +	/* the what: */
> +	emc_ctd_uint8_t emc_ctd_v010_header_what;
> +};
> +
> +/* a CTD v010 name: */
> +struct emc_ctd_v010_name {
> +
> +	/* the name: */
> +	emc_ctd_uint8_t emc_ctd_v010_name_bytes[8];
> +};
> +
> +/* a CTD v010 detect message: */
> +struct emc_ctd_v010_detect {
> +
> +	/* the header: */
> +	struct emc_ctd_v010_header emc_ctd_v010_detect_header;
> +
> +	/* the flags: */
> +	emc_ctd_uint32_t emc_ctd_v010_detect_flags;
> +
> +	/* the name: */
> +	struct emc_ctd_v010_name emc_ctd_v010_detect_name;
> +
> +	/* the key: */
> +	emc_ctd_uint64_t emc_ctd_v010_detect_key;
> +};
> +
> +/* a CTD v010 SCSI command message: */
> +struct emc_ctd_v010_scsi_command {
> +
> +	/* the header: */
> +	struct emc_ctd_v010_header emc_ctd_v010_scsi_command_header;
> +
> +	/* the flags: */
> +	emc_ctd_uint32_t emc_ctd_v010_scsi_command_flags;
> +
> +	/* the initiator's opaque value: */
> +	emc_ctd_uint64_t emc_ctd_v010_scsi_command_opaque;
> +
> +	/* the SCSI LUN: */
> +	emc_ctd_uint8_t emc_ctd_v010_scsi_command_lun[8];
> +
> +	/* the SCSI CDB: */
> +	emc_ctd_uint8_t emc_ctd_v010_scsi_command_cdb[16];
> +
> +	/* the data size: */
> +	emc_ctd_uint32_t emc_ctd_v010_scsi_command_data_size;
> +
> +	union {
> +
> +		/* any SGL entries: */
> +		/* when received by the guest, these are undefined: */
> +		struct emc_ctd_v010_sgl
> +			emc_ctd_v010_scsi_command_sgl[EMC_CTD_V010_SGL_IMMEDIATE_MAX];
> +
> +	} emc_ctd_v010_scsi_command_u;
> +};
> +
> +/* a CTD v010 SCSI response message: */
> +struct emc_ctd_v010_scsi_response {
> +
> +	/* the header: */
> +	struct emc_ctd_v010_header emc_ctd_v010_scsi_response_header;
> +
> +	/* the flags: */
> +	emc_ctd_uint16_t emc_ctd_v010_scsi_response_flags;
> +
> +	/* the extra information size: */
> +	emc_ctd_uint8_t emc_ctd_v010_scsi_response_extra_size;
> +
> +	/* the SCSI status: */
> +	emc_ctd_uint8_t emc_ctd_v010_scsi_response_status;
> +
> +	/* the initiator's opaque value: */
> +	emc_ctd_uint64_t emc_ctd_v010_scsi_response_opaque;
> +
> +	/* the data size: */
> +	emc_ctd_uint32_t emc_ctd_v010_scsi_response_data_size;
> +
> +	union {
> +
> +		/* any extra information: */
> +		emc_ctd_uint8_t emc_ctd_v010_scsi_response_extra[108];
> +
> +	} emc_ctd_v010_scsi_response_u;
> +};
> +
> +/* a CTD v010 SCSI phase message: */
> +struct emc_ctd_v010_scsi_phase {
> +
> +	/* the header: */
> +	struct emc_ctd_v010_header emc_ctd_v010_scsi_phase_header;
> +
> +	/* the flags: */
> +	emc_ctd_uint32_t emc_ctd_v010_scsi_phase_flags;
> +
> +	/* the message receiver's opaque value: */
> +	emc_ctd_uint64_t emc_ctd_v010_scsi_phase_opaque_rx;
> +
> +	/* the message transmitter's opaque value: */
> +	emc_ctd_uint64_t emc_ctd_v010_scsi_phase_opaque_tx;
> +
> +	union {
> +
> +		/* any SGL entries: */
> +		/* when received by the guest, these are undefined: */
> +		struct emc_ctd_v010_sgl
> +			emc_ctd_v010_scsi_phase_sgl[EMC_CTD_V010_SGL_IMMEDIATE_MAX];
> +
> +	} emc_ctd_v010_scsi_phase_u;
> +};
> +
> +/* a CTD v010 message: */
> +union emc_ctd_v010_message {
> +
> +	/* the header: */
> +	struct emc_ctd_v010_header emc_ctd_v010_message_header;
> +
> +	/* a detect message: */
> +	struct emc_ctd_v010_detect emc_ctd_v010_message_detect;
> +
> +	/* a SCSI command message: */
> +	struct emc_ctd_v010_scsi_command emc_ctd_v010_message_scsi_command;
> +
> +	/* a SCSI response message: */
> +	struct emc_ctd_v010_scsi_response emc_ctd_v010_message_scsi_respons=
e;
> +
> +	/* a SCSI phase message: */
> +	struct emc_ctd_v010_scsi_phase emc_ctd_v010_message_scsi_phase;
> +
> +	/* padding: */
> +	emc_ctd_uint8_t emc_ctd_v010_message_padding[128];
> +};
> +
> +/* the fast registers: */
> +struct emc_ctd_v010_fregs {
> +
> +	/* the transmit ring producer index (TPI): */
> +	volatile emc_ctd_uint32_t emc_ctd_v010_fregs_tx_index_producer;
> +
> +	/* the error flag: */
> +	volatile emc_ctd_uint32_t emc_ctd_v010_fregs_error_flag;
> +
> +	/* errors 1..14: */
> +	volatile emc_ctd_uint32_t emc_ctd_v010_fregs_errors_1_14[14];
> +
> +	/* the transmit ring consumer index (TCI): */
> +	volatile emc_ctd_uint32_t emc_ctd_v010_fregs_tx_index_consumer;
> +
> +	/* the device name: */
> +	struct emc_ctd_v010_name emc_ctd_v010_fregs_device_name;
> +
> +	/* padding: */
> +	emc_ctd_uint8_t
> +		emc_ctd_v010_fregs_pad_07f[64 -
> +			(sizeof(emc_ctd_uint32_t) +
> +				sizeof(struct emc_ctd_v010_name))];
> +
> +	/* the receive ring producer index (RPI): */
> +	volatile emc_ctd_uint32_t emc_ctd_v010_fregs_rx_index_producer;
> +
> +	/* the interrupt throttle, in units of nanoseconds.  zero disables
> +	 * the throttle:
> +	 */
> +	emc_ctd_uint32_t emc_ctd_v010_fregs_interrupt_throttle_nsecs;
> +
> +	/* padding: */
> +	emc_ctd_uint8_t
> +		emc_ctd_v010_fregs_pad_0bf[64 -
> +			(sizeof(emc_ctd_uint32_t) + sizeof(emc_ctd_uint32_t))];
> +
> +	/* the receive ring consumer index (RCI): */
> +	volatile emc_ctd_uint32_t emc_ctd_v010_fregs_rx_index_consumer;
> +
> +	/* padding: */
> +	emc_ctd_uint8_t
> +		emc_ctd_v010_fregs_pad_0ff[64 -
> +			(sizeof(emc_ctd_uint32_t) +
> +				(sizeof(emc_ctd_uint32_t) *
> +					EMC_CTD_V010_LOG_ERROR_TX_SIZE))];
> +
> +	/* the errors for the log of errored transmit messages: */
> +	volatile emc_ctd_uint32_t
> +		emc_ctd_v010_fregs_log_error_tx_error[EMC_CTD_V010_LOG_ERROR_TX_SI=
ZE];
> +
> +	/* the log of errored transmit messages: */
> +	union emc_ctd_v010_message
> +		emc_ctd_v010_fregs_log_error_tx_message[EMC_CTD_V010_LOG_ERROR_TX_=
SIZE];
> +};
> +
> +/* the slow registers: */
> +struct emc_ctd_v010_sregs {
> +
> +	/* the reset register: */
> +	emc_ctd_uint32_t emc_ctd_v010_sregs_reset;
> +};
> +
> +#endif /* _EMC_CTD_INTERFACE_H */
> diff --git a/drivers/scsi/emcctd/emcctd.c b/drivers/scsi/emcctd/emcct=
d.c
> new file mode 100644
> index 0000000..aa6dd0e
> --- /dev/null
> +++ b/drivers/scsi/emcctd/emcctd.c
> @@ -0,0 +1,2840 @@
> +/*
> + * EMCCTD: EMC Cut-Through HBA Driver for SCSI subsystem.
> + *
> + * Copyright (C) 2015 by EMC Corporation, Hopkinton, MA.
> + *
> + * Authors:
> + *	fredette, matt <matt.fredette-mb1K0bWo544@public.gmane.org>
> + *	Pirotte, Serge <serge.pirotte-mb1K0bWo544@public.gmane.org>
> + *	Singh Animesh <Animesh.Singh-mb1K0bWo544@public.gmane.org>
> + *	Singhal, Maneesh <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/slab.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include <linux/proc_fs.h>
> +#include <linux/version.h>
> +#include <linux/delay.h>
> +#include <linux/blkdev.h>
> +#include <linux/atomic.h>
> +
> +#include <linux/cache.h>
> +
> +#include <linux/seq_file.h>
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_transport.h>
> +#include <scsi/scsi_dbg.h>
> +
> +#define emc_ctd_uint8_t u8
> +#define emc_ctd_uint16_t u16
> +#define emc_ctd_uint32_t u32
> +#define emc_ctd_uint64_t u64
> +
> +#include "emc_ctd_interface.h"
> +
> +#include "emcctd.h"
> +
> +#include <scsi/scsi_dbg.h>
> +
> +/* nomenclature for versioning
> + * MAJOR:MINOR:SUBVERSION:PATCH
> + */
> +
> +#define EMCCTD_MODULE_VERSION "2.0.0.24"
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("EMC");
> +MODULE_DESCRIPTION("EMC CTD V1 - Build 18-Jan-2016");
> +MODULE_VERSION(EMCCTD_MODULE_VERSION);
> +
> +int ctd_debug;
> +module_param_named(ctd_debug, ctd_debug, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(ctd_debug, "Enable driver debug messages(0=3Doff, 1=
=3Don)");
> +
> +static int emcctd_max_luns =3D EMCCTD_MAX_LUN;
> +module_param_named(max_luns, emcctd_max_luns, int, S_IRUGO | S_IWUSR=
);
> +MODULE_PARM_DESC(max_luns,
> +	"Specify the maximum number of LUN's per host(default=3D16384)");
> +
> +static int emcctd_cmd_per_lun =3D EMCCTD_CMD_PER_LUN;
> +module_param_named(cmd_per_lun, emcctd_cmd_per_lun, int, S_IRUGO | S=
_IWUSR);
> +MODULE_PARM_DESC(cmd_per_lun,
> +		"Specify the maximum commands per lun(default=3D64)");
> +
> +/*
> + * routines to handle scsi cmd buffer
> + */
> +static int ctd_xmit_command(struct scsi_cmnd *cmnd,
> +					struct ctd_pci_private *ctd_private);
> +static void ctd_handle_scsi_response(
> +		struct emc_ctd_v010_scsi_response *io_response,
> +		struct ctd_pci_private *ctd_private);
> +
> +static int ctd_hw_enqueue_request(union emc_ctd_v010_message *ctd_re=
quest,
> +					struct ctd_pci_private *ctd_private);
> +static int ctd_hw_dequeue_response(union emc_ctd_v010_message *ctd_r=
esponse,
> +					struct ctd_pci_private *ctd_private);
> +static int ctd_scsi_response_sanity_check(
> +			struct ctd_request_private *request_private,
> +			struct ctd_pci_private *ctd_private);
> +
> +/*
> + * routines to handle memory and queue management between client and=
 server
> + */
> +static int ctd_hw_execute_command(struct scsi_cmnd *cmnd,
> +				struct ctd_pci_private *ctd_private);
> +static int ctd_initiator_translate_sgl(struct scsi_cmnd *cmnd,
> +				struct emc_ctd_v010_scsi_command *ctd_request,
> +				struct ctd_pci_private *ctd_private);
> +static int ctd_initiator_translate_request(struct scsi_cmnd *cmnd,
> +			struct emc_ctd_v010_scsi_command *ctd_request,
> +			struct ctd_pci_private *ctd_private);
> +static void ctd_initiator_translate_lun(struct scsi_cmnd *cmnd,
> +			struct emc_ctd_v010_scsi_command *ctd_request);
> +
> +static struct ctd_request_private *ctd_acquire_request(
> +				struct ctd_pci_private *ctd_private);
> +static void ctd_release_request(struct ctd_request_private *ctd_requ=
est,
> +					struct ctd_pci_private *ctd_private);
> +static void ctd_release_io_pool(struct ctd_pci_private *ctd_private)=
;
> +static int ctd_alloc_io_pool(struct ctd_pci_private *ctd_private,
> +						unsigned int pool_size);
> +static void ctd_check_error_condition(struct pci_dev *pci_dev);
> +static int ctd_init_event_thread(struct ctd_pci_private *ctd_private=
);
> +static void ctd_destroy_event_thread(struct ctd_pci_private *ctd_pri=
vate);
> +/*
> + * routines related to tasklet functionality
> + */
> +static void ctd_check_response_queue(unsigned long instance_addr);
> +
> +static int ctd_ITnexus_handler(struct ctd_pci_private *ctd_private);
> +/*
> + * routines related to internal representation of scsi targets
> + */
> +static int ctd_target_alloc(struct scsi_target *starget);
> +static void ctd_target_destroy(struct scsi_target *starget);
> +/*
> + * routines registered with the linux scsi midlayer
> + */
> +static int ctd_queuecommand_lck(struct scsi_cmnd *cmnd,
> +				void (*done)(struct scsi_cmnd *));
> +static DEF_SCSI_QCMD(ctd_queuecommand)
> +static int ctd_slave_configure(struct scsi_device *sdp);
> +static int ctd_slave_alloc(struct scsi_device *sdev);
> +static void ctd_slave_destroy(struct scsi_device *sdev);
> +static int ctd_abort_handler(struct scsi_cmnd *cmd);
> +
> +static enum blk_eh_timer_return ctd_timeout_handler(struct scsi_cmnd=
 *scmd);
> +
> +
> +/*
> + * routines related to initialization of the pseudo hardware
> + */
> +static void ctd_init_scsi_host_private(struct Scsi_Host *shost,
> +						struct pci_dev *pci_dev);
> +
> +static int ctd_scsi_layer_init(struct pci_dev *pci_dev);
> +static int ctd_scsi_layer_cleanup(struct pci_dev *pci_dev);
> +
> +#ifdef CONFIG_PM
> +static int ctd_pci_suspend(struct pci_dev *pci_dev, pm_message_t sta=
te);
> +static int ctd_pci_resume(struct pci_dev *pci_dev);
> +#endif
> +
> +static void ctd_pci_remove(struct pci_dev *pci_dev);
> +static int ctd_request_msi(struct pci_dev *pci_dev);
> +static int ctd_pci_probe(struct pci_dev *pci_dev,
> +				const struct pci_device_id *id);
> +static void ctd_clear_io_queue(struct ctd_pci_private *ctd_private);
> +
> +#if !defined(__VMKLNX__)
> +static int ctd_proc_init(struct pci_dev *pci_dev);
> +static void ctd_proc_remove(struct pci_dev *pci_dev);
> +
> +static int ctd_proc_open(struct inode *inode, struct file *file);
> +#endif
> +
> +static int ctd_post_event(union emc_ctd_v010_message *io_msg,
> +				struct ctd_pci_private *ctd_private);
> +static int ctd_event_handler(void *ctd_thread_args);
> +
> +unsigned int lun_discovery_complete;
> +wait_queue_head_t lun_discovery_event_barrier;
> +
> +static const struct pci_device_id ctd_pci_id_table[] =3D {
> +	{ EMC_CTD_PCI_VENDOR, EMC_CTD_V010_PCI_PRODUCT,
> +	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> +	{ 0 },
> +};
> +
> +MODULE_DEVICE_TABLE(pci, ctd_pci_id_table);
> +
> +static struct pci_driver ctd_pci_driver =3D {
> +	.name           =3D "emcctd",
> +	.id_table       =3D ctd_pci_id_table,
> +	.probe          =3D ctd_pci_probe,
> +	.remove         =3D ctd_pci_remove,
> +#ifdef CONFIG_PM
> +	.suspend        =3D ctd_pci_suspend,
> +	.resume         =3D ctd_pci_resume,
> +#endif
> +};
> +
> +static struct scsi_host_template scsi_ctd_template =3D {
> +	.name =3D DRV_NAME,
> +	.proc_name =3D DRV_NAME,
> +	.queuecommand =3D ctd_queuecommand,
> +
> +	.eh_timed_out =3D ctd_timeout_handler,
> +
> +	.slave_alloc =3D ctd_slave_alloc,
> +	.slave_configure =3D ctd_slave_configure,
> +	.slave_destroy =3D ctd_slave_destroy,
> +	.eh_abort_handler =3D ctd_abort_handler,
> +	.target_alloc =3D ctd_target_alloc,
> +	.target_destroy =3D ctd_target_destroy,
> +	.can_queue =3D EMCCTD_CMD_PER_LUN,
> +	.this_id =3D EMCCTD_THIS_ID,
> +	.sg_tablesize =3D SG_ALL,
> +	.max_sectors =3D SCSI_DEFAULT_MAX_SECTORS,
> +	.cmd_per_lun =3D EMCCTD_CMD_PER_LUN,
> +	.use_clustering =3D DISABLE_CLUSTERING,
> +	.module =3D THIS_MODULE,
> +};
> +
> +
> +#if !defined(__VMKLNX__)
> +static struct proc_dir_entry *ctd_proc_directory;
> +
> +static int
> +ctd_proc_show(struct seq_file *m, void *v)
> +{
> +	int i;
> +	struct ctd_pci_private *ctd_private =3D
> +		(struct ctd_pci_private *)m->private;
> +
> +	seq_printf(m,
> +			"number interrupts: %ld\n"
> +			"requests queued: %ld\n"
> +			"responses received: %ld\n"
> +			"pending IO count: %ld\n"
> +			"Abort Sent: %ld\n"
> +			"Abort received: %ld\n"
> +			"What received: %ld\n"
> +			"What sent: %ld\n"
> +			"free IO entries : %ld\n"
> +			"CTD WWN: %x.%x.%x.%x.%x.%x.%x.%x\n",
> +			ctd_private->hw_stats.interrupts.counter,
> +			ctd_private->hw_stats.requests_sent.counter,
> +			ctd_private->hw_stats.responses_received.counter,
> +			ctd_private->hw_stats.active_io_count.counter,
> +			ctd_private->hw_stats.abort_sent.counter,
> +			ctd_private->hw_stats.abort_received.counter,
> +			ctd_private->hw_stats.what_in.counter,
> +			ctd_private->hw_stats.what_out.counter,
> +			ctd_private->hw_stats.free_io_entries.counter,
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[0],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[1],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[2],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[3],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[4],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[5],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[6],
> +			ctd_private->pci_fast_registers->emc_ctd_v010_fregs_device_name.e=
mc_ctd_v010_name_bytes[7]);
> +
> +#define MAX_ENTRIES_IN_LINE		10
> +	seq_puts(m, "\nIO Latency (in tsc) for last 200 IOs:\n");
> +
> +	for (i =3D 0; i < CTD_MAX_IO_STATS; i++) {
> +		if (0 =3D=3D (i % MAX_ENTRIES_IN_LINE))
> +			seq_puts(m, "\n");
> +
> +		seq_printf(m, "%lld \t", ctd_private->hw_stats.io_stats[i]);
> +	}
> +	seq_puts(m, "\n");
> +
> +	return 0;
> +
> +}
> +
> +#endif
> +
> +static void
> +scsi_translate_sam_code(struct scsi_cmnd *cmnd, unsigned char ScsiSt=
atus)
> +{
> +	unsigned char host_status;
> +	unsigned char driver_status;
> +
> +	host_status =3D DID_OK;
> +	driver_status =3D DRIVER_OK;
> +	cmnd->result |=3D ScsiStatus & 0xff;
> +
> +	switch (ScsiStatus) {
> +
> +	case SAM_STAT_GOOD:
> +	case SAM_STAT_CONDITION_MET:
> +	case SAM_STAT_INTERMEDIATE_CONDITION_MET:
> +	case SAM_STAT_INTERMEDIATE:
> +		break;
> +	case SAM_STAT_CHECK_CONDITION:
> +	case SAM_STAT_RESERVATION_CONFLICT:
> +	case SAM_STAT_ACA_ACTIVE:
> +		driver_status =3D DRIVER_SENSE;
> +		break;
> +	case SAM_STAT_TASK_SET_FULL:
> +	case SAM_STAT_BUSY:
> +		driver_status =3D DRIVER_BUSY;
> +		host_status =3D DID_REQUEUE;
> +		break;
> +	case SAM_STAT_TASK_ABORTED:
> +		driver_status =3D DRIVER_ERROR;
> +		host_status =3D DID_ABORT;
> +		break;
> +	case SAM_STAT_COMMAND_TERMINATED:
> +	default:
> +		ctd_dprintk_crit(
> +			"cmnd =3D %p [ channel:%d id:%d lun:%lld] INVALID SAM =3D %x\n",
> +				cmnd, cmnd->device->channel, cmnd->device->id,
> +				cmnd->device->lun, ScsiStatus);
> +
> +		driver_status =3D DRIVER_INVALID;
> +		host_status =3D DID_ABORT;
> +		break;
> +	}
> +	set_driver_byte(cmnd, driver_status);
> +	set_host_byte(cmnd, host_status);
> +}
> +
> +static void
> +scsi_free_ctd_request_private(struct ctd_request_private *request_pr=
ivate,
> +				struct ctd_pci_private *ctd_private)
> +{
> +
> +	if (request_private->cdb_page) {
> +		__free_pages(request_private->cdb_page,
> +				request_private->cdb_page_order);
> +	}
> +	if (request_private->sgllist_page) {
> +		__free_pages(request_private->sgllist_page,
> +				request_private->sgllist_page_order);
> +	}
> +
> +	ctd_release_request(request_private, ctd_private);
> +}
> +
> +static int
> +ctd_handle_disconnect(struct emc_ctd_v010_detect *io_detect,
> +			struct ctd_pci_private *ctd_private)
> +{
> +	int i;
> +	int error;
> +	struct ctd_target_info *ctd_target;
> +	struct ctd_host_info *ctd_host;
> +
> +	error =3D -ENODEV;
> +
> +	ctd_dprintk_crit("\n");
> +
> +	ctd_host =3D ctd_private->host_private;
> +
> +	/* Current implementation only handles the disconnect of
> +	 * the target and not initiators
> +	 */
> +	for (i =3D 0; i < EMCCTD_MAX_ID; i++) {
> +		ctd_target =3D &ctd_host->target[i];
> +
> +		/* detect header address is used to uniquely identify the target
> +		 * for which the disconnect event has been posted by the server
> +		 */
> +
> +		if (ctd_target->ctd_detect.emc_ctd_detect_header_address =3D=3D
> +			io_detect->emc_ctd_detect_header_address) {
> +			/* check the current link status of the target */
> +			if (ctd_target->ctd_detect.emc_ctd_v010_detect_flags) {
> +				ctd_dprintk_crit("\n");
> +
> +				ctd_target->ctd_detect.emc_ctd_v010_detect_flags =3D
> +					io_detect->emc_ctd_v010_detect_flags;
> +
> +				ctd_check_error_condition(ctd_private->pci_dev);
> +			} else {
> +				ctd_dprintk_crit(
> +					"target %llx already in disconnect state\n",
> +					(emc_ctd_uint64_t)ctd_target->ctd_detect_name_bytes[0]);
> +			}
> +			error =3D 0;
> +			break;
> +		}
> +	}
> +
> +	if (error)
> +		ctd_dprintk_crit("Error\n");
> +
> +	return error;
> +}
> +
> +static int
> +ctd_handle_target_addition(struct emc_ctd_v010_detect *io_detect,
> +				struct ctd_pci_private *ctd_private)
> +{
> +	int i;
> +	int error;
> +	struct ctd_target_info *ctd_target;
> +	struct ctd_host_info *ctd_host;
> +
> +	error =3D -ENOMEM;
> +	ctd_host =3D ctd_private->host_private;
> +
> +	ctd_dprintk("header addr -> %x key -> %llx\n",
> +		io_detect->emc_ctd_detect_header_address,
> +		io_detect->emc_ctd_v010_detect_key);
> +
> +	for (i =3D 0; i < EMCCTD_MAX_ID; i++) {
> +		ctd_target =3D &ctd_host->target[i];
> +
> +		/* detect header address is used to uniquely identify the target
> +		 * for which the connect event has been posted by the server
> +		 * check if this particular target is already recorded with the
> +		 * client check if the recorded target is in the correct state
> +		 * and if not found record this particular target in the list of
> +		 * the detected targets
> +		 */
> +
> +		if (ctd_target->ctd_detect.emc_ctd_v010_detect_key =3D=3D
> +			io_detect->emc_ctd_v010_detect_key) {
> +			error =3D 0;
> +			ctd_dprintk("\n");
> +
> +			scsi_target_unblock(&ctd_target->starget->dev,
> +					SDEV_RUNNING);
> +			ctd_target->ctd_detect.emc_ctd_v010_detect_flags =3D
> +					io_detect->emc_ctd_v010_detect_flags;
> +			break;
> +		}
> +
> +		/* End of list for the recorded targets in the client, so the
> +		 * reported target is a new target being reported by the server
> +		 * thus needs to be added to the list
> +		 */
> +		if (ctd_target->ctd_detect.emc_ctd_v010_detect_flags =3D=3D 0x0) {
> +			error =3D 0;
> +			ctd_dprintk("\n");
> +			ctd_target->ctd_detect =3D *io_detect;
> +			break;
> +		}
> +	}
> +	if (error)
> +		ctd_dprintk_crit("Error\n");
> +
> +	return error;
> +}
> +
> +static int
> +ctd_handle_source_addition(struct emc_ctd_v010_detect *io_detect,
> +				struct ctd_pci_private *ctd_private)
> +{
> +	ctd_dprintk("functionality not supported\n");
> +	return -ENODEV;
> +}
> +
> +static int
> +ctd_handle_detect(struct emc_ctd_v010_detect *io_detect,
> +				struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +
> +	/*
> +	 * We post the detect event in the event queue and return. While
> +	 * ctd_event_thread actually consumes the requests in the event que=
ue.
> +	 * This is done to serialize the consecutive detect requests (disco=
nnect
> +	 * followed by connect).  This mechanism handles the situation when
> +	 * multiple detect comes in a quick succession.  Also, there is a
> +	 * seperate thread and its queue for each adapter, so detect reques=
ts
> +	 * for different adapters shall be handled seperately.
> +	 */
> +	error =3D ctd_post_event((union emc_ctd_v010_message *)io_detect,
> +								ctd_private);
> +
> +	if (!error)
> +		atomic_long_inc(&ctd_private->hw_stats.what_in);
> +
> +	return error;
> +
> +}
> +
> +static void
> +ctd_handle_scsi_command(struct emc_ctd_v010_scsi_command *io_command=
,
> +					struct ctd_pci_private *ctd_private)
> +{
> +	ctd_dprintk_crit("unsupported\n");
> +}
> +
> +static void
> +ctd_handle_scsi_phase(struct emc_ctd_v010_scsi_phase *io_phase,
> +				struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +	unsigned long flags;
> +	struct scsi_cmnd *cmnd;
> +	struct ctd_request_private *request_private;
> +
> +	/* check the phase flag to confirm we have received correct phase m=
sg */
> +	if (io_phase->emc_ctd_v010_scsi_phase_flags &
> +				EMC_CTD_V010_SCSI_PHASE_FLAG_TARGET) {
> +		ctd_dprintk_crit("SCSI_PHASE_FLAG_TARGET not supported\n");
> +		return;
> +	}
> +
> +	if (!(io_phase->emc_ctd_v010_scsi_phase_flags &
> +				EMC_CTD_V010_SCSI_PHASE_FLAG_ABORT)) {
> +		ctd_dprintk_crit("scsi_phase_flags %x invalid\n",
> +			io_phase->emc_ctd_v010_scsi_phase_flags);
> +		return;
> +	}
> +
> +	request_private =3D (struct ctd_request_private *)
> +		((uintptr_t)(io_phase->emc_ctd_v010_scsi_phase_opaque_rx));
> +
> +	error =3D ctd_scsi_response_sanity_check(request_private, ctd_priva=
te);
> +
> +	if (error)
> +		return;
> +
> +	cmnd =3D request_private->cmnd;
> +
> +	ctd_dprintk_crit("SCSI_PHASE_FLAG_ABORT cmnd-> %p request -> %p\n",
> +		cmnd, request_private);
> +
> +	atomic_long_inc(&ctd_private->hw_stats.abort_received);
> +
> +	switch (request_private->io_state) {
> +
> +	case CTD_IO_REQUEST_QUEUED:
> +	case CTD_IO_REQUEST_REQUEUED:
> +		spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +		list_del(&request_private->list);
> +		atomic_long_dec(&ctd_private->hw_stats.active_io_count);
> +
> +		spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +		break;
> +
> +	case CTD_IO_REQUEST_ABORTED:
> +		spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +		list_del(&request_private->list);
> +
> +		spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +
> +	case CTD_IO_REQUEST_REPLY_AWAITED:
> +		scsi_free_ctd_request_private(request_private, ctd_private);
> +		return;
> +
> +	case CTD_IO_REQUEST_FREE:
> +	case CTD_IO_REQUEST_INVALID:
> +	default:
> +		ctd_dprintk_crit("opaque @ %p in unknown state %x\n",
> +			request_private, request_private->io_state);
> +		return;
> +	}
> +
> +	cmnd->host_scribble =3D NULL;
> +	request_private->cmnd =3D NULL;
> +	request_private->io_state =3D CTD_IO_REQUEST_COMPLETED;
> +	scsi_free_ctd_request_private(request_private, ctd_private);
> +
> +	/* error propagation to the SCSI midlayer */
> +	scsi_translate_sam_code(cmnd, SAM_STAT_TASK_ABORTED);
> +	scsi_set_resid(cmnd, scsi_bufflen(cmnd));
> +	cmnd->scsi_done(cmnd);
> +}
> +
> +static void
> +ctd_handle_response(union emc_ctd_v010_message *io_message,
> +				struct ctd_pci_private *ctd_private)
> +{
> +	struct emc_ctd_v010_header *msg_header;
> +
> +	msg_header =3D &io_message->emc_ctd_v010_message_header;
> +
> +	switch (msg_header->emc_ctd_v010_header_what) {
> +
> +	case EMC_CTD_V010_WHAT_DETECT:
> +		ctd_handle_detect((struct emc_ctd_v010_detect *)io_message,
> +						ctd_private);
> +		break;
> +	case EMC_CTD_V010_WHAT_SCSI_COMMAND:
> +		ctd_handle_scsi_command(
> +				(struct emc_ctd_v010_scsi_command *)io_message,
> +				ctd_private);
> +		break;
> +	case EMC_CTD_V010_WHAT_SCSI_PHASE:
> +		ctd_handle_scsi_phase(
> +				(struct emc_ctd_v010_scsi_phase *) io_message,
> +				ctd_private);
> +		break;
> +	case EMC_CTD_V010_WHAT_SCSI_RESPONSE:
> +		ctd_handle_scsi_response(
> +				(struct emc_ctd_v010_scsi_response *)io_message,
> +				ctd_private);
> +		break;
> +	default:
> +		ctd_dprintk_crit("unknown what -> %x ctd_private -> %p",
> +			msg_header->emc_ctd_v010_header_what, ctd_private);
> +	}
> +}
> +
> +
> +static int
> +ctd_scsi_response_sanity_check(struct ctd_request_private *request_p=
rivate,
> +					struct ctd_pci_private *ctd_private)
> +{
> +	int rc;
> +	unsigned long flags;
> +	struct scsi_cmnd *cmnd;
> +	struct ctd_request_private *request, *request_next;
> +	int outstanding_io_count =3D 0;
> +
> +	rc =3D -EFAULT;
> +
> +	/* check if the opaque is within the valid range */
> +	if (!((request_private >=3D ctd_private->io_map) &&
> +		(request_private < ctd_private->io_map_end))) {
> +		ctd_dprintk_crit(
> +			"ERROR request_private -> %p in invalid range\n",
> +				request_private);
> +		goto ctd_scsi_response_sanity_check_complete;
> +	}
> +
> +	if (request_private) {
> +		cmnd =3D request_private->cmnd;
> +		if (cmnd) {
> +			/* check if the back pointer is valid before we declare
> +			 * request sane
> +			 */
> +			if ((request_private =3D=3D (struct ctd_request_private
> +				*)cmnd->host_scribble)) {
> +				rc =3D 0;
> +				goto ctd_scsi_response_sanity_check_complete;
> +			}
> +		}
> +		/* check if the request has already been completed to the SCSI
> +		 * Midlayer
> +		 */
> +		else if ((request_private->io_state =3D=3D
> +				CTD_IO_REQUEST_ABORTED) ||
> +					(request_private->io_state =3D=3D
> +						CTD_IO_REQUEST_REPLY_AWAITED)) {
> +			rc =3D 0;
> +			goto ctd_scsi_response_sanity_check_complete;
> +		}
> +

You don't do any cleanup work at ctd_scsi_response_sanity_check_complet=
e. You
could just reutrn 0 here as well.

> +
> +		ctd_dprintk_crit(
> +			"ERROR cmnd -> %p mismatched request_private -> %p host_scribble =
-> %p requests send -> %ld responses received -> %ld state -> %s\n",
> +				cmnd, request_private,
> +				(cmnd ? cmnd->host_scribble : 0x0),
> +				ctd_private->hw_stats.requests_sent.counter,
> +				ctd_private->hw_stats.responses_received.counter,
> +				(request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_QUEUED ?
> +						"CTD_IO_REQUEST_QUEUED" :
> +				 (request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_REQUEUED ?
> +						"CTD_IO_REQUEST_REQUEUED" :
> +				  (request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_ABORTED ?
> +						"CTD_IO_REQUEST_ABORTED" :
> +				   (request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_FREE ?
> +						"CTD_IO_REQUEST_FREE" :
> +				    (request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_INVALID ?
> +						"CTD_IO_REQUEST_INVALID" :
> +				     (request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_COMPLETED ?
> +						"CTD_IO_REQUEST_COMPLETED" :
> +				      (request_private->io_state =3D=3D
> +					CTD_IO_REQUEST_REPLY_AWAITED ?
> +						"CTD_IO_REQUEST_REPLY_AWAITED" :
> +				       "UNKNOWN"))))))));
> +
> +		spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +		list_for_each_entry_safe(request, request_next,
> +					&ctd_private->aborted_io_list, list) {
> +			if (request =3D=3D request_private) {
> +				ctd_dprintk_crit(
> +					"request_private -> %p in aborted_io_list\n",
> +						request_private);
> +				break;
> +			}
> +		}
> +
> +		list_for_each_entry_safe(request, request_next,
> +					&ctd_private->queued_io_list, list) {
> +			if (request =3D=3D request_private) {
> +				ctd_dprintk_crit(
> +					"request_private -> %p in queued_io_list\n",
> +						request_private);
> +			}
> +			outstanding_io_count++;
> +		}
> +		ctd_dprintk_crit("outstanding_io_count =3D %d\n",
> +				outstanding_io_count);
> +
> +		list_for_each_entry_safe(request, request_next,
> +					&ctd_private->requeued_io_list, list) {
> +			if (request =3D=3D request_private) {
> +				ctd_dprintk_crit(
> +					"request_private -> %p in requeued_io_list\n",
> +						request_private);
> +				break;
> +			}
> +		}
> +
> +		list_for_each_entry_safe(request, request_next,
> +					&ctd_private->io_pool, list) {
> +			if (request =3D=3D request_private) {
> +				ctd_dprintk_crit(
> +					"request_private -> %p in free io_pool\n",
> +						request_private);
> +				break;
> +			}
> +		}
> +
> +		spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +	} else {
> +		ctd_dprintk_crit("ERROR request_private -> NULL\n");
> +	}
> +
> +ctd_scsi_response_sanity_check_complete:
> +	return rc;
> +}
> +
> +static void
> +ctd_handle_scsi_response(struct emc_ctd_v010_scsi_response *io_respo=
nse,
> +			struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +	unsigned long flags;
> +	struct scsi_cmnd *cmnd;
> +	struct ctd_request_private *request_private;
> +	unsigned long long io_stats;
> +
> +	request_private =3D (struct ctd_request_private *)
> +		((uintptr_t)(io_response->emc_ctd_v010_scsi_response_opaque));
> +
> +	error =3D ctd_scsi_response_sanity_check(request_private, ctd_priva=
te);
> +
> +	if (error)
> +		return;
> +
> +	io_stats =3D ctd_read_tsc();
> +
> +	io_stats -=3D request_private->io_start_time;
> +
> +	ctd_private->hw_stats.io_stats[ctd_private->hw_stats.io_stats_index=
++] =3D
> +						io_stats;
> +
> +	if (ctd_private->hw_stats.io_stats_index =3D=3D CTD_MAX_IO_STATS)
> +		ctd_private->hw_stats.io_stats_index =3D 0;
> +	/*
> +	 * check if the IO context is in the aborted IO list
> +	 */
> +
> +	/* Increment the responses_received stats */
> +	atomic_long_inc(&ctd_private->hw_stats.responses_received);
> +
> +	switch (request_private->io_state) {
> +
> +	/*
> +	 * The state of the request is important
> +	 * CTD_IO_REQUEST_QUEUED : cmnd is still alive and valid in kernel
> +	 * CTD_IO_REQUEST_ABORTED : cmnd has already been handled before
> +	 *				the response from the device and
> +	 *				only request needs to be cleaned
> +	 *				up from the abort list
> +	 * CTD_IO_REQUEST_FREE : represents a state which is unhandled (unk=
nown)
> +	 * CTD_IO_REQUEST_REPLY_AWAITED : represents a state where abort
> +	 *			could not be sent by the timeout handler
> +	 * CTD_IO_REQUEST_INVALID : represents a state which is
> +	 *				unhandled (unknown)
> +	 */
> +
> +	case CTD_IO_REQUEST_QUEUED:
> +	case CTD_IO_REQUEST_REQUEUED:
> +		spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +		list_del(&request_private->list);
> +		request_private->io_state =3D CTD_IO_REQUEST_COMPLETED;
> +
> +		spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +		break;
> +
> +	case CTD_IO_REQUEST_ABORTED:
> +		/*
> +		 * cmnd is already disassociated from the request private and IO
> +		 * completed to the SCSI Midlayer by the timeout|abort handler
> +		 * delink the request private from the aborted list and cleanup
> +		 */
> +		spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +		list_del(&request_private->list);
> +		spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +
> +	case CTD_IO_REQUEST_REPLY_AWAITED:
> +		/*
> +		 * return the context back to the io_pool for its reuse
> +		 */
> +		request_private->io_state =3D CTD_IO_REQUEST_COMPLETED;
> +		scsi_free_ctd_request_private(request_private, ctd_private);
> +		/* IO already completed to the Midlayer */
> +		return;
> +
> +	case CTD_IO_REQUEST_FREE:
> +	case CTD_IO_REQUEST_INVALID:
> +	default:
> +		ctd_dprintk_crit(
> +			"opaque @ %p in unknown state %x\n",
> +			request_private, request_private->io_state);
> +		return;
> +
> +	}
> +
> +	/* Decrement active_io_count only when request is still queued. */
> +	atomic_long_dec(&ctd_private->hw_stats.active_io_count);
> +
> +	cmnd =3D request_private->cmnd;
> +
> +	cmnd->result =3D 0;
> +
> +	scsi_translate_sam_code(cmnd,
> +			io_response->emc_ctd_v010_scsi_response_status);
> +
> +	scsi_set_resid(cmnd, scsi_bufflen(cmnd) -
> +			io_response->emc_ctd_v010_scsi_response_data_size);
> +
> +	if (io_response->emc_ctd_v010_scsi_response_flags &
> +			EMC_CTD_V010_SCSI_RESPONSE_FLAG_FAILED) {
> +		ctd_dprintk_crit(
> +			"cmnd =3D %p CTDCM_FAILED channel:%d id:%d lun:%lld] status =3D %=
x\n",
> +			cmnd, cmnd->device->channel, cmnd->device->id,
> +			cmnd->device->lun,
> +			io_response->emc_ctd_v010_scsi_response_status);
> +
> +		set_host_byte(cmnd, DID_ERROR);
> +		if (ctd_debug) {
> +			scsi_print_command(cmnd);
> +			scsi_print_result(cmnd, NULL, FAILED);
> +			scsi_print_sense(cmnd);
> +		}
> +	}
> +	if (io_response->emc_ctd_v010_scsi_response_flags &
> +			EMC_CTD_V010_SCSI_RESPONSE_FLAG_SENSE) {
> +		unsigned char *sense_data;
> +		unsigned char sense_data_length;
> +
> +		sense_data =3D io_response->emc_ctd_scsi_response_extra;
> +		sense_data_length =3D
> +			io_response->emc_ctd_v010_scsi_response_extra_size;
> +
> +		memcpy(cmnd->sense_buffer, sense_data, sense_data_length);
> +
> +		set_driver_byte(cmnd, DRIVER_SENSE);
> +		if (ctd_debug) {
> +			scsi_print_command(cmnd);
> +			scsi_print_result(cmnd, "emcctd sense", SUCCESS);
> +			scsi_print_sense(cmnd);
> +		}
> +	}
> +
> +	if ((io_response->emc_ctd_v010_scsi_response_status =3D=3D
> +						SAM_STAT_TASK_SET_FULL) ||
> +		(io_response->emc_ctd_v010_scsi_response_status =3D=3D
> +							SAM_STAT_BUSY)) {
> +
> +		ctd_dprintk(
> +			"QUEUE DEPTH change for channel:%d id:%d lun:%lld] active io coun=
t =3D %lx\n",
> +			cmnd->device->channel, cmnd->device->id,
> +			cmnd->device->lun,
> +			ctd_private->hw_stats.active_io_count.counter);
> +
> +		scsi_track_queue_full(cmnd->device,
> +			ctd_private->hw_stats.active_io_count.counter);
> +	}
> +
> +
> +	cmnd->host_scribble =3D NULL;
> +
> +	scsi_free_ctd_request_private(request_private, ctd_private);
> +
> +	cmnd->scsi_done(cmnd);
> +}
> +
> +static void
> +ctd_scsi_transfer_info(unsigned char *cmd, unsigned long long *lba,
> +		unsigned int *num, unsigned int *ei_lba)
> +{
> +	*ei_lba =3D 0;
> +
> +	switch (*cmd) {
> +
> +	case VARIABLE_LENGTH_CMD:
> +		*lba =3D (u64)cmd[19] | (u64)cmd[18] << 8 |
> +			(u64)cmd[17] << 16 | (u64)cmd[16] << 24 |
> +			(u64)cmd[15] << 32 | (u64)cmd[14] << 40 |
> +			(u64)cmd[13] << 48 | (u64)cmd[12] << 56;
> +
> +		*ei_lba =3D (u32)cmd[23] | (u32)cmd[22] << 8 |
> +			(u32)cmd[21] << 16 | (u32)cmd[20] << 24;
> +
> +		*num =3D (u32)cmd[31] | (u32)cmd[30] << 8 | (u32)cmd[29] << 16 |
> +			(u32)cmd[28] << 24;
> +		break;
> +
> +	case WRITE_SAME_16:
> +	case WRITE_16:
> +	case READ_16:
> +		*lba =3D (u64)cmd[9] | (u64)cmd[8] << 8 |
> +			(u64)cmd[7] << 16 | (u64)cmd[6] << 24 |
> +			(u64)cmd[5] << 32 | (u64)cmd[4] << 40 |
> +			(u64)cmd[3] << 48 | (u64)cmd[2] << 56;
> +
> +		*num =3D (u32)cmd[13] | (u32)cmd[12] << 8 | (u32)cmd[11] << 16 |
> +			(u32)cmd[10] << 24;
> +		break;
> +	case WRITE_12:
> +	case READ_12:
> +		*lba =3D (u32)cmd[5] | (u32)cmd[4] << 8 | (u32)cmd[3] << 16 |
> +			(u32)cmd[2] << 24;
> +
> +		*num =3D (u32)cmd[9] | (u32)cmd[8] << 8 | (u32)cmd[7] << 16 |
> +			(u32)cmd[6] << 24;
> +		break;
> +	case WRITE_SAME:
> +	case WRITE_10:
> +	case READ_10:
> +	case XDWRITEREAD_10:
> +		*lba =3D (u32)cmd[5] | (u32)cmd[4] << 8 |	(u32)cmd[3] << 16 |
> +			(u32)cmd[2] << 24;
> +
> +		*num =3D (u32)cmd[8] | (u32)cmd[7] << 8;
> +		break;
> +	case WRITE_6:
> +	case READ_6:
> +		*lba =3D (u32)cmd[3] | (u32)cmd[2] << 8 |
> +			(u32)(cmd[1] & 0x1f) << 16;
> +		*num =3D (cmd[4] =3D=3D 0) ? 256 : cmd[4];
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +
> +static int
> +ctd_initiator_validate_sgl(struct scsi_cmnd *cmnd,
> +			   struct emc_ctd_v010_scsi_command *ctd_request,
> +			   struct ctd_pci_private *ctd_private)
> +{
> +	int i;
> +	int error;
> +	struct emc_ctd_v010_sgl *sgl_current;
> +	struct emc_ctd_v010_sgl *sgl_extended;
> +	emc_ctd_uint64_t sgl_count;
> +	unsigned int sgl_buffersize;
> +	unsigned long long lba;
> +	unsigned int num;
> +	unsigned int ei_lba;
> +
> +	lba =3D 0;
> +	num =3D 0;
> +	ei_lba =3D 0;
> +	error =3D -EINVAL;
> +	sgl_count =3D 0;
> +	sgl_extended =3D &ctd_request->emc_ctd_scsi_command_sgl[0];
> +
> +	if (ctd_request->emc_ctd_v010_scsi_command_flags &
> +				EMC_CTD_V010_SCSI_COMMAND_FLAG_ESGL) {
> +		emc_ctd_uint64_t extented_sgl_size;
> +
> +		sgl_current =3D phys_to_virt(
> +			((emc_ctd_uint64_t)sgl_extended->emc_ctd_v010_sgl_paddr_32_63 << =
32) |
> +			((emc_ctd_uint64_t)sgl_extended->emc_ctd_v010_sgl_paddr_0_31 & 0x=
=46FFFFFFF));
> +
> +		extented_sgl_size =3D sgl_extended->emc_ctd_v010_sgl_size;
> +
> +		do_div(extented_sgl_size, sizeof(struct emc_ctd_v010_sgl));
> +
> +		sgl_count =3D extented_sgl_size;
> +	} else {
> +		sgl_current =3D sgl_extended;
> +		while (sgl_current < sgl_extended +
> +				EMC_CTD_V010_SGL_IMMEDIATE_MAX) {
> +			if (sgl_current->emc_ctd_v010_sgl_size =3D=3D 0)
> +				break;
> +
> +			sgl_current++;
> +			sgl_count++;
> +		}
> +		sgl_current =3D sgl_extended;
> +	}
> +
> +	if (scsi_sg_count(cmnd) !=3D sgl_count) {
> +		scsi_print_command(cmnd);
> +		 ctd_dprintk_crit(
> +			 "Mismatched cmnd_sgl_count %d sgl_count =3D %lld sgl_size =3D %d=
\n",
> +			scsi_sg_count(cmnd),
> +			sgl_count, sgl_extended->emc_ctd_v010_sgl_size);
> +	}
> +
> +	if (sgl_count) {
> +		struct scatterlist *cmnd_sg;
> +		int cmnd_sg_count =3D scsi_sg_count(cmnd);
> +
> +		if (cmnd_sg_count > EMC_CTD_V010_SGL_IMMEDIATE_MAX) {
> +			if ((ctd_request->emc_ctd_v010_scsi_command_flags &
> +				EMC_CTD_V010_SCSI_COMMAND_FLAG_ESGL) =3D=3D 0) {
> +				scsi_print_command(cmnd);
> +				ctd_dprintk_crit(
> +					"scsi_sg_count =3D %d but EMC_CTD_V010_SCSI_COMMAND_FLAG_ESGL n=
ot set\n",
> +					scsi_sg_count(cmnd));
> +
> +				cmnd_sg_count =3D EMC_CTD_V010_SGL_IMMEDIATE_MAX;
> +			}
> +		}
> +
> +		scsi_for_each_sg(cmnd, cmnd_sg, cmnd_sg_count, i) {
> +			int cmnd_sg_size;
> +			emc_ctd_uint64_t cmnd_buffer_pfn;
> +			struct page *cmnd_page;
> +			emc_ctd_uint32_t cmnd_offset;
> +			emc_ctd_uint32_t sgl_size;
> +			emc_ctd_uint64_t buffer_pfn;
> +
> +			cmnd_page =3D sg_page(cmnd_sg);
> +			cmnd_buffer_pfn =3D page_to_phys(cmnd_page);
> +			cmnd_sg_size =3D cmnd_sg->length;
> +			cmnd_offset =3D cmnd_sg->offset;
> +
> +
> +			sgl_size =3D (sgl_current + i)->emc_ctd_v010_sgl_size;
> +			buffer_pfn =3D (((emc_ctd_uint64_t)
> +				((sgl_current + i)->emc_ctd_v010_sgl_paddr_32_63) << 32) |
> +				((emc_ctd_uint64_t)((sgl_current + i)->emc_ctd_v010_sgl_paddr_0_=
31) & 0xFFFFFFFF));
> +
> +			if ((sgl_size !=3D cmnd_sg_size) ||
> +					(buffer_pfn !=3D (cmnd_buffer_pfn +
> +							cmnd_offset))) {
> +				scsi_print_command(cmnd);
> +				ctd_dprintk_crit(
> +					"Mismatch @ i =3D %d cmnd_sg_size =3D %d cmnd_buffer_pfn =3D %l=
lx sgl_size =3D %d buffer_pfn =3D %llx\n",
> +					i, cmnd_sg_size, cmnd_buffer_pfn,
> +					sgl_size, buffer_pfn);
> +			}
> +		}
> +		goto ctd_initiator_validate_sgl_end;
> +	}
> +
> +	for (i =3D 0, sgl_buffersize =3D 0; i < sgl_count; i++, sgl_current=
++)
> +		sgl_buffersize +=3D sgl_current->emc_ctd_v010_sgl_size;
> +
> +	if (scsi_bufflen(cmnd) && (sgl_buffersize !=3D scsi_bufflen(cmnd)))=
 {
> +		scsi_print_command(cmnd);
> +		ctd_dprintk_crit("Mismatched buffer size %d %d\n",
> +				scsi_bufflen(cmnd), sgl_buffersize);
> +		goto ctd_initiator_validate_sgl_end;
> +	}
> +
> +	ctd_scsi_transfer_info((unsigned char *)cmnd->cmnd, &lba,
> +				&num, &ei_lba);
> +
> +	if (num && (sgl_buffersize  !=3D (num * 512))) {
> +		scsi_print_command(cmnd);
> +		ctd_dprintk_crit("Mismatched buffer size %d %d\n",
> +			(num * 512), sgl_buffersize);
> +		goto ctd_initiator_validate_sgl_end;
> +	}
> +	error =3D 0;

There is no cleanup done at this label so no need to jump here. Reutrn =
directly
from the jumping position.

> +ctd_initiator_validate_sgl_end:
> +	return error;
> +}
> +
> +static int
> +ctd_initiator_translate_sgl(struct scsi_cmnd *cmnd,
> +			    struct emc_ctd_v010_scsi_command *ctd_request,
> +			    struct ctd_pci_private *ctd_private)
> +{
> +	int i;
> +	int size;
> +	int error;
> +	int sg_count;
> +	int rq_count;
> +	int embedded_sgl_count;
> +	int embedded_sgl_index;
> +	struct ctd_request_private *request_private;
> +	emc_ctd_uint64_t buffer_pfn;
> +
> +	error =3D FAILED;
> +	i =3D size =3D 0;
> +	embedded_sgl_index =3D 0;
> +	embedded_sgl_count =3D EMC_CTD_V010_SGL_IMMEDIATE_MAX;
> +	rq_count =3D 0;
> +
> +	request_private =3D (struct ctd_request_private *)cmnd->host_scribb=
le;
> +	sg_count =3D scsi_sg_count(cmnd);
> +
> +	if (sg_count > embedded_sgl_count) {
> +		struct scatterlist *sg;
> +		struct emc_ctd_v010_sgl *sgl_current;
> +		struct emc_ctd_v010_sgl *sgl_extended;
> +
> +		request_private->sgllist_page_order =3D
> +			get_order((sizeof(struct emc_ctd_v010_sgl) * sg_count));
> +		request_private->sgllist_page =3D
> +			alloc_pages(GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN,
> +				request_private->sgllist_page_order);
> +
> +		if (!request_private->sgllist_page) {
> +			ctd_dprintk_crit("alloc_page failure\n");
> +			goto scsi_initiator_translate_sgl_end;
> +		}
> +
> +		sgl_current =3D (struct emc_ctd_v010_sgl *)
> +			page_address(request_private->sgllist_page);
> +
> +		scsi_for_each_sg(cmnd, sg, sg_count, i) {
> +#if defined(__VMKLNX__)
> +			sgl_current->emc_ctd_v010_sgl_paddr_0_31 =3D
> +					sg->cursgel->addr & 0xFFFFFFFF;
> +			sgl_current->emc_ctd_v010_sgl_paddr_32_63 =3D
> +						sg->cursgel->addr >> 32;
> +			sgl_current->emc_ctd_v010_sgl_size =3D sg_dma_len(sg);
> +#else
> +			struct page *page;
> +
> +			page =3D sg_page(sg);
> +			buffer_pfn =3D page_to_phys(page);
> +			size +=3D sg->length;
> +
> +			sgl_current->emc_ctd_v010_sgl_paddr_0_31 =3D
> +				(buffer_pfn + sg->offset) & 0xFFFFFFFF;
> +			sgl_current->emc_ctd_v010_sgl_paddr_32_63 =3D
> +					(buffer_pfn + sg->offset) >> 32;
> +			sgl_current->emc_ctd_v010_sgl_size =3D sg->length;
> +#endif
> +			sgl_current++;
> +			rq_count++;
> +		}
> +		sgl_extended =3D &ctd_request->emc_ctd_scsi_command_sgl[0];
> +		buffer_pfn =3D page_to_phys(request_private->sgllist_page);
> +
> +		sgl_extended->emc_ctd_v010_sgl_paddr_0_31 =3D
> +					buffer_pfn & 0xFFFFFFFF;
> +		sgl_extended->emc_ctd_v010_sgl_paddr_32_63 =3D buffer_pfn >> 32;
> +		sgl_extended->emc_ctd_v010_sgl_size =3D
> +				rq_count * sizeof(struct emc_ctd_v010_sgl);
> +		ctd_request->emc_ctd_v010_scsi_command_flags |=3D
> +					EMC_CTD_V010_SCSI_COMMAND_FLAG_ESGL;
> +	} else {
> +		struct scatterlist *sg;
> +		struct emc_ctd_v010_sgl *sgl_current;
> +
> +		sgl_current =3D &ctd_request->emc_ctd_scsi_command_sgl[0];
> +
> +		scsi_for_each_sg(cmnd, sg, sg_count, i) {
> +#if defined(__VMKLNX__)
> +			sgl_current->emc_ctd_v010_sgl_paddr_0_31 =3D
> +					sg->cursgel->addr & 0xFFFFFFFF;
> +			sgl_current->emc_ctd_v010_sgl_paddr_32_63 =3D
> +						sg->cursgel->addr >> 32;
> +			sgl_current->emc_ctd_v010_sgl_size =3D sg_dma_len(sg);
> +#else
> +			struct page *page;
> +
> +			size +=3D sg->length;
> +			page =3D sg_page(sg);
> +			buffer_pfn =3D page_to_phys(page);
> +
> +			sgl_current->emc_ctd_v010_sgl_paddr_0_31 =3D
> +				(buffer_pfn + sg->offset) & 0xFFFFFFFF;
> +			sgl_current->emc_ctd_v010_sgl_paddr_32_63 =3D
> +					(buffer_pfn + sg->offset) >> 32;
> +			sgl_current->emc_ctd_v010_sgl_size =3D sg->length;
> +#endif
> +
> +			sgl_current++;
> +			rq_count++;
> +		}
> +	}
> +	error =3D SUCCESS;
> +
> +	if (ctd_debug)
> +		ctd_initiator_validate_sgl(cmnd, ctd_request, ctd_private);
> +
> +scsi_initiator_translate_sgl_end:
> +	return error;
> +}
> +
> +
> +void
> +ctd_initiator_translate_lun(struct scsi_cmnd *cmnd,
> +			    struct emc_ctd_v010_scsi_command *ctd_request)
> +{
> +
> +	int i;
> +	union ctd_scsi_lun {
> +		emc_ctd_uint64_t scsi_lun_64;
> +		emc_ctd_uint8_t scsi_lun_8[8];
> +	} ctd_scsi_lun_conversion;
> +
> +	ctd_scsi_lun_conversion.scsi_lun_64 =3D cpu_to_be64(cmnd->device->l=
un);
> +	for (i =3D 0; i < sizeof(ctd_scsi_lun_conversion); i++) {
> +		ctd_request->emc_ctd_v010_scsi_command_lun[i] =3D
> +				ctd_scsi_lun_conversion.scsi_lun_8[i];
> +	}
> +}
> +
> +static int
> +ctd_initiator_translate_request(struct scsi_cmnd *cmnd,
> +				struct emc_ctd_v010_scsi_command *ctd_request,
> +				struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +	struct ctd_dev_info *ctd_device;
> +	struct ctd_request_private *request_private;
> +	int scsi_cdb_size;
> +
> +	error =3D FAILED;
> +	request_private =3D NULL;
> +	ctd_device =3D cmnd->device->hostdata;
> +
> +	if (!(ctd_device->ctd_target_detect->emc_ctd_v010_detect_flags &
> +				EMC_CTD_V010_DETECT_FLAG_SCSI_TARGET)) {
> +		goto scsi_initiator_translate_request_end;
> +	}
> +	memset(ctd_request, 0x0, sizeof(struct emc_ctd_v010_scsi_command));
> +
> +	ctd_request->emc_ctd_scsi_command_header_address =3D
> +		ctd_device->ctd_target_detect->emc_ctd_detect_header_address;
> +	ctd_request->emc_ctd_v010_scsi_command_header.emc_ctd_v010_header_m=
inor =3D
> +					EMCCTD_V010_PROTOCOL_MINOR_VERSION;
> +	ctd_request->emc_ctd_v010_scsi_command_header.emc_ctd_v010_header_w=
hat =3D
> +						EMC_CTD_V010_WHAT_SCSI_COMMAND;
> +	ctd_request->emc_ctd_v010_scsi_command_flags |=3D
> +			((cmnd->sc_data_direction =3D=3D DMA_FROM_DEVICE) ?
> +				EMC_CTD_V010_SCSI_COMMAND_FLAG_SOURCE :
> +					((cmnd->sc_data_direction =3D=3D
> +						DMA_TO_DEVICE) ?  0 : 0));
> +
> +	request_private =3D ctd_acquire_request(ctd_private);
> +
> +	if (request_private =3D=3D NULL) {
> +		ctd_dprintk_crit("ctd_acquire_request failure\n");
> +		goto scsi_initiator_translate_request_end;
> +	}
> +
> +	request_private->cmnd =3D cmnd;
> +
> +	cmnd->host_scribble =3D (unsigned char *)request_private;
> +
> +	ctd_request->emc_ctd_v010_scsi_command_data_size =3D scsi_bufflen(c=
mnd);
> +
> +	ctd_request->emc_ctd_v010_scsi_command_opaque =3D
> +				(uintptr_t)request_private;
> +
> +	ctd_initiator_translate_lun(cmnd, ctd_request);
> +
> +	scsi_cdb_size =3D cmnd->cmd_len;
> +
> +	if (scsi_cdb_size <=3D
> +			sizeof(ctd_request->emc_ctd_v010_scsi_command_cdb)) {
> +		memcpy(ctd_request->emc_ctd_v010_scsi_command_cdb,
> +						cmnd->cmnd, scsi_cdb_size);
> +	} else {
> +		ctd_dprintk_crit("unsupported scsi cdb size =3D %d\n",
> +				scsi_cdb_size);
> +		goto scsi_initiator_translate_request_end;
> +	}
> +
> +	error =3D ctd_initiator_translate_sgl(cmnd, ctd_request, ctd_privat=
e);
> +
> +scsi_initiator_translate_request_end:
> +	if (error =3D=3D FAILED) {
> +		cmnd->host_scribble =3D NULL;
> +		if (request_private) {
> +			scsi_free_ctd_request_private(request_private,
> +								ctd_private);
> +		}
> +	}
> +	return error;
> +}
> +
> +
> +static int
> +ctd_hw_execute_command(struct scsi_cmnd *cmnd,
> +		struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +	unsigned long flags;
> +	struct emc_ctd_v010_scsi_command ctd_request;
> +
> +	error =3D ctd_initiator_translate_request(cmnd, &ctd_request,
> +							ctd_private);
> +
> +	if (error =3D=3D SUCCESS) {
> +		struct ctd_request_private *request_private;
> +
> +		request_private =3D
> +			(struct ctd_request_private *)cmnd->host_scribble;
> +
> +		/* lock ordering ... io_mgmt_lock followed by isr_lock
> +		 * ensures that request placed in legitimate queue ...
> +		 * so that response finds in the correct queue
> +		 */
> +		spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +		request_private->io_start_time =3D ctd_read_tsc();
> +
> +		error =3D ctd_hw_enqueue_request(
> +				(union emc_ctd_v010_message *)&ctd_request,
> +				ctd_private);
> +		if (error =3D=3D SUCCESS) {
> +			list_add_tail(&request_private->list,
> +					&ctd_private->queued_io_list);
> +			atomic_long_inc(&ctd_private->hw_stats.requests_sent);
> +			atomic_long_inc(&ctd_private->hw_stats.active_io_count);
> +		}
> +
> +		spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +
> +		if (error !=3D SUCCESS) {
> +			ctd_dprintk_crit("ctd_hw_enqueue_request error\n");
> +			scsi_free_ctd_request_private(
> +					(struct ctd_request_private *)
> +						(uintptr_t)
> +						(ctd_request.emc_ctd_v010_scsi_command_opaque),
> +							ctd_private);
> +		}
> +	}
> +
> +	return error;
> +}
> +
> +static int
> +ctd_hw_enqueue_request(union emc_ctd_v010_message *ctd_request,
> +			struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +	unsigned long flags;
> +	union emc_ctd_v010_message *ctd_request_block;
> +
> +	spin_lock_irqsave(&ctd_private->isr_lock, flags);
> +
> +	/*
> +	 * check if any space is available in the array
> +	 */
> +	ctd_request_block =3D
> +		((((ctd_private->request_producer_index + 1) %
> +		   ctd_private->pci_request_queue_size) =3D=3D
> +			ctd_private->request_consumer_index) ?
> +				NULL :
> +				(ctd_private->pci_request_array +
> +					ctd_private->request_producer_index));
> +
> +
> +	error =3D (ctd_request_block ? SUCCESS : FAILED);
> +
> +	if (error =3D=3D SUCCESS) {
> +		*ctd_request_block =3D *ctd_request;
> +
> +		ctd_private->request_producer_index =3D
> +			((ctd_private->request_producer_index + 1) %
> +				ctd_private->pci_request_queue_size);
> +
> +	}
> +
> +	spin_unlock_irqrestore(&ctd_private->isr_lock, flags);
> +
> +	return error;
> +}
> +
> +static int
> +ctd_hw_dequeue_response(union emc_ctd_v010_message *ctd_response,
> +			struct ctd_pci_private *ctd_private)
> +{
> +	int rc;
> +	unsigned long flags;
> +	union emc_ctd_v010_message *ctd_response_block;
> +
> +	/* protect ourselves from another instance */
> +	spin_lock_irqsave(&ctd_private->isr_lock, flags);
> +
> +	ctd_response_block =3D
> +		((ctd_private->response_consumer_index =3D=3D
> +			ctd_private->response_producer_index) ?  NULL :
> +				(ctd_private->pci_response_array +
> +					ctd_private->response_consumer_index));
> +
> +	rc =3D ctd_response_block ? SUCCESS : FAILED;
> +
> +	if (rc =3D=3D SUCCESS) {
> +		*ctd_response =3D *ctd_response_block;
> +		ctd_private->response_consumer_index =3D
> +			((ctd_private->response_consumer_index + 1) %
> +			 ctd_private->pci_response_queue_size);
> +	} else {
> +		ctd_check_error_condition(ctd_private->pci_dev);
> +	}
> +
> +	spin_unlock_irqrestore(&ctd_private->isr_lock, flags);
> +
> +	return rc;
> +
> +}
> +
> +static int
> +ctd_xmit_command(struct scsi_cmnd *cmnd,
> +			struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +
> +	cmnd->result =3D DID_OK;
> +	error =3D ctd_hw_execute_command(cmnd, ctd_private);
> +	return error;
> +}
> +
> +
> +static int
> +ctd_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done)(struct scs=
i_cmnd *))
> +{
> +	int error;
> +	struct ctd_host_info *ctd_host;
> +	struct ctd_pci_private *ctd_private;
> +
> +	error =3D 0;
> +	ctd_host =3D shost_priv(cmnd->device->host);
> +	ctd_private =3D pci_get_drvdata(ctd_host->pci_dev);
> +
> +	switch (ctd_private->hw_state) {
> +
> +	case CTD_HW_STATE_INITIALIZED:
> +		cmnd->scsi_done =3D done;
> +		if (ctd_xmit_command(cmnd, ctd_private) =3D=3D SUCCESS)
> +			break;
> +
> +	case CTD_HW_STATE_DISABLED:
> +		cmnd->scsi_done =3D done;
> +		scsi_translate_sam_code(cmnd, SAM_STAT_TASK_ABORTED);
> +		scsi_set_resid(cmnd, scsi_bufflen(cmnd));
> +		cmnd->scsi_done(cmnd);
> +		break;
> +	default:
> +		error =3D SCSI_MLQUEUE_HOST_BUSY;
> +	}
> +
> +	return error;
> +}
> +
> +static int
> +ctd_abort_handler(struct scsi_cmnd *cmnd)
> +{
> +	ctd_dprintk_crit("SCSI cmnd -> %p ERROR\n",
> +			cmnd);
> +	return SUCCESS;
> +}
> +
> +
> +static int
> +ctd_target_alloc(struct scsi_target *starget)
> +{
> +	int error;
> +	struct ctd_target_info *ctd_target;
> +	struct ctd_host_info *ctd_host;
> +
> +	error =3D -ENODEV;
> +	ctd_host =3D shost_priv(dev_to_shost(&starget->dev));
> +
> +	ctd_dprintk("starget -> %p id -> %x\n",
> +		starget, starget->id);
> +
> +	ctd_target =3D &ctd_host->target[starget->id];
> +
> +	/* check for the connection status in the detect flag
> +	 * also check if the target already registered with the SCSI midlay=
er
> +	 */
> +	if (ctd_target->starget =3D=3D NULL &&
> +			(ctd_target->ctd_detect.emc_ctd_v010_detect_flags &
> +			 EMC_CTD_V010_DETECT_FLAG_SCSI_TARGET)) {
> +		error =3D 0;
> +		ctd_target->starget =3D starget;
> +		starget->hostdata =3D ctd_target;
> +	} else {
> +		if (ctd_target->starget !=3D starget) {
> +			ctd_dprintk_crit(
> +				"failure ctd_target->starget %p and starget %p dissimilar\n",
> +				ctd_target->starget, starget);
> +		} else {
> +			ctd_dprintk_crit("failure starget %p unexpected\n",
> +				starget);
> +		}
> +	}
> +
> +	return error;
> +}
> +
> +void
> +ctd_target_destroy(struct scsi_target *starget)
> +{
> +	int i;
> +	int error;
> +	struct ctd_target_info *ctd_target;
> +	struct ctd_host_info *ctd_host;
> +
> +	error =3D -ENODEV;
> +	ctd_host =3D shost_priv(dev_to_shost(&starget->dev));
> +
> +	ctd_dprintk_crit("starget @ id =3D %x\n", starget->id);
> +
> +	for (i =3D 0; i < EMCCTD_MAX_ID; i++) {
> +		ctd_target =3D &ctd_host->target[i];
> +		if (ctd_target->starget =3D=3D starget) {
> +			ctd_target->starget =3D NULL;
> +			error =3D 0;
> +			break;
> +		}
> +	}
> +
> +	if (error) {
> +		ctd_dprintk_crit("failure for starget @ id =3D %x\n",
> +				starget->id);
> +	}
> +}
> +
> +static int
> +ctd_slave_configure(struct scsi_device *sdevice)
> +{
> +	int error;
> +	struct ctd_dev_info *ctd_device;
> +	struct ctd_host_info *ctd_host;
> +
> +	error =3D 0;
> +	ctd_host =3D shost_priv(sdevice->host);
> +	ctd_device =3D sdevice->hostdata;
> +
> +	/* tune the block layer to generate timout
> +	 * for the requests queued and reply is awaited
> +	 */
> +	blk_queue_rq_timeout(sdevice->request_queue, EMCCTD_REQUEST_TIMEOUT=
);
> +

static int ctd_slave_configure(struct scsi_device *sdev)
{
=09
	/* tune the block layer to generate timout
	 * for the requests queued and reply is awaited
	 */
	blk_queue_rq_timeout(sdevice->request_queue, EMCCTD_REQUEST_TIMEOUT);
}

> +	return error;
> +}
> +
> +
> +
> +static int
> +ctd_slave_alloc(struct scsi_device *sdev)
> +{
> +	int error;
> +	struct ctd_host_info *ctd_host;
> +	struct ctd_target_info *ctd_target;
> +	struct ctd_dev_info *ctd_device;
> +
> +	error =3D -ENOMEM;
> +	ctd_host =3D shost_priv(sdev->host);
> +	sdev->host->max_cmd_len =3D EMCCTD_V010_MAX_CDB_SIZE;
> +
> +	ctd_device =3D (struct ctd_dev_info *)
> +			kzalloc(sizeof(struct ctd_dev_info), GFP_ATOMIC);

Please don't cast the return value of kzalloc()

> +	if (ctd_device =3D=3D NULL)

		return -ENOMEM;

> +		goto ctd_slave_alloc_end;
> +
> +	ctd_target =3D &ctd_host->target[sdev->id];
> +	if (ctd_target->starget)
> +		ctd_device->ctd_target_detect =3D &ctd_target->ctd_detect;
> +
> +	if (ctd_device->ctd_target_detect) {
> +		error =3D 0;
> +		ctd_device->ctd_host =3D ctd_host;
> +		ctd_device->ctd_target =3D ctd_target;
> +		sdev->hostdata =3D ctd_device;
> +		queue_flag_set_unlocked(QUEUE_FLAG_BIDI, sdev->request_queue);
> +	} else {
> +		kfree(ctd_device);
> +		error =3D -ENODEV;
> +	}
> +
> +ctd_slave_alloc_end:
> +
> +	if (error) {
> +		ctd_dprintk_crit("channel =3D %x id=3D %x error =3D %x\n",
> +				sdev->channel, sdev->id, error);
> +	}
> +	return error;
> +}
> +
> +static void
> +ctd_slave_destroy(struct scsi_device *sdev)
> +{
> +	struct ctd_dev_info *dev_info;
> +
> +	dev_info =3D sdev->hostdata;
> +	kfree(dev_info);
> +}
> +
> +static enum blk_eh_timer_return
> +ctd_timeout_handler(struct scsi_cmnd *cmd)
> +{
> +	int requeue_error;
> +	unsigned long flags;
> +	enum blk_eh_timer_return error;
> +	struct ctd_host_info *ctd_host;
> +	struct ctd_pci_private *ctd_private;
> +	struct ctd_request_private *request;

This variable's name is a bit of confusing (struct request *request ;-)=
=2E
Maybe ctd_privreq?

> +	unsigned long long tsc_val;
> +
> +	requeue_error =3D FAILED;
> +	error =3D BLK_EH_NOT_HANDLED;
> +	ctd_host =3D shost_priv(cmd->device->host);
> +	ctd_private =3D pci_get_drvdata(ctd_host->pci_dev);
> +
> +
> +	request =3D (struct ctd_request_private *)cmd->host_scribble;
> +
> +	tsc_val =3D ctd_read_tsc();
> +
> +	tsc_val -=3D request->io_start_time;
> +
> +	ctd_dprintk_crit("cmnd -> %p request -> %p, tsc -> %lld\n",
> +			cmd, request, tsc_val);
> +
> +	spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +	if (request && request->io_timeout < EMCCTD_MAX_RETRY) {

The following block is a bit long and therefore it's hard to spot an ev=
entual
error of handling the io_mgmt_lock. Can't it be factored out in a helpe=
r
function?

> +		struct ctd_dev_info *ctd_device;
> +
> +		switch (request->io_state) {
> +
> +		/* check if the IO in the queued_io_list */
> +		case CTD_IO_REQUEST_QUEUED:
> +		/* check if the IO is already requeued */
> +		case CTD_IO_REQUEST_REQUEUED:
> +			/* remove the old IO context from the requeued_io_list
> +			 * or queued_io_list
> +			 */
> +			list_del(&request->list);
> +			atomic_long_dec(&ctd_private->hw_stats.active_io_count);
> +
> +			ctd_device =3D cmd->device->hostdata;
> +
> +			if (!(ctd_device->ctd_target_detect->emc_ctd_v010_detect_flags &
> +				EMC_CTD_V010_DETECT_FLAG_SCSI_TARGET)) {
> +				ctd_dprintk_crit("device diconnected\n");
> +			} else {
> +				union emc_ctd_v010_message ctd_message;
> +				struct emc_ctd_v010_scsi_phase *ctd_phase;
> +
> +				memset(&ctd_message, 0x0,
> +					sizeof(union emc_ctd_v010_message));
> +				ctd_phase =3D
> +					(struct emc_ctd_v010_scsi_phase *) &
> +						ctd_message.emc_ctd_v010_message_scsi_phase;
> +
> +				/* Need to acertain if this is how an IO is
> +				 * aborted by the  specification
> +				 */
> +
> +				/*
> +				 * OPT-438489  the phase flag needs to be
> +				 * initialized with PHASE_FLAG_TARGET If  EMC
> +				 * CTD V010 SCSI PHASE FLAG TARGET is set, the
> +				 * message receiver is the target, otherwise the
> +				 * message receiver is the initiator. If EMC CTD
> +				 * V010 SCSI PHASE FLAG ABORT is set, the SCSI
> +				 * command is aborted.
> +				 */
> +				ctd_phase->emc_ctd_v010_scsi_phase_flags =3D
> +					EMC_CTD_V010_SCSI_PHASE_FLAG_ABORT |
> +					EMC_CTD_V010_SCSI_PHASE_FLAG_TARGET;
> +
> +				ctd_phase->emc_ctd_v010_scsi_phase_opaque_tx =3D
> +							(uintptr_t)request;
> +				ctd_phase->emc_ctd_v010_scsi_phase_opaque_rx =3D
> +									(-1);
> +				ctd_phase->emc_ctd_scsi_phase_header_what =3D
> +						EMC_CTD_V010_WHAT_SCSI_PHASE;
> +				ctd_phase->emc_ctd_scsi_phase_header_minor =3D
> +					EMCCTD_V010_PROTOCOL_MINOR_VERSION;
> +				ctd_phase->emc_ctd_scsi_phase_header_address =3D
> +					ctd_device->ctd_target_detect->emc_ctd_detect_header_address;
> +
> +				requeue_error =3D
> +					ctd_hw_enqueue_request(&ctd_message,
> +								ctd_private);
> +			}
> +
> +
> +			if (requeue_error !=3D SUCCESS) {
> +				/* add the IO context to requeued_io_list */
> +				/* Client would try to abort the request in next
> +				 * timeout (after 20 seconds)
> +				 */
> +				request->io_state =3D CTD_IO_REQUEST_REQUEUED;
> +				list_add_tail(&request->list,
> +						&ctd_private->requeued_io_list);
> +				request->io_timeout++;
> +				error =3D BLK_EH_RESET_TIMER;
> +			} else {
> +				request->cmnd =3D NULL;
> +				cmd->host_scribble =3D NULL;
> +
> +				request->io_state =3D CTD_IO_REQUEST_ABORTED;
> +				request->purge_lifetime =3D
> +					jiffies + EMCCTD_OPAQUE_PURGE_WAITTIME;
> +				list_add_tail(&request->list,
> +						&ctd_private->aborted_io_list);
> +				atomic_long_inc(&ctd_private->hw_stats.abort_sent);
> +
> +				/* error propagation to the SCSI midlayer */
> +				scsi_translate_sam_code(cmd,
> +						SAM_STAT_TASK_ABORTED);
> +				scsi_set_resid(cmd, scsi_bufflen(cmd));
> +
> +				/* indicate no more requeue of this particular
> +				 * IO is needed
> +				 */
> +				error =3D BLK_EH_HANDLED;
> +			}
> +			break;
> +
> +		default:
> +			ctd_dprintk_crit(
> +				"request @ %p in unexpected state %x\n",
> +				request, request->io_state);
> +			break;
> +		}
> +	} else if (request) {
> +		ctd_dprintk_crit("cmd %p timeout completed io_state %x\n",
> +				cmd, request->io_state);
> +
> +		/* remove the old IO context from the requeued_io_list */
> +		list_del(&request->list);
> +
> +		/*
> +		 * break the context between the cmnd and the request and
> +		 * request on the requeue_io_list cannot be reused until
> +		 * server replies for the same
> +		 */
> +		request->cmnd =3D NULL;
> +		cmd->host_scribble =3D NULL;
> +
> +		/* error propagation to the SCSI midlayer */
> +		scsi_translate_sam_code(cmd, SAM_STAT_TASK_ABORTED);
> +		scsi_set_resid(cmd, scsi_bufflen(cmd));
> +
> +		/* we can deallocate the context only once we receive
> +		 * any reply from the server
> +		 */
> +		request->io_state =3D CTD_IO_REQUEST_REPLY_AWAITED;
> +
> +		/* indicate no more requeue of this particular IO is needed */
> +		error =3D BLK_EH_HANDLED;
> +	} else {
> +		ctd_dprintk_crit(
> +			"cmnd -> %p request -> NULL error !!!\n", cmd);
> +	}
> +
> +	spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +
> +	return error;
> +}
> +
> +
> +static int
> +ctd_ITnexus_handler(struct ctd_pci_private *ctd_private)
> +{
> +	int i;
> +	int error;
> +	struct ctd_target_info *ctd_target;
> +	struct ctd_host_info *ctd_host;
> +
> +	error =3D 0;
> +
> +	ctd_host =3D (struct ctd_host_info *)ctd_private->host_private;
> +
> +	ctd_dprintk_crit("ctd_private -> %p\n", ctd_private);
> +
> +	for (i =3D 0; i < EMCCTD_MAX_ID; i++) {
> +		union emc_ctd_v010_message ctd_message;
> +		struct emc_ctd_v010_detect *ctd_detect;
> +
> +		ctd_target =3D &ctd_host->target[i];
> +
> +		switch (ctd_target->detect_completed) {
> +
> +		case EMCCTD_TARGET_DETECT_NOT_COMPLETED:
> +			if (!ctd_target->ctd_detect.emc_ctd_v010_detect_flags)
> +				break;
> +
> +			/* The id defined by the SCSI Midlayer should match the
> +			 * index as this routine is indirectly invoked by the
> +			 * delayed work mechanism
> +			 */
> +
> +			ctd_dprintk_crit("ctd_target -> %p index =3D %x\n",
> +					ctd_target, i);
> +			ctd_dprintk_crit("key -> %llx header -> %x\n",
> +				ctd_target->ctd_detect.emc_ctd_v010_detect_key,
> +				ctd_target->ctd_detect.emc_ctd_detect_header_address);
> +
> +			memset(&ctd_message, 0x0,
> +					sizeof(union emc_ctd_v010_message));
> +
> +			ctd_detect =3D &ctd_message.emc_ctd_v010_message_detect;
> +			ctd_detect->emc_ctd_v010_detect_flags =3D 0x0;
> +			ctd_detect->emc_ctd_v010_detect_key =3D
> +				ctd_target->ctd_detect.emc_ctd_v010_detect_key;
> +			ctd_detect->emc_ctd_detect_header_what =3D
> +				EMC_CTD_V010_WHAT_DETECT;
> +			ctd_detect->emc_ctd_detect_header_minor =3D
> +				EMCCTD_V010_PROTOCOL_MINOR_VERSION;
> +			ctd_detect->emc_ctd_detect_header_address =3D
> +				ctd_target->ctd_detect.emc_ctd_detect_header_address;
> +
> +			if (ctd_hw_enqueue_request(&ctd_message,
> +						ctd_private) =3D=3D SUCCESS) {
> +				ctd_dprintk_crit("ctd_target -> %p\n",
> +						ctd_target);
> +				ctd_target->detect_completed =3D
> +					EMCCTD_TARGET_DETECT_COMPLETED;
> +
> +				atomic_long_inc(
> +					&ctd_private->hw_stats.what_out);
> +			} else {
> +				ctd_dprintk_crit(
> +					"ctd_target -> %p ctd_hw_enqueue_request failure\n",
> +					ctd_target);
> +				error =3D -EAGAIN;
> +				break;
> +			}
> +
> +		case EMCCTD_TARGET_DETECT_COMPLETED:
> +			/* Disconnect case ... we need to remove the associated
> +			 * objects from SCSI midlayer
> +			 */
> +			if (!ctd_target->ctd_detect.emc_ctd_v010_detect_flags) {
> +				ctd_dprintk_crit("ctd_target -> %p\n",
> +						ctd_target);
> +
> +				ctd_clear_io_queue(ctd_private);
> +
> +				if (ctd_target->starget) {
> +				/* the following attempts to clean the SCSI
> +				 * midlayer objects
> +				 */
> +					scsi_target_block(
> +						&ctd_target->starget->dev);
> +					scsi_target_unblock(
> +						&ctd_target->starget->dev,
> +						SDEV_TRANSPORT_OFFLINE);
> +					/*
> +					 * Target object might still be active
> +					 * in case its not reaped completely (as
> +					 * with LVM) thus might be reused when
> +					 * the link reconnects back (OPT 443532)
> +					 */
> +					scsi_remove_target(
> +						&ctd_target->starget->dev);
> +				} else {
> +					ctd_dprintk_crit(
> +						"starget already null\n");
> +				}
> +
> +				/* declare the link dead and buried */
> +				ctd_target->detect_completed =3D
> +					EMCCTD_TARGET_DETECT_NOT_COMPLETED;
> +				memset(&ctd_target->ctd_detect, 0x0,
> +					sizeof(struct emc_ctd_v010_detect));
> +
> +				wake_up(&lun_discovery_event_barrier);
> +			}
> +			/* Connect case ... need to scan and create the needed
> +			 * objects in the SCSI midlayer
> +			 */
> +			else {
> +				ctd_dprintk_crit("ctd_target -> %p\n",
> +						ctd_target);
> +				scsi_scan_target(&ctd_host->shost->shost_gendev,
> +						0, i, SCAN_WILD_CARD, 1);
> +				lun_discovery_complete =3D 1;
> +				wake_up(&lun_discovery_event_barrier);
> +			}
> +			break;
> +		default:
> +			ctd_dprintk_crit("ctd_target -> %p detect unknown -> %x\n",
> +				ctd_target, ctd_target->detect_completed);
> +	}
> +	}
> +
> +	return error;
> +}
> +
> +/* This function posts the detect event into adapter specific list *=
/
> +static int
> +ctd_post_event(union emc_ctd_v010_message *io_msg,
> +		struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +	struct ctd_event_io_element *event;
> +
> +	error =3D -ENOMEM;
> +
> +	event =3D (struct ctd_event_io_element *)
> +			kzalloc(sizeof(struct ctd_event_io_element),
> +								GFP_ATOMIC);

No cast for kzalloc() return

> +	if (event) {
> +		error =3D 0;
> +		event->io_msg =3D *io_msg;
> +		spin_lock(&ctd_private->event_io_lock);
> +		list_add_tail(&event->list, &ctd_private->event_io_list);
> +		spin_unlock(&ctd_private->event_io_lock);
> +	} else {
> +		ctd_dprintk_crit("kzalloc failure\n");

Please no out of memory error messages.

> +	}
> +	return error;
> +}
> +
> +/* Thread Handler Function. This consumes the events posted into its=
 queue, and
> + * takes respective action
> + */
> +static int
> +ctd_event_handler(void *ctd_thread_args)
> +{
> +	struct ctd_event_io_element *event;
> +	struct ctd_pci_private *ctd_private;
> +
> +	ctd_private =3D (struct ctd_pci_private *)ctd_thread_args;
> +
> +	while (!kthread_should_stop()) {
> +		schedule_timeout_interruptible(HZ);
> +
> +		event =3D NULL;
> +
> +		spin_lock(&ctd_private->event_io_lock);
> +		if (!list_empty(&ctd_private->event_io_list)) {
> +			event =3D list_first_entry(&ctd_private->event_io_list,
> +					struct ctd_event_io_element, list);
> +			list_del(&event->list);
> +		}
> +		spin_unlock(&ctd_private->event_io_lock);
> +
> +
> +		if (event) {
> +			int error;
> +			emc_ctd_uint8_t what;
> +			union emc_ctd_v010_message *io_msg;
> +			struct emc_ctd_v010_detect *io_detect;
> +
> +			io_msg =3D &event->io_msg;
> +			what =3D io_msg->emc_ctd_scsi_message_header_what;
> +
> +			if (what !=3D EMC_CTD_V010_WHAT_DETECT) {
> +				ctd_dprintk_crit("event -> %p what -> %x\n",
> +						event, what);
> +			} else {
> +				error =3D -ENODEV;
> +				io_detect =3D
> +					&io_msg->emc_ctd_v010_message_detect;
> +
> +				if (io_detect->emc_ctd_v010_detect_flags =3D=3D
> +								0x0) {
> +					error =3D ctd_handle_disconnect(
> +							io_detect, ctd_private);
> +				} else {
> +					if (io_detect->emc_ctd_v010_detect_flags &
> +							EMC_CTD_V010_DETECT_FLAG_SCSI_TARGET) {
> +						ctd_dprintk(
> +							"header addr -> %x key -> %llx\n",
> +							io_detect->emc_ctd_detect_header_address,
> +							io_detect->emc_ctd_v010_detect_key);
> +						error =3D ctd_handle_target_addition(io_detect,
> +								ctd_private);
> +					}
> +					if (io_detect->emc_ctd_v010_detect_flags &
> +							EMC_CTD_V010_DETECT_FLAG_SCSI_INITIATOR) {
> +						ctd_dprintk("\n");
> +						error =3D ctd_handle_source_addition(io_detect,
> +								ctd_private);
> +					}
> +				}
> +				if (!error) {
> +					int retry =3D EMCCTD_DETECT_RETRY_MAX;
> +
> +					error =3D ctd_ITnexus_handler(ctd_private);
> +					/* In case of ITnexus_handler failure,
> +					 * pause for 2 seconds before retrying
> +					 * the operation again
> +					 */
> +					while (error && retry) {
> +						schedule_timeout_interruptible(HZ * 2);
> +						error =3D ctd_ITnexus_handler(ctd_private);
> +						retry--;
> +					} while (error && retry);
> +
> +				}
> +			}
> +			kfree(event);
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int
> +ctd_init_event_thread(struct ctd_pci_private *ctd_private)
> +{
> +	int error;
> +
> +	INIT_LIST_HEAD(&ctd_private->event_io_list);
> +	spin_lock_init(&ctd_private->event_io_lock);
> +
> +	/* Create the daemon thread to handle detect requests */
> +	ctd_private->ctd_event_thread =3D kthread_create(ctd_event_handler,
> +				(void *)ctd_private, "emcctd_event_thread");
> +	error =3D (!IS_ERR(ctd_private->ctd_event_thread)) ? 0 : -EBUSY;
> +	if (!error) {
> +		wake_up_process(ctd_private->ctd_event_thread);
> +	} else {
> +		ctd_dprintk_crit(
> +			"FAILURE, ctd_private -> %p\n", ctd_private);
> +	}
> +	return error;
> +}
> +
> +static void
> +ctd_destroy_event_thread(struct ctd_pci_private *ctd_private)
> +{
> +	if (ctd_private->ctd_event_thread)
> +		kthread_stop(ctd_private->ctd_event_thread);
> +}
> +
> +static void
> +ctd_init_scsi_host_private(struct Scsi_Host *shost, struct pci_dev *=
pci_dev)
> +{
> +	int i;
> +	struct ctd_host_info *ctd_host_info;
> +	struct ctd_pci_private *ctd_private;
> +
> +	ctd_private =3D pci_get_drvdata(pci_dev);
> +
> +	ctd_dprintk("ctd_private -> %p\n", ctd_private);
> +
> +	ctd_host_info =3D shost_priv(shost);
> +	memset(ctd_host_info, 0x0, sizeof(struct ctd_host_info));
> +	for (i =3D 0; i < EMCCTD_MAX_ID; i++) {
> +		struct ctd_target_info *ctd_target;
> +
> +		ctd_target =3D &ctd_host_info->target[i];
> +		/* nothing to do;
> +		 * ctd_target->ctd_detect.emc_ctd_v010_detect_flags already zero
> +		 */
> +	}
> +
> +
> +	ctd_host_info->shost =3D shost;
> +	ctd_host_info->pci_dev =3D pci_dev;
> +
> +	shost->can_queue =3D ctd_private->pci_request_queue_size;
> +	shost->cmd_per_lun =3D min(emcctd_cmd_per_lun, shost->can_queue);
> +	shost->max_lun =3D emcctd_max_luns;
> +	shost->max_id =3D EMCCTD_MAX_ID;
> +
> +	ctd_private->host_private =3D ctd_host_info;
> +
> +	ctd_dprintk("scsi_ctd_host =3D %p\n", ctd_host_info);
> +}
> +
> +
> +static int
> +ctd_scsi_layer_init(struct pci_dev *pci_dev)
> +{
> +	int error;
> +	struct Scsi_Host	*scsi_ctd_host;
> +	struct ctd_pci_private *ctd_private =3D NULL;
> +
> +	ctd_dprintk("pci_dev -> %p\n", pci_dev);
> +
> +	scsi_ctd_host =3D scsi_host_alloc(&scsi_ctd_template,
> +			sizeof(struct ctd_host_info));
> +	if (scsi_ctd_host =3D=3D NULL) {
> +		error =3D -ENOMEM;
> +		goto ctd_scsi_layer_init_complete;
		return -ENOMEM;
> +	}
> +
> +	ctd_init_scsi_host_private(scsi_ctd_host, pci_dev);
> +
> +	ctd_private =3D pci_get_drvdata(pci_dev);

Maybe:

> +
> +	error =3D ctd_init_event_thread(ctd_private);
> +	if (error)
> +		goto ctd_scsi_layer_init_complete;
		goto out_put_scsi_host;
> +
> +	/*
> +	 * register the HBA to the Linux SCSI stack
> +	 */
> +	error =3D scsi_add_host(scsi_ctd_host, &pci_dev->dev);
	if (error)
		goto out_destroy_thread;

	reutrn 0;

out_put_scsi_host:
	scsi_host_put(scsi_ctd_host);
out_destroy_thread:
	ctd_destroy_event_thread(ctd_private);

	return error;
> +
> +ctd_scsi_layer_init_complete:
> +	if (error) {
> +		ctd_dprintk_crit("failure, error =3D %x\n", error);
> +		if (scsi_ctd_host !=3D NULL)
> +			scsi_host_put(scsi_ctd_host);
> +
> +		if (ctd_private)
> +			ctd_destroy_event_thread(ctd_private);
> +	}
> +	return error;
> +}
> +
> +static void
> +ctd_clear_io_queue(struct ctd_pci_private *ctd_private)
> +{
> +	struct list_head iochain;
> +	unsigned long flags;
> +	struct ctd_request_private *request, *request_next;
> +
> +	ctd_dprintk_crit("ctd_private -> %p\n", ctd_private);
> +
> +	INIT_LIST_HEAD(&iochain);
> +	spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +	/* post reset need to cleanup the aborted io
> +	 * as no reply is expected on them
> +	 */
> +	/* request is still kept as REPLY_AWAITED to
> +	 * handle any response post connect
> +	 */
> +	list_for_each_entry_safe(request, request_next,
> +			&ctd_private->aborted_io_list, list) {
> +		list_del(&request->list);
> +		request->io_state =3D CTD_IO_REQUEST_REPLY_AWAITED;
> +	}
> +
> +	/* rifle thru queued and requeued IO list and mark them for abort,
> +	 * the completion to the upper layers is handled by the timeout log=
ic
> +	 * invoked from the SCSI midlayer
> +	 */
> +	/* request is still kept as REPLY_AWAITED to handle any response po=
st
> +	 * connect
> +	 */
> +	list_for_each_entry_safe(request, request_next,
> +			&ctd_private->queued_io_list, list) {
> +		list_del(&request->list);
> +		list_add(&request->list, &iochain);
> +		request->cmnd->host_scribble =3D NULL;
> +		request->io_state =3D CTD_IO_REQUEST_REPLY_AWAITED;
> +
> +		/* These requests shall be aborted to upper layer, so treat them
> +		 * as abort_sent
> +		 */
> +		atomic_long_inc(&ctd_private->hw_stats.abort_sent);
> +		atomic_long_dec(&ctd_private->hw_stats.active_io_count);
> +	}
> +
> +	list_for_each_entry_safe(request, request_next,
> +			&ctd_private->requeued_io_list, list) {
> +		list_del(&request->list);
> +		list_add(&request->list, &iochain);
> +		request->cmnd->host_scribble =3D NULL;
> +		request->io_state =3D CTD_IO_REQUEST_REPLY_AWAITED;
> +
> +		/* These requests shall be aborted to upper layer, so treat them
> +		 * as abort_sent
> +		 */
> +		atomic_long_inc(&ctd_private->hw_stats.abort_sent);
> +		atomic_long_dec(&ctd_private->hw_stats.active_io_count);
> +	}
> +	spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +
> +	list_for_each_entry_safe(request, request_next,
> +			&iochain, list) {
> +		struct scsi_cmnd *cmnd;
> +
> +		list_del(&request->list);
> +
> +		ctd_dprintk_crit(
> +			"cmnd -> %p request -> %p CTD_IO_REQUEST_REPLY_AWAITED\n",
> +			request->cmnd, request);
> +
> +		cmnd =3D request->cmnd;
> +		request->cmnd =3D NULL;
> +
> +		/* error propagation to the SCSI midlayer */
> +		scsi_translate_sam_code(cmnd, SAM_STAT_TASK_ABORTED);
> +		scsi_set_resid(cmnd, scsi_bufflen(cmnd));
> +		cmnd->scsi_done(cmnd);
> +	}
> +	ctd_dprintk("ctd_private -> %p\n", ctd_private);
> +}
> +
> +static int
> +ctd_scsi_layer_cleanup(struct pci_dev *pci_dev)
> +{
> +	int error;
> +	struct ctd_pci_private *ctd_private;
> +	struct ctd_host_info *ctd_host_info;
> +
> +	error =3D 0;
> +
> +	ctd_private =3D pci_get_drvdata(pci_dev);
> +
> +	ctd_dprintk("ctd_private pci_dev -> %p %p\n", ctd_private, pci_dev)=
;
> +
> +	ctd_check_response_queue((unsigned long)pci_dev);
> +
> +	ctd_clear_io_queue(ctd_private);
> +
> +	ctd_destroy_event_thread(ctd_private);
> +
> +	flush_scheduled_work();
> +
> +	ctd_host_info =3D ctd_private->host_private;
> +
> +	scsi_remove_host(ctd_host_info->shost);
> +
> +	scsi_host_put(ctd_host_info->shost);
> +
> +	return error;
> +}
> +
> +#ifdef CONFIG_PM
> +static int
> +ctd_pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
> +{
> +	pci_save_state(pci_dev);
> +	pci_set_power_state(pci_dev, PCI_D3hot);
> +	return 0;
> +}
> +
> +static int
> +ctd_pci_resume(struct pci_dev *pci_dev)
> +{
> +	pci_restore_state(pci_dev);
> +	pci_set_power_state(pci_dev, PCI_D0);
> +	return 0;
> +}
> +#endif
> +
> +static void
> +ctd_pci_remove(struct pci_dev *pci_dev)
> +{
> +	struct ctd_pci_private *ctd_private;
> +
> +	ctd_dprintk("pic_dev -> %p\n", pci_dev);
> +
> +	ctd_private =3D pci_get_drvdata(pci_dev);
> +
> +	ctd_private->hw_state =3D CTD_HW_STATE_DISABLED;
> +
> +	ctd_scsi_layer_cleanup(pci_dev);
> +
> +#if !defined(__VMKLNX__)
> +	ctd_proc_remove(pci_dev);
> +#endif
> +	free_irq(pci_dev->irq, pci_dev);
> +
> +	pci_disable_msi(pci_dev);
> +
> +	if (ctd_private->ioaddr_txrx_rings)
> +		pci_iounmap(pci_dev, ctd_private->ioaddr_txrx_rings);
> +
> +	if (ctd_private->ioaddr_fast_registers)
> +		pci_iounmap(pci_dev, ctd_private->ioaddr_fast_registers);
> +
> +	if (ctd_private->ioaddr_slow_registers)
> +		pci_iounmap(pci_dev, ctd_private->ioaddr_slow_registers);
> +
> +	tasklet_kill(&ctd_private->isr_tasklet);
> +
> +	ctd_release_io_pool(ctd_private);
> +
> +	kfree(ctd_private);
> +
> +	pci_release_regions(pci_dev);
> +	pci_set_drvdata(pci_dev, NULL);
> +	pci_disable_device(pci_dev);
> +}
> +
> +static void
> +ctd_check_error_condition(struct pci_dev *pci_dev)
> +{
> +#define EMCCTD_MAX_CACHED_ERROR	14
> +	int i, j;
> +	int error;
> +	union emc_ctd_v010_message message;
> +	static emc_ctd_uint32_t internal_errors_1_14[EMCCTD_MAX_CACHED_ERRO=
R];
> +	struct ctd_pci_private *ctd_private =3D pci_get_drvdata(pci_dev);
> +
> +	if (ctd_private->pci_fast_registers->emc_ctd_v010_fregs_error_flag)=
 {
> +		for (i =3D 0; i <  EMCCTD_MAX_CACHED_ERROR; i++) {
> +			if (internal_errors_1_14[i] !=3D
> +				ctd_private->pci_fast_registers->emc_ctd_v010_fregs_errors_1_14[=
i]) {
> +
> +				internal_errors_1_14[i] =3D
> +					ctd_private->pci_fast_registers->emc_ctd_v010_fregs_errors_1_14=
[i];
> +
> +				error =3D i + 1;
> +
> +				for (j =3D 0; j < EMC_CTD_V010_LOG_ERROR_TX_SIZE; j++) {
> +					if (ctd_private->pci_fast_registers->emc_ctd_v010_fregs_log_err=
or_tx_error[j] =3D=3D
> +							error) {
> +						memcpy(&message,
> +							&ctd_private->pci_fast_registers->emc_ctd_v010_fregs_log_erro=
r_tx_message[j],
> +							sizeof(message));
> +						ctd_dprintk_crit(
> +							"header addr -> %x error -> %s\n",
> +							message.emc_ctd_scsi_message_header_address,
> +							(error =3D=3D
> +								EMC_CTD_V010_ERROR_TX_CHANNEL_DISCONNECTED ?
> +									"EMC_CTD_V010_ERROR_TX_CHANNEL_DISCONNECTED" :
> +								error =3D=3D
> +									EMC_CTD_V010_ERROR_TX_MESSAGE_WHAT ?
> +										 "EMC_CTD_V010_ERROR_TX_MESSAGE_WHAT" :
> +								error =3D=3D
> +									EMC_CTD_V010_ERROR_TX_MESSAGE_RESERVED ?
> +										"EMC_CTD_V010_ERROR_TX_MESSAGE_RESERVED" :
> +								error =3D=3D
> +									EMC_CTD_V010_ERROR_TX_MESSAGE_ORDER ?
> +										"EMC_CTD_V010_ERROR_TX_MESSAGE_ORDER" :
> +								error =3D=3D
> +									EMC_CTD_V010_ERROR_TX_ENDPOINT_TYPE ?
> +										"EMC_CTD_V010_ERROR_TX_ENDPOINT_TYPE" :
> +								error =3D=3D
> +									EMC_CTD_V010_ERROR_TX_OPAQUE_RX_UNKNOWN ?
> +										"EMC_CTD_V010_ERROR_TX_OPAQUE_RX_UNKNOWN" :
> +											"EMC_CTD_V010_ERROR_NULL"));
> +					}
> +				}
> +			}
> +		}
> +	}
> +}
> +/*
> + * ctd_check_response_queue
> + *
> + * Bottom half of interrupt handler.
> + */
> +static void
> +ctd_check_response_queue(unsigned long instance_addr)
> +{
> +	struct pci_dev *pci_dev =3D (struct pci_dev *)instance_addr;
> +	struct ctd_pci_private *ctd_private =3D pci_get_drvdata(pci_dev);
> +	union emc_ctd_v010_message io_response;
> +
> +
> +		/* empty response queue */
> +		while (ctd_hw_dequeue_response(&io_response, ctd_private) =3D=3D
> +							SUCCESS) {
> +			/* handle the response */
> +			ctd_handle_response(&io_response, ctd_private);
> +		}
> +}
> +
> +
> +static irqreturn_t
> +ctd_isr(int irq, void *opaque)
> +{
> +	struct pci_dev *pci_dev =3D (struct pci_dev *)opaque;
> +	struct ctd_pci_private *ctd_private =3D pci_get_drvdata(pci_dev);
> +
> +	atomic_long_inc(&ctd_private->hw_stats.interrupts);
> +
> +	/* schedule work for later */
> +	tasklet_schedule(&ctd_private->isr_tasklet);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int
> +ctd_request_msi(struct pci_dev *pci_dev)
> +{
> +	int err =3D -EFAULT;
> +
> +	if (pci_dev->irq) {
> +		err =3D pci_enable_msi(pci_dev);
> +		if (!err) {
> +			err =3D request_irq(pci_dev->irq, ctd_isr,
> +					IRQF_SHARED,
> +					pci_name(pci_dev), pci_dev);
> +			if (err < 0) {
> +				ctd_dprintk_crit("request_irq failure !!!\n");
> +				pci_disable_msi(pci_dev);
> +				err =3D -EBUSY;
> +			}
> +		}
> +	}
> +	return err;
> +}
> +
> +static struct ctd_request_private *
> +ctd_acquire_request(struct ctd_pci_private *ctd_private)
> +{
> +	unsigned long flags;
> +	struct ctd_request_private *ctd_request;
> +
> +	ctd_request =3D NULL;
> +
> +	spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +
> +	/* check if any request in the aborted io list can be reused */
> +	if (!list_empty(&ctd_private->aborted_io_list)) {
> +		struct ctd_request_private *request, *request_next;
> +
> +		list_for_each_entry_safe(request, request_next,
> +					&ctd_private->aborted_io_list, list) {
> +			/* aborted_io_list is in chronologically order thus
> +			 * failure of time_after() indicates any request after
> +			 * this point is not in the kill zone
> +			 */
> +			if (time_before(jiffies, request->purge_lifetime))
> +				break;
> +
> +			list_del(&request->list);
> +			if (request->cdb_page) {
> +				__free_pages(request->cdb_page,
> +						request->cdb_page_order);
> +			}
> +			if (request->sgllist_page) {
> +				__free_pages(request->sgllist_page,
> +						request->sgllist_page_order);
> +			}
> +			memset(request, 0x0,
> +					sizeof(struct ctd_request_private));
> +			list_add(&request->list, &ctd_private->io_pool);
> +			atomic_long_inc(&ctd_private->hw_stats.free_io_entries);
> +		}
> +	}
> +
> +	if (!list_empty(&ctd_private->io_pool)) {
> +		ctd_request =3D list_first_entry(&ctd_private->io_pool,
> +					struct ctd_request_private, list);
> +		list_del(&ctd_request->list);
> +		ctd_request->io_state =3D CTD_IO_REQUEST_QUEUED;
> +	}
> +
> +	if (ctd_request)
> +		atomic_long_dec(&ctd_private->hw_stats.free_io_entries);
> +
> +	spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +
> +	return ctd_request;
> +}
> +
> +static void
> +ctd_release_request(struct ctd_request_private *ctd_request,
> +			struct ctd_pci_private *ctd_private)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ctd_private->io_mgmt_lock, flags);
> +	memset(ctd_request, 0x0, sizeof(struct ctd_request_private));
> +	list_add(&ctd_request->list, &ctd_private->io_pool);
> +
> +	atomic_long_inc(&ctd_private->hw_stats.free_io_entries);
> +
> +	spin_unlock_irqrestore(&ctd_private->io_mgmt_lock, flags);
> +}
> +
> +static void
> +ctd_release_io_pool(struct ctd_pci_private *ctd_private)
> +{
> +	kfree(ctd_private->io_map);
> +}
> +
> +static int
> +ctd_alloc_io_pool(struct ctd_pci_private *ctd_private, unsigned int =
pool_size)
> +{
> +	int i;
> +	int error;
> +
> +	error =3D -ENOMEM;
> +
> +	INIT_LIST_HEAD(&ctd_private->io_pool);
> +	INIT_LIST_HEAD(&ctd_private->queued_io_list);
> +	INIT_LIST_HEAD(&ctd_private->aborted_io_list);
> +	INIT_LIST_HEAD(&ctd_private->requeued_io_list);
> +
> +	spin_lock_init(&ctd_private->io_mgmt_lock);
> +
> +	ctd_private->io_map =3D kcalloc(pool_size,
> +				sizeof(struct ctd_request_private), GFP_KERNEL);
> +
> +	/*
> +	 * in case of allocation failure try with one fourth the size befor=
e
> +	 * throwing the towel
> +	 */
> +
> +	if (ctd_private->io_map =3D=3D NULL) {
> +		pool_size =3D pool_size >> 2;
> +		ctd_private->io_map =3D kcalloc(pool_size,
> +			sizeof(struct ctd_request_private), GFP_KERNEL);
> +		if (ctd_private->io_map =3D=3D NULL) {
> +			ctd_dprintk_crit(
> +				"io_pool allocation failure for pool_size -> %d\n",
> +				pool_size);

No OOM messages.

> +			goto ctd_alloc_io_pool_complete;
> +		}
> +	}
> +
> +	ctd_private->io_map_end =3D ctd_private->io_map + pool_size;
> +
> +	for (i =3D 0; i < pool_size; i++) {
> +		struct ctd_request_private  *request_context =3D
> +						ctd_private->io_map + i;
> +		memset(request_context, 0x0,
> +				sizeof(struct ctd_request_private));
> +		list_add(&request_context->list, &ctd_private->io_pool);
> +	}
> +	ctd_dprintk_crit(
> +		"ctd_private -> %p, pool_size -> %x, io_map -> %p, io_map_end-> %p=
\n",
> +			ctd_private, pool_size,
> +			ctd_private->io_map, ctd_private->io_map_end);
> +	error =3D 0;
> +	ctd_private->hw_stats.free_io_entries.counter =3D pool_size;
> +ctd_alloc_io_pool_complete:
> +	return error;
> +}
> +
> +static int
> +ctd_pci_probe(
> +	struct pci_dev *pci_dev,
> +	const struct pci_device_id *id
> +)
> +{
> +	struct ctd_pci_private *ctd_private;
> +	int ctd_proc_initialized;
> +	int ctd_scsi_initialized;
> +	int ctd_regions_initialized;
> +	int err;
> +
> +	err =3D -ENODEV;
> +	ctd_proc_initialized =3D FAILED;
> +	ctd_scsi_initialized =3D FAILED;
> +	ctd_regions_initialized =3D FAILED;
> +
> +	ctd_private =3D (struct ctd_pci_private *)
> +			kzalloc(sizeof(struct ctd_pci_private), GFP_ATOMIC);
> +
> +	if (ctd_private =3D=3D NULL) {
> +		ctd_dprintk_crit("kzalloc Failure\n");
> +		goto ctd_pci_probe_complete;
> +	}

No cast and no OOM messages.

> +
> +	ctd_private->pci_dev =3D pci_dev;
> +
> +	/* enable the device */
> +	err =3D pci_enable_device(pci_dev);
> +	if (err) {
> +		ctd_dprintk_crit("pci_enable_device Failure\n");

I'd prefere dev_err() here, as you'll have the information which device=
 enable
failed.

> +		goto ctd_pci_probe_complete;
> +	}
> +	pci_set_master(pci_dev);
> +
> +	err =3D pci_request_regions(pci_dev, "ctd-pci");
> +	if (err) {
> +		ctd_dprintk_crit("pci_request_regions Failure\n");

Same here.

> +		goto ctd_pci_probe_complete;
> +	}
> +
> +	ctd_regions_initialized =3D SUCCESS;
> +
> +	ctd_dprintk("ctd_private pci_dev -> %p %p\n", ctd_private, pci_dev)=
;
> +
> +#define EMC_CTD_TXRX_MSG_SIZE 128
> +
> +	if (pci_resource_start(pci_dev, EMC_CTD_V010_BAR_RINGS)) {
> +		ctd_private->ioaddr_txrx_rings =3D ioremap(
> +				pci_resource_start(pci_dev,
> +					EMC_CTD_V010_BAR_RINGS),
> +				pci_resource_len(pci_dev,
> +					EMC_CTD_V010_BAR_RINGS)
> +				);
> +		ctd_private->txrx_ringsize =3D
> +			(pci_resource_len(pci_dev,
> +				  EMC_CTD_V010_BAR_RINGS) >> 1)
> +					/ EMC_CTD_TXRX_MSG_SIZE;
> +
> +		ctd_dprintk_crit(
> +			"physical addr =3D %llx ioaddr_txrx_rings =3D %p , ring size =3D =
%x\n",
> +				pci_resource_start(pci_dev,
> +					EMC_CTD_V010_BAR_RINGS),
> +				ctd_private->ioaddr_txrx_rings,
> +					ctd_private->txrx_ringsize);
> +
> +	}
> +	if (ctd_private->ioaddr_txrx_rings =3D=3D NULL) {
> +		err =3D -ENOMEM;
> +		ctd_dprintk_crit("ioremap failure\n");
> +		goto ctd_pci_probe_complete;
> +	} else {
> +		ctd_private->pci_request_array =3D ctd_private->ioaddr_txrx_rings;
> +		ctd_private->pci_response_array =3D
> +			ctd_private->ioaddr_txrx_rings +
> +				((pci_resource_len(pci_dev,
> +					   EMC_CTD_V010_BAR_RINGS)) >> 1);
> +	}
> +
> +
> +	if (pci_resource_start(pci_dev, EMC_CTD_V010_BAR_FREGS)) {
> +		ctd_private->ioaddr_fast_registers =3D
> +			ioremap(pci_resource_start(pci_dev,
> +					EMC_CTD_V010_BAR_FREGS),
> +				pci_resource_len(pci_dev,
> +				EMC_CTD_V010_BAR_FREGS));
> +
> +		ctd_dprintk_crit(
> +			"physical addr =3D %llx ioaddr_fast_registers =3D %p\n",
> +				pci_resource_start(pci_dev,
> +					EMC_CTD_V010_BAR_FREGS),
> +				ctd_private->ioaddr_fast_registers);
> +	}
> +	if (ctd_private->ioaddr_fast_registers =3D=3D NULL) {
> +		err =3D -ENOMEM;
> +		ctd_dprintk_crit("ioremap failure\n");
> +		goto ctd_pci_probe_complete;
> +	} else {
> +		ctd_private->pci_fast_registers =3D
> +			ctd_private->ioaddr_fast_registers;
> +	}
> +
> +	if (pci_resource_start(pci_dev, EMC_CTD_V010_BAR_SREGS)) {
> +		ctd_private->ioaddr_slow_registers =3D
> +			ioremap(pci_resource_start(pci_dev,
> +						EMC_CTD_V010_BAR_SREGS),
> +				pci_resource_len(pci_dev,
> +					EMC_CTD_V010_BAR_SREGS));
> +
> +		ctd_dprintk_crit(
> +			"physical addr =3D %llx ioaddr_slow_registers =3D %p\n",
> +				pci_resource_start(pci_dev,
> +					EMC_CTD_V010_BAR_SREGS),
> +				ctd_private->ioaddr_slow_registers);
> +	}
> +	if (ctd_private->ioaddr_slow_registers =3D=3D NULL) {
> +		err =3D -ENOMEM;
> +		ctd_dprintk_crit("ioremap failure\n");
> +		goto ctd_pci_probe_complete;
> +	} else {
> +		ctd_private->pci_slow_registers =3D
> +			ctd_private->ioaddr_slow_registers;
> +	}
> +
> +	/* reset the device */
> +	ctd_private->pci_device_reset_register =3D 0XFF;
> +
> +	ctd_private->pci_request_queue_size =3D ctd_private->txrx_ringsize;
> +	ctd_private->pci_response_queue_size =3D ctd_private->txrx_ringsize=
;
> +
> +	err =3D ctd_alloc_io_pool(ctd_private,
> +			ctd_private->pci_request_queue_size);
> +	if (err) {
> +		ctd_dprintk_crit("ctd_alloc_io_pool failure\n");
> +		goto ctd_pci_probe_complete;
> +	}
> +
> +	pci_set_drvdata(pci_dev, ctd_private);
> +
> +	spin_lock_init(&ctd_private->isr_lock);
> +
> +	/* setup tasklet for scanning response queue */
> +	tasklet_init(&ctd_private->isr_tasklet,
> +			ctd_check_response_queue, (unsigned long)pci_dev);
> +
> +	ctd_private->hw_state =3D CTD_HW_STATE_INITIALIZED;
> +
> +	pci_set_master(pci_dev);
> +
> +#if !defined(__VMKLNX__)
> +	err =3D ctd_proc_init(pci_dev);
> +	if (err) {
> +		ctd_dprintk_crit("ctd_proc_init failure\n");
> +		goto ctd_pci_probe_complete;
> +	}
> +	ctd_proc_initialized =3D SUCCESS;
> +#endif
> +	err =3D ctd_scsi_layer_init(pci_dev);
> +	if (err) {
> +		ctd_dprintk_crit("ctd_scsi_layer_init failure\n");
> +		goto ctd_pci_probe_complete;
> +	}
> +	ctd_scsi_initialized =3D SUCCESS;
> +
> +	err =3D ctd_request_msi(pci_dev);
> +	if (err) {
> +		ctd_dprintk_crit("ctd_request_msi failure\n");
> +		goto ctd_pci_probe_complete;
> +	}
> +
> +	/* after we reset the device, but before we enabled MSI, some messa=
ges
> +	 * may have been received.  check for them
> +	 */
> +	tasklet_schedule(&ctd_private->isr_tasklet);
> +
> +ctd_pci_probe_complete:
> +	if (err) {
> +		if (ctd_private) {
> +			tasklet_kill(&ctd_private->isr_tasklet);
> +
> +			if (ctd_scsi_initialized =3D=3D SUCCESS)
> +				ctd_scsi_layer_cleanup(pci_dev);
> +
> +			if (ctd_proc_initialized =3D=3D SUCCESS)
> +				ctd_proc_remove(pci_dev);
> +
> +			if (ctd_private->ioaddr_txrx_rings)
> +				pci_iounmap(pci_dev,
> +					ctd_private->ioaddr_txrx_rings);
> +
> +			if (ctd_private->ioaddr_fast_registers)
> +				pci_iounmap(pci_dev,
> +					ctd_private->ioaddr_fast_registers);
> +
> +			if (ctd_private->ioaddr_slow_registers)
> +				pci_iounmap(pci_dev,
> +					ctd_private->ioaddr_slow_registers);
> +
> +			if (ctd_regions_initialized =3D=3D SUCCESS)
> +				pci_release_regions(pci_dev);
> +
> +			ctd_release_io_pool(ctd_private);
> +			kfree(ctd_private);
> +		}
> +		pci_set_drvdata(pci_dev, NULL);
> +		pci_disable_device(pci_dev);
> +	}
> +	return err;
> +}
> +
> +#if !defined(__VMKLNX__)
> +static const struct file_operations ctd_proc_fops =3D {
> +	.open		=3D ctd_proc_open,
> +	.read		=3D seq_read,
> +	.llseek		=3D seq_lseek,
> +	.release	=3D seq_release,
> +};
> +static int
> +ctd_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, ctd_proc_show, PDE_DATA(inode));
> +}
> +
> +int
> +ctd_proc_init(struct pci_dev *pci_dev)
> +{
> +	int err;
> +	static int hw_index;
> +	char hw_name[MAX_PROC_FILE_NAMELEN];
> +	struct ctd_pci_private *ctd_private;
> +	struct proc_dir_entry *pde;
> +
> +	ctd_private =3D (struct ctd_pci_private *) pci_get_drvdata(pci_dev)=
;
> +	ctd_private->hw_index =3D hw_index;
> +
> +	memset(hw_name, 0x0, sizeof(hw_name));
> +	snprintf(hw_name, sizeof(hw_name), "emcctd_stats_%d", hw_index++);
> +
> +	err =3D -EPERM;
> +
> +	do {
> +		if (ctd_proc_directory =3D=3D NULL)
> +			break;
> +		pde =3D proc_create_data(hw_name, S_IFREG | S_IRUGO | S_IWUSR,
> +				ctd_proc_directory,
> +				&ctd_proc_fops,
> +				ctd_private);
> +
> +		if (pde =3D=3D NULL) {
> +			ctd_dprintk_crit(
> +				"create_proc_read_entry failure for %s\n",
> +				hw_name);
> +			break;
> +		}
> +		err =3D 0;
> +	} while (0);
> +	return err;
> +}
> +
> +void
> +ctd_proc_remove(struct pci_dev *pci_dev)
> +{
> +	int hw_index;
> +	char hw_name[MAX_PROC_FILE_NAMELEN];
> +	struct ctd_pci_private *ctd_private;
> +
> +	ctd_private =3D (struct ctd_pci_private *) pci_get_drvdata(pci_dev)=
;
> +
> +	hw_index =3D ctd_private->hw_index;
> +	memset(hw_name, 0x0, sizeof(hw_name));
> +	snprintf(hw_name, sizeof(hw_name), "emc/emcctd_stats_%d", hw_index)=
;
> +
> +	ctd_dprintk("removing %s\n", hw_name);
> +
> +	remove_proc_entry(hw_name, NULL);
> +
> +}
> +#endif
> +
> +static int __init ctd_pci_init(void)
> +{
> +	int err;
> +
> +	ctd_dprintk_crit("Loading emcctd\n");
> +	init_waitqueue_head(&lun_discovery_event_barrier);
> +
> +	ctd_proc_directory =3D proc_mkdir("emc", NULL);
> +
> +	err =3D pci_register_driver(&ctd_pci_driver);
> +
> +	if (err) {
> +		remove_proc_entry("emc", NULL);
> +	} else {
> +		/* wait for 20 seconds or less to allow the luns to appear
> +		 * before exiting from insmod
> +		 */
> +		wait_event_interruptible_timeout(lun_discovery_event_barrier,
> +					lun_discovery_complete, ((HZ) * 20));
> +	}
> +
> +	return err;
> +}
> +
> +module_init(ctd_pci_init);
> +
> +static void __exit ctd_pci_exit(void)
> +{
> +	pci_unregister_driver(&ctd_pci_driver);
> +	remove_proc_entry("emc", NULL);
> +}
> +
> +module_exit(ctd_pci_exit);
> diff --git a/drivers/scsi/emcctd/emcctd.h b/drivers/scsi/emcctd/emcct=
d.h
> new file mode 100644
> index 0000000..3fba931
> --- /dev/null
> +++ b/drivers/scsi/emcctd/emcctd.h
> @@ -0,0 +1,232 @@
> +/*
> + * EMCCTD: EMC Cut-Through HBA Driver for SCSI subsystem.
> + *
> + * Copyright (C) 2015 by EMC Corporation, Hopkinton, MA.
> + *
> + * Authors:
> + *	fredette, matt <matt.fredette-mb1K0bWo544@public.gmane.org>
> + *	Pirotte, Serge <serge.pirotte-mb1K0bWo544@public.gmane.org>
> + *	Singh Animesh <Animesh.Singh-mb1K0bWo544@public.gmane.org>
> + *	Singhal, Maneesh <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _EMCCTD_H_
> +#define _EMCCTD_H_
> +
> +#define DRV_NAME	"emcctd"
> +
> +#define EMCCTD_V010_PROTOCOL_MINOR_VERSION	0x0
> +
> +/* please refer to emc_ctd_v010_scsi_command_cdb in emc_ctd_interfac=
e.h */
> +#define EMCCTD_V010_MAX_CDB_SIZE		16
> +
> +#define EMCCTD_MAX_LUN			16384
> +#define EMCCTD_MAX_ID			16
> +#define EMCCTD_MAX_RETRY		5
> +#define EMCCTD_CMD_PER_LUN		16
> +#define EMCCTD_THIS_ID			(-1)
> +#define EMCCTD_REQUEST_TIMEOUT		(60 * HZ)
> +#define EMCCTD_OPAQUE_PURGE_WAITTIME	(10 * HZ)
> +
> +#define EMCCTD_DEVICE_RESET_PAUSE	3
> +#define EMCCTD_DETECT_RETRY_MAX		3
> +
> +#define ctd_dprintk(__m_fmt, ...)		\
> +do {				\
> +	if (ctd_debug)		\
> +		pr_info("%s:%d:"__m_fmt, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +#define ctd_dprintk_crit(__m_fmt, ...)		\
> +		pr_crit("%s:%d:"__m_fmt, __func__, __LINE__, ##__VA_ARGS__)
> +
> +#define EMCCTD_TARGET_DETECT_COMPLETED		1
> +#define EMCCTD_TARGET_DETECT_NOT_COMPLETED	0
> +
> +struct ctd_target_info {
> +	unsigned int detect_completed;
> +	struct scsi_target *starget;
> +	struct emc_ctd_v010_detect ctd_detect;
> +};
> +
> +#define emc_ctd_detect_header_address           \
> +		emc_ctd_v010_detect_header.emc_ctd_v010_header_address
> +#define emc_ctd_detect_header_minor             \
> +		emc_ctd_v010_detect_header.emc_ctd_v010_header_minor
> +#define emc_ctd_detect_header_what              \
> +		emc_ctd_v010_detect_header.emc_ctd_v010_header_what
> +
> +#define emc_ctd_scsi_command_header_address     \
> +		emc_ctd_v010_scsi_command_header.emc_ctd_v010_header_address
> +#define emc_ctd_scsi_command_header_minor       \
> +		emc_ctd_v010_scsi_command_header.emc_ctd_v010_header_minor
> +#define emc_ctd_scsi_command_header_what        \
> +		emc_ctd_v010_scsi_command_header.emc_ctd_v010_header_what
> +
> +#define emc_ctd_scsi_response_header_address    \
> +		emc_ctd_v010_scsi_response_header.emc_ctd_v010_header_address
> +#define emc_ctd_scsi_response_header_minor      \
> +		emc_ctd_v010_scsi_response_header.emc_ctd_v010_header_minor
> +#define emc_ctd_scsi_response_header_what       \
> +		emc_ctd_v010_scsi_response_header.emc_ctd_v010_header_what
> +
> +#define emc_ctd_scsi_phase_header_address       \
> +		emc_ctd_v010_scsi_phase_header.emc_ctd_v010_header_address
> +#define emc_ctd_scsi_phase_header_minor         \
> +		emc_ctd_v010_scsi_phase_header.emc_ctd_v010_header_minor
> +#define emc_ctd_scsi_phase_header_what          \
> +		emc_ctd_v010_scsi_phase_header.emc_ctd_v010_header_what
> +
> +#define emc_ctd_scsi_message_header_address     \
> +		emc_ctd_v010_message_header.emc_ctd_v010_header_address
> +#define emc_ctd_scsi_message_header_minor       \
> +		emc_ctd_v010_message_header.emc_ctd_v010_header_minor
> +#define emc_ctd_scsi_message_header_what        \
> +		emc_ctd_v010_message_header.emc_ctd_v010_header_what
> +
> +#define emc_ctd_scsi_command_sgl                \
> +		emc_ctd_v010_scsi_command_u.emc_ctd_v010_scsi_command_sgl
> +#define emc_ctd_scsi_response_extra             \
> +		emc_ctd_v010_scsi_response_u.emc_ctd_v010_scsi_response_extra
> +
> +#define ctd_detect_name_bytes		\
> +	ctd_detect.emc_ctd_v010_detect_name.emc_ctd_v010_name_bytes
> +
> +struct ctd_host_info {
> +	struct Scsi_Host *shost;
> +	struct pci_dev *pci_dev;
> +	struct ctd_target_info target[EMCCTD_MAX_ID];
> +};
> +
> +struct ctd_dev_info {
> +	struct ctd_host_info *ctd_host;
> +	struct ctd_target_info *ctd_target;
> +	struct emc_ctd_v010_detect *ctd_target_detect;
> +};
> +
> +#define PROC_STAT_SCSI_TS_MAX   10
> +#define MAX_PROC_FILE_NAMELEN	128
> +#define CTD_MAX_IO_STATS	200
> +
> +struct ctd_hw_stats {
> +	atomic_long_t			interrupts;
> +	atomic_long_t			requests_sent;
> +	atomic_long_t			responses_received;
> +	atomic_long_t			active_io_count;
> +	atomic_long_t			abort_sent;
> +	atomic_long_t			abort_received;
> +	atomic_long_t			what_in;
> +	atomic_long_t			what_out;
> +	atomic_long_t			free_io_entries;
> +	unsigned long long		io_stats[CTD_MAX_IO_STATS];
> +	unsigned int			io_stats_index;
> +};
> +
> +enum ctd_io_request_state {
> +	CTD_IO_REQUEST_FREE,
> +	CTD_IO_REQUEST_QUEUED,
> +	CTD_IO_REQUEST_REQUEUED,
> +	CTD_IO_REQUEST_ABORTED,
> +	CTD_IO_REQUEST_COMPLETED,
> +	CTD_IO_REQUEST_REPLY_AWAITED,
> +	CTD_IO_REQUEST_INVALID
> +};
> +
> +enum ctd_hw_state {
> +	CTD_HW_STATE_UNINITIALIZED,
> +	CTD_HW_STATE_INITIALIZED,
> +	CTD_HW_STATE_UNDER_RESET,
> +	CTD_HW_STATE_DISABLED,
> +	CTD_HW_STATE_INVALID
> +};
> +
> +struct ctd_request_private {
> +	struct list_head		list;
> +	enum ctd_io_request_state	io_requeue_state;
> +	unsigned int			io_timeout;
> +	enum ctd_io_request_state	io_state;
> +	struct scsi_cmnd		*cmnd;
> +	struct page			*cdb_page;
> +	unsigned int			cdb_page_order;
> +	struct page			*sgllist_page;
> +	unsigned int			sgllist_page_order;
> +	unsigned long			purge_lifetime;
> +	unsigned long long		io_start_time;
> +};
> +
> +struct ctd_pci_private {
> +	struct pci_dev			*pci_dev;
> +	void				*host_private;
> +
> +	void __iomem			*ioaddr_txrx_rings;
> +	void __iomem			*ioaddr_fast_registers;
> +	void __iomem			*ioaddr_slow_registers;
> +
> +	emc_ctd_uint32_t		txrx_ringsize;
> +	emc_ctd_uint32_t		pci_request_queue_size;
> +	emc_ctd_uint32_t		pci_response_queue_size;
> +	struct emc_ctd_v010_fregs	*pci_fast_registers;
> +	struct emc_ctd_v010_sregs	*pci_slow_registers;
> +	union emc_ctd_v010_message	*pci_response_array;
> +	union emc_ctd_v010_message	*pci_request_array;
> +
> +	struct tasklet_struct		isr_tasklet;
> +	spinlock_t			isr_lock;
> +	unsigned int			hw_index;
> +	struct ctd_hw_stats		hw_stats;
> +	enum ctd_hw_state		hw_state;
> +	struct list_head		queued_io_list;
> +	struct list_head		aborted_io_list;
> +	struct list_head		requeued_io_list;
> +	struct list_head		io_pool;
> +	struct ctd_request_private	*io_map;
> +	struct ctd_request_private	*io_map_end;
> +	spinlock_t			io_mgmt_lock;
> +
> +	struct task_struct		*ctd_event_thread;
> +	struct list_head		event_io_list;
> +	spinlock_t			event_io_lock;
> +};
> +
> +#define request_producer_index		\
> +		pci_fast_registers->emc_ctd_v010_fregs_tx_index_producer
> +#define request_consumer_index		\
> +		pci_fast_registers->emc_ctd_v010_fregs_tx_index_consumer
> +#define response_producer_index		\
> +		pci_fast_registers->emc_ctd_v010_fregs_rx_index_producer
> +#define response_consumer_index		\
> +		pci_fast_registers->emc_ctd_v010_fregs_rx_index_consumer
> +#define pci_device_reset_register	\
> +		pci_slow_registers->emc_ctd_v010_sregs_reset
> +
> +#define pci_device_name_bytes		\
> +	pci_fast_registers->emc_ctd_v010_fregs_device_name.emc_ctd_v010_nam=
e_bytes
> +
> +struct ctd_event_io_element {
> +	struct list_head		list;
> +	union emc_ctd_v010_message	io_msg;
> +};
> +
> +static inline unsigned long long ctd_read_tsc(void)
> +{
> +	unsigned long long local_tsc;
> +
> +	local_tsc =3D rdtsc();
> +
> +	return local_tsc;
> +}
> +
> +#endif /* _EMCCTD_H_ */
> +
> +/* vi: set ts=3D8 sw=3D8 noet: */
> --
> 1.8.5.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
