From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2] st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
Date: Wed, 24 Jun 2015 09:02:13 +0200
Message-ID: <558A55F5.1070302@suse.de>
References: <DDB9C85B850785449757F9914A034FCB3F8E9E02@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3F8E9E02-MCKW7lC+H9ISZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/24/2015 08:54 AM, Seymour, Shane M wrote:
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

Reviewed-by: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
