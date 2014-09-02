From: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add usb_functionfs_descs_head_v2
Date: Tue, 02 Sep 2014 14:45:44 +0200
Message-ID: <xa1twq9mry13.fsf@mina86.com>
References: <20140902065836.GA23094@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140902065836.GA23094@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbi@ti.com, mgautam@codeaurora.org, andrzej.p@samsung.com
Cc: jin.can.zhuang@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, david.a.cohen@intel.com, hang.yuan@intel.com
List-Id: linux-api@vger.kernel.org

On Tue, Sep 02 2014, Zhuang Jin Can <jin.can.zhuang@intel.com> wrote:
> Add usb_functionfs_descs_head_v2 structure for the new layout of
> descriptors.

NAK.  It's a duplicate of <https://lkml.org/lkml/2014/6/6/128> and even
more importantly, the format of the header is not fixed past the flags
field (e.g. fs_count may be missing), so fs_count, hs_count and ss_coun=
t
cannot be in the structure.

> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>
> ---
>  include/uapi/linux/usb/functionfs.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux=
/usb/functionfs.h
> index 0154b28..0b3f9fc 100644
> --- a/include/uapi/linux/usb/functionfs.h
> +++ b/include/uapi/linux/usb/functionfs.h
> @@ -32,6 +32,15 @@ struct usb_endpoint_descriptor_no_audio {
>  	__u8  bInterval;
>  } __attribute__((packed));
> =20
> +struct usb_functionfs_descs_head_v2 {
> +	__le32 magic;
> +	__le32 length;
> +	__le32 flags;
> +	__le32 fs_count;
> +	__le32 hs_count;
> +	__le32 ss_count;
> +} __attribute__((packed));
> +
>  /* Legacy format, deprecated as of 3.14. */
>  struct usb_functionfs_descs_head {
>  	__le32 magic;

--=20
Best regards,                                         _     _
=2Eo. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
=2E.o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarew=
icz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
