From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] kbuild: Don't pass -rR to selftest makefiles
Date: Wed, 11 Mar 2015 11:46:14 +1100
Message-ID: <1426034774.20917.5.camel@ellerman.id.au>
References: <1425464362-28876-1-git-send-email-mpe@ellerman.id.au>
	 <54FDAE28.6050801@osg.samsung.com> <54FE2377.9040709@osg.samsung.com>
	 <1426030567.20917.3.camel@ellerman.id.au>
	 <54FF809F.7020205@osg.samsung.com>
	 <1426031386.20917.4.camel@ellerman.id.au>
	 <54FF8DC4.6000900@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FF8DC4.6000900-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: mmarek-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2015-03-10 at 18:35 -0600, Shuah Khan wrote:
> On 03/10/2015 05:49 PM, Michael Ellerman wrote:
> > On Tue, 2015-03-10 at 17:39 -0600, Shuah Khan wrote:
> >> On 03/10/2015 05:36 PM, Michael Ellerman wrote:
> >>> On Mon, 2015-03-09 at 16:49 -0600, Shuah Khan wrote:
> >>>> On 03/09/2015 08:28 AM, Shuah Khan wrote:
> >>>>> On 03/04/2015 03:19 AM, Michael Ellerman wrote:
> >>>>>> The makefiles under tools/testing/selftests are not real kbuil=
d
> >>>>>> makefiles, they are regular stand alone makefiles. As such the=
y *do*
> >>>>>> want all the standard implicit rules and variables defined.
> >>>>>>
> >>>>>> So before calling those makefiles, filter -rR out of MAKEFLAGS=
=2E
> >>>>>>
> >>>>>> Without this not all the selftests are built correctly when ca=
lled via
> >>>>>> the top-level Makefile.
> >>>>>>
> >>>>>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> >>>>>
> >>>>> Hi Michal,
> >>>>>
> >>>>> Could you please take this patch in your tree.
> >>>>>
> >>>>> Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> >>>>>
> >>>>
> >>>> I am changing this to a Nack. This is not fully cooked.
> >>>> I am seeing new failures on some tests.
> >>>>
> >>>> gcc: error: elf_x86_64: No such file or directory
> >>>> gcc: error: unrecognized command line option =E2=80=98-m=E2=80=99
> >>>
> >>> I can't reproduce that here. In what way do you think it's relate=
d to this
> >>> patch?
> >>
> >> I have just your patch on tops of linux 4.0-rc3 and ran
> >> make kselftest and that's what I see.
> >>
> >> If you can fix this problem I can take your patch, otherwise,
> >> I have to go with individual Makefiles fixes.
> >=20
> > OK I see it now, only happens on x86.
> >=20
> > It looks like it's coming in via kbuild. Though I can only see it b=
eing set in
> > arch/x86/Makefile.um, and I don't know why that is being sourced. B=
ut it must
> > be.
> >=20
> > So this is another symptom of running via the top-level Makefile ra=
ther than
> > directly.
> >=20
> > I'll try and find a fix.
>=20
> If you can fix it that is great. I don't see any need to change
> existing Makefiles to delete explicit rules based on this change
> though.

I do. The explicit rules are generally wrong in some way, ie. they use =
flags
inconsistently, or they don't use CROSS_COMPILE when they should.

There should be no need to have explicit rules for simple tests that ju=
st build
a binary from a .c file.

cheers
