From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>
Subject: Re: [PATCH v2] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 23:15:26 +0300
Message-ID: <374DC3D5-CA5E-48B8-838A-D95962C39275@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB3F8E9E02@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3F8E9E02-MCKW7lC+H9ISZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


> On 24.6.2015, at 9.54, Seymour, Shane M <shane.seymour-VXdhtT5mjnY@public.gmane.org> wrote:
>=20
>=20
> Convert DRIVER_ATTR macros to DRIVER_ATTR_RO requested by
> Greg KH. Also switched to using scnprintf instead of snprintf
> per Documentation/filesystems/sysfs.txt.
>=20
> Suggested-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
> ---
> This patch was implemented on top of the previous patch to
> convert to using driver attr groups.
>=20
> Changes from v1:
> - switched to scnprintf from sprintf after feedback from Sergey
> Senozhatsky.

Acked-by: Kai M=C3=A4kisara <kai.makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>

Thanks,
Kai
