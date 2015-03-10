From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] kbuild: Don't pass -rR to selftest makefiles
Date: Tue, 10 Mar 2015 17:39:11 -0600
Message-ID: <54FF809F.7020205@osg.samsung.com>
References: <1425464362-28876-1-git-send-email-mpe@ellerman.id.au> <54FDAE28.6050801@osg.samsung.com> <54FE2377.9040709@osg.samsung.com> <1426030567.20917.3.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426030567.20917.3.camel@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org, davej@codemonkey.org.uk, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/10/2015 05:36 PM, Michael Ellerman wrote:
> On Mon, 2015-03-09 at 16:49 -0600, Shuah Khan wrote:
>> On 03/09/2015 08:28 AM, Shuah Khan wrote:
>>> On 03/04/2015 03:19 AM, Michael Ellerman wrote:
>>>> The makefiles under tools/testing/selftests are not real kbuild
>>>> makefiles, they are regular stand alone makefiles. As such they *d=
o*
>>>> want all the standard implicit rules and variables defined.
>>>>
>>>> So before calling those makefiles, filter -rR out of MAKEFLAGS.
>>>>
>>>> Without this not all the selftests are built correctly when called=
 via
>>>> the top-level Makefile.
>>>>
>>>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>>
>>> Hi Michal,
>>>
>>> Could you please take this patch in your tree.
>>>
>>> Acked-by: Shuah Khan <shuahkh@osg.samsung.com>
>>>
>>
>> I am changing this to a Nack. This is not fully cooked.
>> I am seeing new failures on some tests.
>>
>> gcc: error: elf_x86_64: No such file or directory
>> gcc: error: unrecognized command line option =E2=80=98-m=E2=80=99
>=20
> I can't reproduce that here. In what way do you think it's related to=
 this
> patch?
>=20
> cheers

I have just your patch on tops of linux 4.0-rc3 and ran
make kselftest and that's what I see.

If you can fix this problem I can take your patch, otherwise,
I have to go with individual Makefiles fixes.

-- Shuah


--=20
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
