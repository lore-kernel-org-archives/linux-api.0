From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] kbuild: Don't pass -rR to selftest makefiles
Date: Wed, 11 Mar 2015 10:36:07 +1100
Message-ID: <1426030567.20917.3.camel@ellerman.id.au>
References: <1425464362-28876-1-git-send-email-mpe@ellerman.id.au>
	 <54FDAE28.6050801@osg.samsung.com> <54FE2377.9040709@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FE2377.9040709-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: mmarek-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 2015-03-09 at 16:49 -0600, Shuah Khan wrote:
> On 03/09/2015 08:28 AM, Shuah Khan wrote:
> > On 03/04/2015 03:19 AM, Michael Ellerman wrote:
> >> The makefiles under tools/testing/selftests are not real kbuild
> >> makefiles, they are regular stand alone makefiles. As such they *d=
o*
> >> want all the standard implicit rules and variables defined.
> >>
> >> So before calling those makefiles, filter -rR out of MAKEFLAGS.
> >>
> >> Without this not all the selftests are built correctly when called=
 via
> >> the top-level Makefile.
> >>
> >> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> >=20
> > Hi Michal,
> >=20
> > Could you please take this patch in your tree.
> >=20
> > Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> >=20
>=20
> I am changing this to a Nack. This is not fully cooked.
> I am seeing new failures on some tests.
>=20
> gcc: error: elf_x86_64: No such file or directory
> gcc: error: unrecognized command line option =E2=80=98-m=E2=80=99

I can't reproduce that here. In what way do you think it's related to t=
his
patch?

cheers
