From: Oleksandr Shamray <oleksandrs@mellanox.com>
Subject: RE: [patch v18 0/4] JTAG driver introduction
Date: Thu, 10 May 2018 15:13:26 +0000
Message-ID: <HE1PR0502MB2972F340728121766CEEC593B1980@HE1PR0502MB2972.eurprd05.prod.outlook.com>
References: <1517236305-4880-1-git-send-email-oleksandrs@mellanox.com>
 <ff739c26-d3b2-3df7-e751-fbf037ae96d1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ff739c26-d3b2-3df7-e751-fbf037ae96d1@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Fainelli <f.fainelli@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "arnd@arndb.de" <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>, "joel@jms.id.au" <joel@jms.id.au>, "jiri@resnulli.us" <jiri@resnulli.us>, "tklauser@distanz.ch" <tklauser@distanz.ch>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Vadim Pasternak <vadimp@mellanox.com>, system-sw-low-level <system-sw-low-level@mellanox.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "openocd-devel-owner@lists.sourceforge.net" <openocd-devel-owner@lists.sourceforge.net>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

Hi Florian.

>> We propose to implement general JTAG interface and infrastructure=20
>> to communicate with user layer application. In such way, we can=20
>> have the standard JTAG interface core part and separation from=20
>> specific HW implementation.
>
>Well, the framework in its current shape is still extremely=20
>simplistic, therefore leaving a lot of room (read: bugs,=20
>inconsistencies) within the hands of the driver, so while the=20
>user-space interface is standard through the proposed character=20
>device, the user experience, likely might not.

Well, the framework is intentionally simply and provide the very basic
interface. It supposed that interface can be extended in the future, if=20
necessary. Current kernel does not provide a framework for JTAG interface,
and we believe this is good starting point to allow such framework. This
provide minimal, but sufficient interface and any future extension will be
of course welcomed.

At the moment we have one controller driver, which works well with this
infrastructure. And we have very reasonable use case - this driver allows
flashing for all the programmable devices, connected to JTAG interface,
where the image for these device is provided with the standard SVF format.


>> This allow new capability to debug the CPU or program system's=20
>> device via BMC without additional devices nor cost.

>If that is the case, should not we leverage the kernel's device=20
>driver model and expect the JTAG framework to create specific devices=20
>for the different pieces of HW discovered on the scan chain? That=20
>would also
>presumably allow the core JTAG framework to retain the necessary=20
>state
>changes in order to address one particular device within the scan chain.

For the device programming use case, the flashing image will contain
jtag chain topology. If for example, jtag domain contains x devices, but
image contains less, the only relevant devices will be flashed and there is
no need to distinct between them.
In case there are several domains, jtag interface is  configured to be
connected to the relevant one.

For the CPU debug use case, jtag interface is configured to be connected
to CPU only.

System should be able to provide jtag selection according to the needs
and this kind of operations should be out of the JTAG driver scope.


>> This patch purpose is to add JTAG master core infrastructure by=20
>> defining new JTAG class and provide generic JTAG interface to allow=20
>> hardware specific drivers to connect this interface.
>> This will enable all JTAG drivers to use the common interface part=20
>> and will have separate for hardware implementation.

>Let's consider I want to get rid of OpenOCD, or rather, move its=20
>driver interface within the kernel and replace it on the OpenOCD side=20
>with a generic character device interface. I could presumably=20
>amortize the costly operations which are currently I/O and/or system=20
>call limiting when running in user-space, what would it look like=20
>with your proposed framework, have you given some thoughts about that?


The JTAG driver using SDR/SIR transactions to send/receive data.
It can send/receive multiple data bits by a single transaction.

For the bit-banging style drivers it gives you an advantage of sending
Bits stream by one system call vs per-bit system call.
So, instead of updating GPIO pins a few time through user space interface
(sysfs) for sending single bit, an application can send multiple bits in a
stream by one call. And all GPIO operations will be performed than in a
kernel space.
It'll be necessary to have bit-banging driver, using the JTAG infrastructur=
e,
which should be configured according to the particular system during
initialization. And we are planning to develop such kind of driver.
It definitely reduces system calls and saves time for JTAG operations.

For the system equipped with the JTAG master there the same advantages
plus hardware acceleration for pin access (all pins can be accessed by
one shot).

Driver supports universal transactions (include/uapi/linux/jtag.h),
which are sent through  IOCTL interface JTAG_IOCRUNTEST, JTAG_IOCXFER
struct struct jtag_xfer {
              __u8      type;
              __u8      direction;
              __u8      endstate;
              __u8      padding;
              __u32    length;
               __u64    tdio;
};

jtag_run_test_idle {
              __u8      reset;
              __u8      endstate;
              __u8      tck;
};

You can see usage example on https://github.com/mellanoxbmc/mellanox-bmc-to=
ols/tree/master/mlnx_cpldprog

Best Regards,
Oleksandr Shamray

> -----Original Message-----
> From: Florian Fainelli [mailto:f.fainelli@gmail.com]
> Sent: 31 =D1=CE=D7=C1=D2=D1 2018 =C7. 5:03
> To: Oleksandr Shamray <oleksandrs@mellanox.com>;
> gregkh@linuxfoundation.org; arnd@arndb.de
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org; openbmc@lists.ozlabs.org; joel@jms.id.au;
> jiri@resnulli.us; tklauser@distanz.ch; linux-serial@vger.kernel.org; Vadi=
m
> Pasternak <vadimp@mellanox.com>; system-sw-low-level <system-sw-low-
> level@mellanox.com>; robh+dt@kernel.org; openocd-devel-
> owner@lists.sourceforge.net; linux-api@vger.kernel.org;
> davem@davemloft.net; mchehab@kernel.org
> Subject: Re: [patch v18 0/4] JTAG driver introduction
>=20
> On 01/29/2018 06:31 AM, Oleksandr Shamray wrote:
> > When a need raise up to use JTAG interface for system's devices
> > programming or CPU debugging, usually the user layer application
> > implements jtag protocol by bit-bang or using a proprietary connection
> > to vendor hardware.
> > This method can be slow and not generic.
> >
> > We propose to implement general JTAG interface and infrastructure to
> > communicate with user layer application. In such way, we can have the
> > standard JTAG interface core part and separation from specific HW
> > implementation.
> > This allow new capability to debug the CPU or program system's device
> > via BMC without additional devices nor cost.
>=20
> Oleksandr, you have completed dodged my questions here:
>=20
> https://lkml.org/lkml/2017/12/25/163
>=20
> can you try to respond to some of these questions please?
> --
> Florian
