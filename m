From: "Dmitry V. Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v5 24/25] ptrace: add PTRACE_GET_SYSCALL_INFO request
Date: Mon, 10 Dec 2018 19:21:32 +0300
Message-ID: <20181210162131.GG14149@altlinux.org>
References: <20181210042352.GA6092@altlinux.org>
 <20181210043126.GX6131@altlinux.org>
 <20181210141107.GB4177@redhat.com>
Reply-To: strace development discussions <strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6597632408533209653=="
Return-path: <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
In-Reply-To: <20181210141107.GB4177-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.strace.io/mailman/options/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.strace.io/pipermail/strace-devel/>
List-Post: <mailto:strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
List-Help: <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.strace.io/mailman/listinfo/strace-devel>,
 <mailto:strace-devel-request-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org?subject=subscribe>
Errors-To: strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
Sender: "Strace-devel" <strace-devel-bounces-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org>
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eugene Syromyatnikov <esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============6597632408533209653==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 10, 2018 at 03:11:07PM +0100, Oleg Nesterov wrote:
> On 12/10, Dmitry V. Levin wrote:
> >
> > +struct ptrace_syscall_info {
> > +	__u8 op;	/* PTRACE_SYSCALL_INFO_* */
> > +	__u8 __pad0[3];
> > +	__u32 arch;
> > +	__u64 instruction_pointer;
> > +	__u64 stack_pointer;
> > +	__u64 frame_pointer;
> > +	union {
> > +		struct {
> > +			__u64 nr;
> > +			__u64 args[6];
> > +		} entry;
> > +		struct {
> > +			__s64 rval;
> > +			__u8 is_error;
> > +			__u8 __pad1[7];
> > +		} exit;
> > +		struct {
> > +			__u64 nr;
> > +			__u64 args[6];
> > +			__u32 ret_data;
> > +			__u8 __pad2[4];
> > +		} seccomp;
> > +	};
> > +};
>=20
> Could you explain why ptrace_syscall_info needs __pad{0,1,2} ? I simply c=
an't
> understand why...

I suppose the idea behind the use of these pads was to make the structure
arch-independent.

I don't think we really need to keep it exactly the same on all
architectures - the only practical requirement is to avoid any compat
issues, but I don't mind keeping the structure arch-independent.


--=20
ldv

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJcDpKLAAoJEAVFT+BVnCUIQyQQAJcBexpZkT3KJAUbsDkRfHtd
gkDtUKrgIj6BpEzYUbIn6I8dXNIqyFMJGSh4lMWnhFbDXeHIQ91fNUoH5q/MifC7
PfbzH6ibiOTzflv/1/oTKLJ1RhzITuIlQQb6Xd/3BV+WEhPDs77tNJtPpgIlv+oK
z3Xa/mw3f0RXSAYpuvtCG1IiwWJMoy5YjpLBAWnldCxVH/jeiPU5xoSYl1DKo6Y+
YeNiM/mCEbaYzDWmAPiE5Mntarj3uT2g4XTLnuIFJo38z8jYp3QZwToMcYBFK0zx
i6NbYJ6oaiuUSCZMSM3X8NP2EsmmhVRi+3wc8WnzjqYbLqXa4f47aHunO/S17Bog
/8N5RexkAUM86J3Ho+SMZT3cDFi398vxb2f5gFN6DIPt4GLQYZaefJTc2hWvI7x4
xIm7+27/kSIURbcyVs7g/BtxjApz7kcY5ed3Uh5p2Z9HIxW4/TYiyRhh4P8oRddA
WEWTJaohjwF/QO3VJg7RbzTn2OsCTAX8KfzsEKTxsIIsNWeG+wHm1SSUsmvq+1ep
bDWVq09gvMogfl+U1qdpPhMlyXf5oTAZ9C64ZsUQZGtq0P8PG5M0a3VlT3fhktNV
yCGY93i50BA/fN8aBdMo+oyj8UIP1tZpuY0Lm6QjcNw8lPdBipEDCEi0+cPFwAmc
djVNelGXhg9dLjWz5UgP
=2aij
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--

--===============6597632408533209653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Strace-devel mailing list
Strace-devel-3+4lAyCyj6AWlMsSdNXQLw@public.gmane.org
https://lists.strace.io/mailman/listinfo/strace-devel

--===============6597632408533209653==--
