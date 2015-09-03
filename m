From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests: add membarrier syscall test
Date: Thu, 03 Sep 2015 19:24:48 +1000
Message-ID: <1441272288.26379.1.camel@ellerman.id.au>
References: <1436561912-24365-1-git-send-email-mathieu.desnoyers@efficios.com>
	 <1436561912-24365-3-git-send-email-mathieu.desnoyers@efficios.com>
	 <1441004040.5735.7.camel@ellerman.id.au>
	 <1071313434.33305.1441127478843.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1071313434.33305.1441127478843.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pranith Kumar <bobby.prani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-09-01 at 17:11 +0000, Mathieu Desnoyers wrote:
> ----- On Aug 31, 2015, at 2:54 AM, Michael Ellerman mpe-Gsx/Oe8HsFi6NASR9rTEaw@public.gmane.org=
u wrote:
> > On Fri, 2015-07-10 at 16:58 -0400, Mathieu Desnoyers wrote:
> >> diff --git a/tools/testing/selftests/membarrier/membarrier_test.c
> >> b/tools/testing/selftests/membarrier/membarrier_test.c
> >> new file mode 100644
> >> index 0000000..3c9f217
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/membarrier/membarrier_test.c
> >> @@ -0,0 +1,71 @@
> >> +#define _GNU_SOURCE
> >> +#define __EXPORTED_HEADERS__
> >=20
> > Why are you exporting that?
> >=20
> > I suspect to try and get around the "Attempt to use kernel headers =
from user
> > space" warning.
> >=20
> > But you're correctly building against the installed headers, not th=
e kernel
> > headers, so you don't need to do that.
>=20
> Just to make sure I understand: should we expect that
> everyone will issue "make headers_install" on their system
> before doing a make kselftest ?

Usually yes, but not always.

They might be deliberately building the selftests against their install=
ed
headers. That's their choice.

In a case like this the test will fail to build, which is fine IMHO.

> I see that a few selftests (e.g. memfd) are adding the
> source tree include paths to the compiler include paths,
> which I guess is to ensure that the kselftest will
> work even if the system headers are not up to date.

Yeah they should be fixed to not do that. The unexported kernel headers=
 are not
designed to be used from userspace. It works sometimes on some arches,
depending on the exact headers that get included etc. But it's wrong=E2=
=84=A2.

cheers
