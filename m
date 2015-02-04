From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 04 Feb 2015 14:21:12 +0100
Message-ID: <54D21CC8.4020705@ahsoftware.de>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de> <1422896713-25367-2-git-send-email-holler@ahsoftware.de> <20150203060542.GZ29656@ZenIV.linux.org.uk> <54D071AA.1030302@ahsoftware.de> <20150203075616.GA29656@ZenIV.linux.org.uk> <54D08BF4.3000903@ahsoftware.de> <54D093A0.7090201@ahsoftware.de> <54D0C3B8.2050507@ahsoftware.de> <20150203174839.GD2509@thunk.org> <54D10D0E.8090204@ahsoftware.de> <20150203233332.GE29656@ZenIV.linux.org.uk> <54D1F215.9030404@ahsoftware.de> <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain> <54D20F02.5050700@ahsoftware.de> <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am 04.02.2015 um 14:06 schrieb Michael Kerrisk:
> Alexander,
>
> On Wed, Feb 4, 2015 at 1:22 PM, Alexander Holler <holler@ahsoftware.d=
e> wrote:
>> Am 04.02.2015 um 13:07 schrieb Luk=C3=A1=C5=A1 Czerner:
>>
>>> The fact is that the current patches are useless for anything other
>>> than proof-of-concept. Now you know more that needs to be done or
>>
>>
>> That's wrong. The patches already work. If you delete a file which i=
sn't in
>> use by something else, the current contents will be wiped on traditi=
onal
>> harddrives. I assume that already fulfills more than 50% of use case=
s of
>> ordinary people.
>
> You are getting various feedback from people, that you seem to be ign=
oring.

I'm happy for all the feedback. But it doesn't help me. I'm not going t=
o=20
spend the necessary time unpaid.
=2E
> Al Viro, in his curmedgeonly way, points out that the problems are
> much deeper than you realize. He does not say so explicitly, but I
> imagine his point is that he does not want to see the kernel cluttere=
d
> with "partial" solutions that will simply increase the maintenance
> burden in the long term, and leave bugs to be fixed further down the
> line. You seem not to be listening.

It doesn't help me nor anyone else. As Eric Sandeen made me aware=20
through in bug, look at http://lwn.net/Articles/462437/ what already=20
happened.

> Luk=C3=A1=C5=A1 points out to you that getting a feature like this in=
to the
> kernel is complex process. You seem unwilling to hear that, and still
> just want your partial solution.

Wrong. I don't want my partial solution to be part of the official=20
kernel. I don't care. I offered it for other users because I'm aware=20
that has become almost impossible for normal people to get something=20
into the kernel without spending an unbelievable amount of time most=20
people can't afford to spend.

> I tell you that discussions of APIs should CC linux-api, which I am
> now CCing into this thread, again, because, again, you're not
> listening to feedback.

Please don't confuse "not listening" with "unable to fulfill Linux=20
kernel maintainer requests".

Alexander Holler
