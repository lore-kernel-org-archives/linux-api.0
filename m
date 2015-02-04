From: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 04 Feb 2015 17:53:08 +0100
Message-ID: <54D24E74.9010103@ahsoftware.de>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de> <1422896713-25367-2-git-send-email-holler@ahsoftware.de> <20150203060542.GZ29656@ZenIV.linux.org.uk> <54D071AA.1030302@ahsoftware.de> <20150203075616.GA29656@ZenIV.linux.org.uk> <54D08BF4.3000903@ahsoftware.de> <54D093A0.7090201@ahsoftware.de> <54D0C3B8.2050507@ahsoftware.de> <20150203174839.GD2509@thunk.org> <54D10D0E.8090204@ahsoftware.de> <20150203233332.GE29656@ZenIV.linux.org.uk> <54D1F215.9030404@ahsoftware.de> <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain> <54D20F02.5050700@ahsoftware.de> <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com> <54D21CC8.4020705@ahsoftware.de> <alpine.LFD.2.00.1502041533130.26766@localhost.localdomain> <54D24504.6080201@ahsoftware.de> <alpine.LFD.2.00.15020
 41724180.26766@localhost.localdomain> <54D24CA5.6080603@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D24CA5.6080603-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Am 04.02.2015 um 17:45 schrieb Alexander Holler:
> Am 04.02.2015 um 17:25 schrieb Luk=C3=A1=C5=A1 Czerner:
>> On Wed, 4 Feb 2015, Alexander Holler wrote:
>
>>> Am 04.02.2015 um 15:52 schrieb Luk=C3=A1=C5=A1 Czerner:
>>>> On Wed, 4 Feb 2015, Alexander Holler wrote:
>>>
>>>>> I'm happy for all the feedback. But it doesn't help me. I'm not
>>>>> going to spend
>>>>> the necessary time unpaid.
>>>>
>>>> Right, you'd much rather have someone else to spend the time on yo=
ur
>>>> request unpaid. That's understandable, but unreasonable. You want
>>>> it, implement it, or pay someone else to do it for you.
>>>
>>> Maybe you should attach a big fat red warning to the kernels bugzil=
la
>>> that filing a bug means either to fix it yourself or pay somone to =
do
>>> that.
>>>
>>> I've never demanded that someone else fixes it.
>>>
>>> I've just explained a problem.
>>>
>>> Unbelievable how someone could do such without paying someone else =
to
>>> fix it or by fixing it themself ...
>>
>> It's not a bug, you're requesting a feature.
>>
>
> Ok, I'm guilty.
>
> May I ask if there's somewhere a feature request tracker which doesn'=
t
> cruzify someone because he suggest a (maybe wrong) solution and tries=
 to
> show that this might work with some prelimary, broken, silly, quick a=
nd
> dirty patches?

I guess the answer is FreeBSD or similiar. ;)
