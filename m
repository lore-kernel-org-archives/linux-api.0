From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH v2] usb: devio: Add ioctl to disallow detaching kernel USB drivers.
Date: Mon, 25 Jan 2016 09:39:43 +0100
Message-ID: <87powqrr1s.fsf@nemi.mork.no>
References: <20160119180752.GA10487@kroah.com>
	<1453420476-26125-1-git-send-email-emilio.lopez@collabora.co.uk>
	<8760ymdk94.fsf@nemi.mork.no> <56A57D0C.6030308@collabora.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56A57D0C.6030308@collabora.co.uk> ("Emilio =?utf-8?Q?L=C3=B3?=
 =?utf-8?Q?pez=22's?= message of
	"Sun, 24 Jan 2016 22:40:28 -0300")
Sender: linux-kernel-owner@vger.kernel.org
To: Emilio =?utf-8?Q?L=C3=B3pez?= <emilio.lopez@collabora.co.uk>
Cc: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, kborer@gmail.com, k.opasiak@samsung.com, reillyg@chromium.org, keescook@chromium.org, linux-api@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, jorgelo@chromium.org, dan.carpenter@oracle.com
List-Id: linux-api@vger.kernel.org

Emilio L=C3=B3pez <emilio.lopez@collabora.co.uk> writes:

>>> diff --git a/include/uapi/linux/usbdevice_fs.h b/include/uapi/linux=
/usbdevice_fs.h
>>> index 019ba1e..9abcb34 100644
>>> --- a/include/uapi/linux/usbdevice_fs.h
>>> +++ b/include/uapi/linux/usbdevice_fs.h
>>> @@ -154,6 +154,10 @@ struct usbdevfs_streams {
>>>   	unsigned char eps[0];
>>>   };
>>>
>>> +struct usbdevfs_drop_privs {
>>> +	unsigned long interface_allowed_mask;
>>> +};
>>> +
>>
>> "unsigned long" isn't a very good choice here, is it?
>
> I went with a type matching ifclaimed on struct usb_dev_state to keep
> the limit the same, but I guess it's not the best idea for an ioctl. =
I
> can switch it to __u32, keeping the runtime check above as is, or use
> __u64. Which one would you prefer?

I don't feel much like an expert here, but I can certainly make up an
opinion anyway :)

Since 64bits kernels allow usb devio with interface numbers up to 63, I
guess you need __u64 to avoid limiting the range?  Limiting will create
all sorts of followup problems, so it's definitely easiest to just go
with __u64.



Bj=C3=B8rn
