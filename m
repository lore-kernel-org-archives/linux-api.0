From: Joey Pabalinas <joeypabalinas@gmail.com>
Subject: Re: [PATCH RESEND v3 1/3] ptrace: pass type of a syscall-stop in
 ptrace_message
Date: Sat, 24 Nov 2018 15:54:02 -1000
Message-ID: <20181125015402.glcaw3kghcu4pr22@gmail.com>
References: <20181125022150.46258a20@akathisia>
 <20181125022227.55e8caf7@akathisia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vdbkloxosvqpo44e"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181125022227.55e8caf7@akathisia>
Sender: linux-kernel-owner@vger.kernel.org
To: Elvira Khabirova <lineprinter@altlinux.org>
Cc: oleg@redhat.com, rostedt@goodmis.org, mingo@redhat.com, linux-api@vger.kernel.org, esyr@redhat.com, linux-kernel@vger.kernel.org, luto@kernel.org, ldv@altlinux.org, strace-devel@lists.strace.io, Joey Pabalinas <joeypabalinas@gmail.com>
List-Id: linux-api@vger.kernel.org


--vdbkloxosvqpo44e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 25, 2018 at 02:22:27AM +0100, Elvira Khabirova wrote:
> Define two constants, PTRACE_EVENTMSG_SYSCALL_ENTRY and
> PTRACE_EVENTMSG_SYSCALL_EXIT, and place them in ptrace_message
> for the duration of syscall-stops.
> This way ptracers can distinguish syscall-enter-stops
> from syscall-exit-stops using PTRACE_GETEVENTMSG request.

Is there an advantage to using two constants instead of a single
sys_exit bit (set/unset for syscall-exit-stop/syscall-enter-stop)?

--=20
Cheers,
Joey Pabalinas

--vdbkloxosvqpo44e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEENpTlWU2hUK/KMvHp2rGdfm9DtVIFAlv6ALkACgkQ2rGdfm9D
tVLi0Q//UPIcLhCeeQC2SfdW8U7Ul0C9+7Ox/YhYslXMK95uwdUZAjdfomhPHKr2
Q6mraLrDgIaHygDKqX3FWkuFlOPWw+LHIV6xnpPotbQAT16JHWXnu/EqcRF5GQ43
Hz/0GUcgBAGiPeiINvgl56E74hUyikVKPf3ppKV5PhQvoD0lDR0Ko2HYepJaG4KH
aglOle74Cf0hBy9zHGRFs36fWrFSepaBGYIlYAm598IsaUEqA/yFbZQiSgGfVjr/
XhZpj1G22Vk8xXjPHWFWk7wCblGoIleRXVT0EShu2ZUt79BUT0xUxrYyqpmT5SVZ
PiCgiYKmeEmpS18AVDVCbQXzYkJ3lqzbrSqaCcY0h0OrVZ8YShXBO7L2lrlLQAkk
0P3o08duYbRfdTJzmcLA7gpJpI8yFuQKb55sgBLZT1OBisWkDoQSqtpzzoKlPw7f
mD0WyexCFkrUxAEk2W7ZZ6FzrNKth7VHWDy/X3hQs56bTNCOEJITFY01GMODfI4E
V6jDwElAauUUNMeuYIG4LKmbD9LMBEEutxnQ2BhzYXPGI6q/LIA3KKuI5/Ktqg0A
DiEVTYMdsHFpjmZNXRGlP5lPjN4zxUo5F+MoiOefpUT4oPxOcMEbWiMzeChjK9xT
iD8fU8oxLYS9wiaBvUM0Bx0Ia5d0K8f++zHpuhLdF6WIiS6A4Dk=
=KbCj
-----END PGP SIGNATURE-----

--vdbkloxosvqpo44e--
