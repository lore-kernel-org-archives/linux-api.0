From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] fs, proc: add help for CONFIG_PROC_CHILDREN
Date: Thu, 09 Jul 2015 11:04:16 +0200
Message-ID: <1436432656.4741.5.camel@chaos.site>
References: <1436387284-3998-1-git-send-email-iago@endocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436387284-3998-1-git-send-email-iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Iago =?ISO-8859-1?Q?L=F3pez?= Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Djalal Harouni <djalal-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Le Wednesday 08 July 2015 =C3=A0 22:28 +0200, Iago L=C3=B3pez Galeiras =
a =C3=A9crit :
> The purpose of the option was documented in
> Documentation/filesystems/proc.txt but the help text was missing.
>=20
> Add small help text that also points to the documentation.
>=20
> Signed-off-by: Iago L=C3=B3pez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
> ---
>  fs/proc/Kconfig | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index d751fcb..1ade120 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -75,3 +75,9 @@ config PROC_PAGE_MONITOR
>  config PROC_CHILDREN
>  	bool "Include /proc/<pid>/task/<tid>/children file"
>  	default n
> +	help
> +	  Provides a fast way to retrieve first level children pids of a ta=
sk. See
> +	  <file:Documentation/filesystems/proc.txt> for more information.
> +
> +	  Say Y if you are running any user-space software which takes bene=
fit from
> +	  this interface. For example, rkt is such a piece of software.

Thanks for doing that.

Reviewed-by: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>

--=20
Jean Delvare
SUSE L3 Support
