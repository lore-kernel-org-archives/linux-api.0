From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH v2 3/3] falloc: expose ioctl numbers into uapi
Date: Tue, 06 Oct 2015 16:43:51 +0200
Message-ID: <1444142631.3188.53.camel@opteya.com>
References: <1444141657-14898-1-git-send-email-gabriel@lse.epita.fr>
	 <1444141657-14898-4-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444141657-14898-4-git-send-email-gabriel@lse.epita.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Gabriel Laskar <gabriel@lse.epita.fr>, Dave Chinner <dchinner@redhat.com>, Ashish Sangwan <a.sangwan@samsung.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le mardi 06 octobre 2015 =C3=A0 16:27 +0200, Gabriel Laskar a =C3=A9cri=
t :
> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> ---
>=20
> v2: missed the include of <linux/types.h>
>=20
>  include/linux/falloc.h      | 18 ------------------
>  include/uapi/linux/falloc.h | 20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 18 deletions(-)
>=20
> diff --git a/include/uapi/linux/falloc.h
> b/include/uapi/linux/falloc.h
> index 3e445a7..28abee4 100644
> --- a/include/uapi/linux/falloc.h
> +++ b/include/uapi/linux/falloc.h
> @@ -1,6 +1,8 @@
>  #ifndef _UAPI_FALLOC_H_
>  #define _UAPI_FALLOC_H_
> =20
> +#include <linux/types.h>
> +

You should also add #include <linux/ioctl.h> for _IOW() macro

>  #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
>  #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
>  #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */
> @@ -58,4 +60,22 @@
>   */
>  #define FALLOC_FL_INSERT_RANGE		0x20
> =20
> +
> +/*
> + * Space reservation ioctls and argument structure
> + * are designed to be compatible with the legacy XFS ioctls.
> + */
> +struct space_resv {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start;
> +	__s64		l_len;		/* len =3D=3D 0 means
> until end of file */
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserved area */
> +};
> +
> +#define FS_IOC_RESVSP		_IOW('X', 40, struct
> space_resv)
> +#define FS_IOC_RESVSP64		_IOW('X', 42, struct
> space_resv)
> +
>  #endif /* _UAPI_FALLOC_H_ */


Regards.

--=20
Yann Droneaud
OPTEYA
