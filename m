From: Nathan Hjelm <hjelmn@me.com>
Subject: Re: [OMPI devel] [PATCH v5 0/4] vm: add a syscall to map a process memory into a pipe
Date: Mon, 26 Feb 2018 09:38:19 -0700
Message-ID: <B9A6330F-48FE-4260-A505-3FF043874F0F@me.com>
References: <1515479453-14672-1-git-send-email-rppt@linux.vnet.ibm.com> <20180220164406.3ec34509376f16841dc66e34@linux-foundation.org> <3122ec5a-7f73-f6b4-33ea-8c10ef32e5b0@virtuozzo.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6A54AC93-1F7E-43B9-A4A6-B8E2291C2347"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <gdb-return-46335-gdb-gdb=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:gdb-unsubscribe-gdb-gdb=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:gdb-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/gdb/>
List-Post: <mailto:gdb@sourceware.org>
List-Help: <mailto:gdb-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: gdb-owner@sourceware.org
In-reply-to: <3122ec5a-7f73-f6b4-33ea-8c10ef32e5b0@virtuozzo.com>
To: Open MPI Developers <devel@lists.open-mpi.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Andrei Vagin <avagin@openvz.org>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, rr-dev@mozilla.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, criu@openvz.org, linux-mm@kvack.org, Greg KH <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, gdb@sourceware.org, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org


--Apple-Mail=_6A54AC93-1F7E-43B9-A4A6-B8E2291C2347
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

All MPI implementations have support for using CMA to transfer data between=
 local processes. The performance is fairly good (not as good as XPMEM) but=
 the interface limits what we can do with to remote process memory (no atom=
ics). I have not heard about this new proposal. What is the benefit of the =
proposed calls over the existing calls?

-Nathan

> On Feb 26, 2018, at 2:02 AM, Pavel Emelyanov <xemul@virtuozzo.com> wrote:
>=20
> On 02/21/2018 03:44 AM, Andrew Morton wrote:
>> On Tue,  9 Jan 2018 08:30:49 +0200 Mike Rapoport <rppt@linux.vnet.ibm.co=
m> wrote:
>>=20
>>> This patches introduces new process_vmsplice system call that combines
>>> functionality of process_vm_read and vmsplice.
>>=20
>> All seems fairly strightforward.  The big question is: do we know that
>> people will actually use this, and get sufficient value from it to
>> justify its addition?
>=20
> Yes, that's what bothers us a lot too :) I've tried to start with finding=
 out if anyone
> used the sys_read/write_process_vm() calls, but failed :( Does anybody kn=
ow how popular
> these syscalls are? If its users operate on big amount of memory, they co=
uld benefit from
> the proposed splice extension.
>=20
> -- Pavel
> _______________________________________________
> devel mailing list
> devel@lists.open-mpi.org
> https://lists.open-mpi.org/mailman/listinfo/devel


--Apple-Mail=_6A54AC93-1F7E-43B9-A4A6-B8E2291C2347
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2GIIdNgp/fA6+otZb+5NXWbsZioFAlqUN/sACgkQb+5NXWbs
Ziqqvg//VVpRs73U8FH12mV10hzJmQEVssOgHVrroVBeg0oRjVFsUp8fJxxvV9iC
DZ+yylG7T5K7V1ixlbv1Uw9nj79CB99HQuTtXARv7Rab2opcWWh2MktEV9+8iM7f
xCXc+JCQfd6ncL/codqUTry+F++1K3fIanRj2/TtK0fr45uNODAPxS8FIxMl5NYg
hym0BEmZkwKm5BKZbWqlDq3ES2HSrIHHXw33liTJcWQSnmsV1KLWMPvJwVWKF/s2
eyrLBASiwbNw+BkZXY3LSqRRXU8pJM1HQo4PKsiMp+caBGypeSgq4WDn6i9vmfFW
qUZmtNYzlnpFLNiFJBIfPYIoYrsondHCDD7U7V2tS+j70hG5/5apj3Mgu4mBBm5L
DQpfyiCPLE6objfpt1qd+fqWTLNpbQAS1elctmxqDL1MgXQXrjMgOrbZJPLUzP5q
6EfTw09wOUjtpl6dmB5g4UvnJztTRTHGTkS/DNl6UhSnGGK7EC442hAhkMjs8/Yh
zbc6/LxXu8B7k5VBopKx8nxISbq00A1Y1loPlsOaKx581RsUaIrpl1bUx3t62QzC
8MbuNZWqj4ogv2VIxJBP3h/YI8Hedzjckzy/aHVkwyj5N+iHjHmXGGPFm/7q9lm/
os5LIAQQ/F5pE1wqZq3EE3XLSXMP8fU2q+YjaVYXr7a+IX4MVbM=
=HLfy
-----END PGP SIGNATURE-----

--Apple-Mail=_6A54AC93-1F7E-43B9-A4A6-B8E2291C2347--
