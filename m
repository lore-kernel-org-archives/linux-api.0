From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] kbuild: Don't pass -rR to selftest makefiles
Date: Mon, 09 Mar 2015 16:49:27 -0600
Message-ID: <54FE2377.9040709@osg.samsung.com>
References: <1425464362-28876-1-git-send-email-mpe@ellerman.id.au> <54FDAE28.6050801@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54FDAE28.6050801-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, mmarek-AlSwsSmVLrQ@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/09/2015 08:28 AM, Shuah Khan wrote:
> On 03/04/2015 03:19 AM, Michael Ellerman wrote:
>> The makefiles under tools/testing/selftests are not real kbuild
>> makefiles, they are regular stand alone makefiles. As such they *do*
>> want all the standard implicit rules and variables defined.
>>
>> So before calling those makefiles, filter -rR out of MAKEFLAGS.
>>
>> Without this not all the selftests are built correctly when called v=
ia
>> the top-level Makefile.
>>
>> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
>=20
> Hi Michal,
>=20
> Could you please take this patch in your tree.
>=20
> Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
>=20

I am changing this to a Nack. This is not fully cooked.
I am seeing new failures on some tests.

gcc: error: elf_x86_64: No such file or directory
gcc: error: unrecognized command line option =91-m=92

thanks,
-- Shuah


--=20
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
