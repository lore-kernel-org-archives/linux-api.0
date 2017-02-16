From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v4 4/4] seccomp: Add tests for SECCOMP_RET_LOG
Date: Thu, 16 Feb 2017 12:42:00 -0600
Message-ID: <ee04536c-eb1c-6a5c-5da6-f475657c8f84@canonical.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
	<1487044559-6351-5-git-send-email-tyhicks@canonical.com>
	<CAGXu5jJYaQTB6g-wgg5TXijVm-LYs6zoUK_GsNh5+ZAF3xMtSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8965954315910576065=="
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <CAGXu5jJYaQTB6g-wgg5TXijVm-LYs6zoUK_GsNh5+ZAF3xMtSA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Kees Cook <keescook@chromium.org>
Cc: Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, linux-audit@redhat.com, John Crispin <john@phrozen.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============8965954315910576065==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature";
	boundary="jF9g0alAniCg1dWtavBwvISQxgToVLRNJ"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jF9g0alAniCg1dWtavBwvISQxgToVLRNJ
Content-Type: multipart/mixed; boundary="5aaMRVN6npKBfH25mxNwCkBknlrigaF70";
	protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
	linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
	John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <ee04536c-eb1c-6a5c-5da6-f475657c8f84@canonical.com>
Subject: Re: [PATCH v4 4/4] seccomp: Add tests for SECCOMP_RET_LOG
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
	<1487044559-6351-5-git-send-email-tyhicks@canonical.com>
	<CAGXu5jJYaQTB6g-wgg5TXijVm-LYs6zoUK_GsNh5+ZAF3xMtSA@mail.gmail.com>
In-Reply-To: <CAGXu5jJYaQTB6g-wgg5TXijVm-LYs6zoUK_GsNh5+ZAF3xMtSA@mail.gmail.com>

--5aaMRVN6npKBfH25mxNwCkBknlrigaF70
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/15/2017 07:13 PM, Kees Cook wrote:
> On Mon, Feb 13, 2017 at 7:55 PM, Tyler Hicks <tyhicks@canonical.com> wr=
ote:
>> Extend the kernel selftests for seccomp to test the newly added
>> SECCOMP_RET_LOG action. The added tests follow the example of existing=

>> tests.
>>
>> Unfortunately, the tests are not capable of inspecting the audit log t=
o
>> verify that the syscall was logged.
>=20
> It could try to read dmesg... :P But I don't need that for this patch,
> though maybe add it to the test's TODO list?

Sure thing!

Tyler

>=20
> -Kees
>=20



--5aaMRVN6npKBfH25mxNwCkBknlrigaF70--

--jF9g0alAniCg1dWtavBwvISQxgToVLRNJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYpfJ4AAoJENaSAD2qAscK0FEP/0/YZUSMji20C0FqHIVyAnuy
wLUjVpNOXH4h0klQLHnEZb3rz6U+a97fc2YNZ35alLJETMlKhvzSStCHLymz34qw
Rq/eBS5BX/R26o+uur0GcgsXInBfCzXm1IAi6O4il/reCIEPGSP37KX+lfxTl/9S
Qf7Mi185Os53vwpeb9fwnG03vPYscVI8UQpnas5axFXeJ/hqyAwweltE9z7JdMHk
2srAMdEduTqHzSs6kJMTy/jUgjD75iYv0jHIBEUp2BPKofBQsB2oIJQuZbHjZYWZ
37IdADTDqYKMSZKwO+1dt9XMmQeFRvP2B14kVKw6nLboKQvRFNN+2m/eQJpTEf1H
WcqrEsdO3oVzXYaTUtKtmm9ETlBRauViCSbVxD80Sx0sxExbVEvzioYkTnYoD5PG
CwL4TU11D5JoG2rV9AjZnm0u3eipV+iyvvW3KRwDyeA8rjOkLL8eASH1IL+YK0QY
pcGa4vwgjnsmsYfuGLBa99DtrbBOFisuHa0nxgudxbZXuWiebY4RLOU66YxAWZqF
H7HWupZio7tAccxea290flUBHn2TbwicTQEx8neosDH62exIS/XrmSSh5P3Uxh9p
5+pb9zyK6X76EzbAtIcCtdSzkXrbt14w+teTRd//HqOkAIDPhKXmm5iSlsFOU6xh
sTbtb3QIjhMWXIkcaMg9
=lVQA
-----END PGP SIGNATURE-----

--jF9g0alAniCg1dWtavBwvISQxgToVLRNJ--


--===============8965954315910576065==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8965954315910576065==--
