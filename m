From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [RFC v1 05/17] security/seccomp: Add LSM and create arrays of
 syscall metadata
Date: Thu, 24 Mar 2016 22:31:28 +0100
Message-ID: <56F45CB0.6090706@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458784008-16277-6-git-send-email-mic@digikod.net>
 <56F40F3F.90708@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="7SKCddFWUP08tXLAwQauobKbAPMgQ98Jj"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56F40F3F.90708-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7SKCddFWUP08tXLAwQauobKbAPMgQ98Jj
Content-Type: multipart/mixed; boundary="K31KWg7FmPSxvhxUCjl2UVocdQKqhDDNP"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>,
 linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>,
 David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>,
 Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>,
 Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>,
 Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>,
 Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Message-ID: <56F45CB0.6090706-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: [RFC v1 05/17] security/seccomp: Add LSM and create arrays of
 syscall metadata
References: <1458784008-16277-1-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
 <1458784008-16277-6-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
 <56F40F3F.90708-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
In-Reply-To: <56F40F3F.90708-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>

--K31KWg7FmPSxvhxUCjl2UVocdQKqhDDNP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 24/03/2016 17:01, Casey Schaufler wrote:
> On 3/23/2016 6:46 PM, Micka=C3=ABl Sala=C3=BCn wrote:
>> diff --git a/security/seccomp/lsm.c b/security/seccomp/lsm.c
>> new file mode 100644
>> index 000000000000..93c881724341
>> --- /dev/null
>> +++ b/security/seccomp/lsm.c
>> @@ -0,0 +1,87 @@
>> +/*
>> + * Seccomp Linux Security Module
>> + *
>> + * Copyright (C) 2016  Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modi=
fy
>> + * it under the terms of the GNU General Public License version 2, as=

>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <asm/syscall.h>	/* sys_call_table */
>> +#include <linux/compat.h>
>> +#include <linux/slab.h>	/* kcalloc() */
>> +#include <linux/syscalls.h>	/* syscall_argdesc */
>> +
>> +#include "lsm.h"
>> +
>> +/* TODO: Remove the need for CONFIG_SYSFS dependency */
>> +
>> +struct syscall_argdesc (*seccomp_syscalls_argdesc)[] =3D NULL;
>> +#ifdef CONFIG_COMPAT
>> +struct syscall_argdesc (*compat_seccomp_syscalls_argdesc)[] =3D NULL;=

>> +#endif	/* CONFIG_COMPAT */
>> +
>> +static const struct syscall_argdesc *__init
>> +find_syscall_argdesc(const struct syscall_argdesc *start,
>> +		const struct syscall_argdesc *stop, const void *addr)
>> +{
>> +	if (unlikely(!addr || !start || !stop)) {
>> +		WARN_ON(1);
>> +		return NULL;
>> +	}
>> +
>> +	for (; start < stop; start++) {
>> +		if (start->addr =3D=3D addr)
>> +			return start;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +static inline void __init init_argdesc(void)
>> +{
>> +	const struct syscall_argdesc *argdesc;
>> +	const void *addr;
>> +	int i;
>> +
>> +	seccomp_syscalls_argdesc =3D kcalloc(NR_syscalls,
>> +			sizeof((*seccomp_syscalls_argdesc)[0]), GFP_KERNEL);
>> +	if (unlikely(!seccomp_syscalls_argdesc)) {
>> +		WARN_ON(1);
>> +		return;
>> +	}
>> +	for (i =3D 0; i < NR_syscalls; i++) {
>> +		addr =3D sys_call_table[i];
>> +		argdesc =3D find_syscall_argdesc(__start_syscalls_argdesc,
>> +				__stop_syscalls_argdesc, addr);
>> +		if (!argdesc)
>> +			continue;
>> +
>> +		(*seccomp_syscalls_argdesc)[i] =3D *argdesc;
>> +	}
>> +
>> +#ifdef CONFIG_COMPAT
>> +	compat_seccomp_syscalls_argdesc =3D kcalloc(IA32_NR_syscalls,
>> +			sizeof((*compat_seccomp_syscalls_argdesc)[0]),
>> +			GFP_KERNEL);
>> +	if (unlikely(!compat_seccomp_syscalls_argdesc)) {
>> +		WARN_ON(1);
>> +		return;
>> +	}
>> +	for (i =3D 0; i < IA32_NR_syscalls; i++) {
>> +		addr =3D ia32_sys_call_table[i];
>> +		argdesc =3D find_syscall_argdesc(__start_compat_syscalls_argdesc,
>> +				__stop_compat_syscalls_argdesc, addr);
>> +		if (!argdesc)
>> +			continue;
>> +
>> +		(*compat_seccomp_syscalls_argdesc)[i] =3D *argdesc;
>> +	}
>> +#endif	/* CONFIG_COMPAT */
>> +}
>> +
>> +void __init seccomp_init(void)
>> +{
>> +	pr_info("seccomp: Becoming ready for sandboxing\n");
>> +	init_argdesc();
>> +}
>=20
> This isn't using the LSM infrastructure at all, is it?
> It looks like the only reason you're calling it a security
> module is to get the initialization code called in
> security_init().
>=20
> Let me amend my previous comment, which was to change
> the name of seccomp_init(). Leave it as is, but add a
> comment before it that explains why you've put the
> call in the midst of the security module initialization.

The patch "[RFC v1 16/17] security/seccomp: Protect against filesystem TO=
CTOU" add LSM hooks, so it make sense to follow your first comment and re=
name seccomp_init() to seccomp_add_hooks().

 Micka=C3=ABl


--K31KWg7FmPSxvhxUCjl2UVocdQKqhDDNP--

--7SKCddFWUP08tXLAwQauobKbAPMgQ98Jj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBCgAGBQJW9FywAAoJECLe/t9zvWqVQ14IAJBDCvbYchK8SbFh3zzhvP/k
r5Kz0XI276kmFRa/WjrxBObrx+BXrPS9nUC7J6F8GQ4pxeDMjm8tfmfZpUcV9Li+
nb12JsPNNUllCaPTu02OayOfQCvVaExmXnTcXgTqhkeP7twvic5Q58jtdUfQISnc
7oE77WERorI+xQ0tw+aLHOH/Q+ymeEvumRTDFE821mmPvO2MQc3LAPjryYnt5KV2
lHdV+OlQzlc7RTWhS1wts+fAgLJQNGrI2OYwMGdLcdy6ef48pO/UjDoGr4fdYXMr
grKQ+rWDUyI9VNSEBCuIj/JGcHGKMbrZ2WUkSXnDF08PzpWxDCXuudrv5DviZq0=
=nB5a
-----END PGP SIGNATURE-----

--7SKCddFWUP08tXLAwQauobKbAPMgQ98Jj--
