From: Yann Cantin <yann.cantin@laposte.net>
Subject: Re: [RFC ebeam PATCH 2/2] input: misc: New USB eBeam input driver
Date: Tue, 21 Jul 2015 14:38:37 +0200
Message-ID: <55AE3D4D.2040706@laposte.net>
References: <1437426199-29866-1-git-send-email-yann.cantin@laposte.net>	 <1437426199-29866-3-git-send-email-yann.cantin@laposte.net> <1437466763.3823.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437466763.3823.1.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, dmitry.torokhov@gmail.com, jkosina@suse.cz, gregkh@linuxfoundation.org
List-Id: linux-api@vger.kernel.org

Hi,

Le 21/07/2015 10:19, Oliver Neukum a =C3=A9crit :
> On Mon, 2015-07-20 at 23:03 +0200, Yann Cantin wrote:

>> diff --git a/drivers/input/misc/ebeam.c b/drivers/input/misc/ebeam.c
>> new file mode 100644
>> index 0000000..79cac51
>> --- /dev/null
>> +++ b/drivers/input/misc/ebeam.c

>> +/* Electronics For Imaging, Inc */
>> +#define USB_VENDOR_ID_EFI	0x2650
>
> You are defining these IDs twice. That is not good.

Is it okay to do this :

#if !defined(CONFIG_INPUT_EBEAM_USB)
#define USB_VENDOR_ID_EFI	0x2650
#...
#endif

so that the driver can also be build outside the kernel tree ?

thanks,

--=20
Yann Cantin
A4FEB47F
--
