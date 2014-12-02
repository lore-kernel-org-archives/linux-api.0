From: Richard Yao <ryao@gentoo.org>
Subject: Re: Why not make kdbus use CUSE?
Date: Tue, 02 Dec 2014 02:59:21 -0500
Message-ID: <547D7159.2040900@gentoo.org>
References: <20141129063416.GE32286@woodpecker.gentoo.org> <20141129175947.GB32510@kroah.com> <547D50B9.9040909@gentoo.org> <20141202054850.GA17043@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jIVDOhKCibpHPwTGknC9fFdlqnQWk0FCF"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141202054850.GA17043@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jIVDOhKCibpHPwTGknC9fFdlqnQWk0FCF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12/02/2014 12:48 AM, Greg Kroah-Hartman wrote:
> On Tue, Dec 02, 2014 at 12:40:09AM -0500, Richard Yao wrote:
>>>> They regard a userland compatibility shim in the systemd repostory t=
o provide
>>>> backward compatibility for applications. Unfortunately, this is insu=
fficient to
>>>> ensure compatibility because dependency trees have multiple levels. =
If cross
>>>> platform package A depends on cross platform library B, which depend=
s on dbus,
>>>> and cross platform library B decides to switch to kdbus, then it cea=
ses to be
>>>> cross platform and cross platform package A is now dependent on Linu=
x kernels
>>>> with kdbus. Not only does that affect other POSIX systems, but it al=
so affects
>>>> LTS versions of Linux.
>>>
>>> What does LTS versions have anything to do here?  And what specific
>>> dependancies are you worried about?
>>
>> Lets say that you have a Linux 3.10 system and you want some package
>> that indirectly depends on the new API due to library dependencies. Yo=
u
>> will have a problem. You could probably install an older version of th=
e
>> library, but if the older version has a CVE, most end users will end u=
p
>> between a rock and a hard place. This situation should merit some
>> consideration because you are taking something that lived previously i=
n
>> userland, modifying it so that anything depending on the modifications=

>> is no longer backward compatible and then tying it to new kernels.
>=20
> Then you need to get a better distro, as any "well run" long-term
> enterprise distro handles stuff like this for you.  Otherwise you need
> to update systems properly.  There's nothing that I can do here to help=

> with that, nor do I ever want to, sorry.

Another option is to include KVM-style kernel compatibility code to
allow the module to be built against older kernels. If you target
2.6.32.y, 3.2.y, 3.4.y and 3.10.y, the risk of people on older Linux
systems being left behind would be minimized.

>> 1. Debugging kernel code is a pain while debugging user code is
>> relatively easy.
>=20
> You have full access to a debugger, what more do you need?  :)

I would prefer not to start bringing userland daemons into the kernel
unless there is no other choice. That way, a wider range of people can
tackle bugs and the code could be applied to a larger number of systems.

> And why would you need to debug the kernel kdbus code?  Is something no=
t
> working properly in it?  Otherwise just use wireshark to read the kdbus=

> data stream and all should be fine.

Putting daemons in the kernel means that we further complicate already
complex relationships with regard to things like memory utilization and
CPU time. It is easier to deal with this in userland where we could
better utilize cgroups.

>> 2. Security vulnerabilities in kernel code give complete access to
>> everything while security vulnerabilities in userspace code can be
>> limited in scope by SELinux.
>=20
> Kernel code is hard, security matters, yes I know this, we all have bee=
n
> doing this for a very long time.  Of course bugs happen, but if you loo=
k
> closely, your "attack surface" is now smaller using kdbus than it was
> using old-style dbus.

Lets say that I have a system running LXC containers, someone does full
disclosure of proof of concept code for an arbitrary code execution zero
day and then someone else tries the exploit in a LXC container on
mysystem. With old-style dbus, only the container is affected and if
selinux is used, then it is possible to restrict daemon to things in the
container using dbus. A FUSE daemon using the new protocol is similar.
However, an in-kernel version not only means that the attacker breaks
out, but he has the ability to execute code with full kernel privileges.
Every Linux container on the system is therefore compromised.

I heard quite clearly at LinuxCon Europe that there are no expected
benefits from using the shim with kdbus such that we have the equivalent
of the original dbus daemon in the kernel, but there were plenty of
benefits from the protocol. If that is the case, it seems that being in
the kernel is not a necessity, but the new protocol is. FUSE might be
somewhat slower than an in-kernel filesystem, but it allows us to
enforce least privilege like we can do now with the current dbus daemon.
We cannot do that with kdbus/kdbusfs. If the reduction in context switch
overhead actually mattered, I would understand the desire to put this
into the kernel, but I have heard quite consistently that the context
switch overhead is not a significant motivation for pushing this code
into the kernel. If it were, the current userland code could have been
adapted into a kernel module.

>> 3. Integration with things like LXC should be easier from userspace,
>> where each container can have its own daemon.
>=20
> How does the current implementation not work properly for this?  The
> filesystem implementation makes this easier than ever, while sticking
> with the character device made this quite difficult in different ways.

As you pointed out, my information was out of date. Making this into a
filesystem is an excellent idea that handles container integration quite
nicely.


--jIVDOhKCibpHPwTGknC9fFdlqnQWk0FCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJUfXFvAAoJECDuEZm+6ExknkcP/0fQBBW3Q80QrGZ5oe7wjh07
iQ3Y8w6Mri/SPhdqzKsJwetteRZ2ZAGI7nwpEiTuK/gk8fZ1PjC/0juaX9kvOoPj
TK+RXWl95j4YVkiW5cuKsIlEpg66eoOqB5sSdPWtzJqKvAN6yAh+0sbR6BN3t9sZ
3/NT6CVzMLIcTG0ISqDDupvGsAxmlWO/jPJULsyCoRCTbT3EgVCXDLK8odtMeYCT
9U48u3ae9K4+SHy5eI4gJYBA2eXdpPo9OudgsIpsAhZoKjgYPK9RxWMyoMyXt6Jp
p0IuGQGX/FzsK8Sce7Jsih+ZW1raF/5yAl44wUYJLMZddzsF+wTqzaqGggN+0COx
MeZ9q23pSTivdAcUzlKN7QaNazcTauNSTKCAnzWAZ40OqtBErzMS07lhCZjXWnVF
MKa3fiKKmXhAlOyQ0v4MkSUM36pRX0aIbOgLFE3u8bw6FeV+gmbAtdeRUlgQcATB
ICWNf8eraQvLWTE7bTOOdlJxE1Z7P0U1cpJ50kgfLijNh26QDdTuhjJHYMwSeaET
uMo9dXl80FDzLkkJ2iylhe4MemaGu7yfhyMuM94nfjtc2kTZC/N2brzBjprMSZ96
1cs3tS619lRV3ENIQgUVAcB/LtdOcreTbBIJ+l6GCmu1sJZ30n/ZaxqM/cEYa6iJ
ldIx2tP3EOuby15VFBfo
=imyd
-----END PGP SIGNATURE-----

--jIVDOhKCibpHPwTGknC9fFdlqnQWk0FCF--
