From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: RFC(v2): Audit Kernel Container IDs
Date: Sat, 9 Dec 2017 11:20:48 +0100
Message-ID: <7ebca85a-425c-2b95-9a5f-59d81707339e@digikod.net>
References: <20171012141359.saqdtnodwmbz33b2@madcap2.tricolour.ca>
 <75b7d6a6-42ba-2dff-1836-1091c7c024e7@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="5DS20X9VhgecTVVW8xNVvheqxKAC9uLlu"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75b7d6a6-42ba-2dff-1836-1091c7c024e7-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5DS20X9VhgecTVVW8xNVvheqxKAC9uLlu
Content-Type: multipart/mixed; boundary="QGDc1o6vhukr6jaTrhkTtq2q2Krwn30pv";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>,
 Richard Guy Briggs <rgb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>,
 Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Audit <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>,
 Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
 Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org,
 Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Message-ID: <7ebca85a-425c-2b95-9a5f-59d81707339e-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: Re: RFC(v2): Audit Kernel Container IDs
References: <20171012141359.saqdtnodwmbz33b2-bcJWsdo4jJjeVoXN4CMphl7TgLCtbB0G@public.gmane.org>
 <75b7d6a6-42ba-2dff-1836-1091c7c024e7-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
In-Reply-To: <75b7d6a6-42ba-2dff-1836-1091c7c024e7-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>

--QGDc1o6vhukr6jaTrhkTtq2q2Krwn30pv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable


On 12/10/2017 18:33, Casey Schaufler wrote:
> On 10/12/2017 7:14 AM, Richard Guy Briggs wrote:
>> Containers are a userspace concept.  The kernel knows nothing of them.=

>>
>> The Linux audit system needs a way to be able to track the container
>> provenance of events and actions.  Audit needs the kernel's help to do=

>> this.
>>
>> Since the concept of a container is entirely a userspace concept, a
>> registration from the userspace container orchestration system initiat=
es
>> this.  This will define a point in time and a set of resources
>> associated with a particular container with an audit container ID.
>>
>> The registration is a pseudo filesystem (proc, since PID tree already
>> exists) write of a u8[16] UUID representing the container ID to a file=

>> representing a process that will become the first process in a new
>> container.  This write might place restrictions on mount namespaces
>> required to define a container, or at least careful checking of
>> namespaces in the kernel to verify permissions of the orchestrator so =
it
>> can't change its own container ID.  A bind mount of nsfs may be
>> necessary in the container orchestrator's mntNS.
>> Note: Use a 128-bit scalar rather than a string to make compares faste=
r
>> and simpler.
>>
>> Require a new CAP_CONTAINER_ADMIN to be able to carry out the
>> registration.
>=20
> Hang on. If containers are a user space concept, how can
> you want CAP_CONTAINER_ANYTHING? If there's not such thing as
> a container, how can you be asking for a capability to manage
> them?
>=20
>>   At that time, record the target container's user-supplied
>> container identifier along with the target container's first process
>> (which may become the target container's "init" process) process ID
>> (referenced from the initial PID namespace), all namespace IDs (in the=

>> form of a nsfs device number and inode number tuple) in a new auxillia=
ry
>> record AUDIT_CONTAINER with a qualifying op=3D$action field.

Here is an idea to avoid privilege problems or the need for a new
capability: make it automatic. What makes a container a container seems
to be the use of at least a namespace. What about automatically create
and assign an ID to a process when it enters a namespace different than
one of its parent process? This delegates the (permission)
responsibility to the use of namespaces (e.g. /proc/sys/user/max_* limit)=
=2E

One interesting side effect of this approach would be to be able to
identify which processes are in the same set of namespaces, even if not
spawn from the container but entered after its creation (i.e. using
setns), by creating container IDs as a (deterministic) checksum from the
/proc/self/ns/* IDs.

Since the concern is to identify a container, I think the ability to
audit the switch from one container ID to another is enough. I don't
think we need nested IDs.

As a side note, you may want to take a look at the Linux-VServer's XID.

Regards,
 Micka=EBl


--QGDc1o6vhukr6jaTrhkTtq2q2Krwn30pv--

--5DS20X9VhgecTVVW8xNVvheqxKAC9uLlu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAloruQUACgkQIt7+33O9
apUJFgf/a2a5wJF16U89qtxT53Tdxz2ILPBOcQzYNeLHPoJURcIWelgS/g1KZ2Xo
elaWkhEkUFqCuoaTPcUuELZphkr/M+tOYgfjNyvG4k8Q0bsn2OrdVfuSRYeLt8G0
8Jwt3gLPqQFUVj2W8F0ldw07ERSTxaML5NKPj4Acu60qWYKbRiXfFJFVNNWJXpKW
IfMdy8mkU7IrLNlrxRc6VUGs/sJXA54uMQVAy730/BFwwSkb3EYktWl03VzjYO/N
ovANuNFhL2ocIgEgjHBYV5zdL7HlE3pFmkiiPKYgtjFjvlxYcJ7NMDjaHnQFQR2h
88zji87kj051njI0Hhc2kbejUyoH2A==
=LLoq
-----END PGP SIGNATURE-----

--5DS20X9VhgecTVVW8xNVvheqxKAC9uLlu--
