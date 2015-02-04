From: Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 4 Feb 2015 14:06:14 +0100
Message-ID: <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de>
 <1422896713-25367-2-git-send-email-holler@ahsoftware.de> <20150203060542.GZ29656@ZenIV.linux.org.uk>
 <54D071AA.1030302@ahsoftware.de> <20150203075616.GA29656@ZenIV.linux.org.uk>
 <54D08BF4.3000903@ahsoftware.de> <54D093A0.7090201@ahsoftware.de>
 <54D0C3B8.2050507@ahsoftware.de> <20150203174839.GD2509@thunk.org>
 <54D10D0E.8090204@ahsoftware.de> <20150203233332.GE29656@ZenIV.linux.org.uk>
 <54D1F215.9030404@ahsoftware.de> <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain>
 <54D20F02.5050700@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <54D20F02.5050700@ahsoftware.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alexander Holler <holler@ahsoftware.de>
Cc: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Alexander,

On Wed, Feb 4, 2015 at 1:22 PM, Alexander Holler <holler@ahsoftware.de>=
 wrote:
> Am 04.02.2015 um 13:07 schrieb Luk=C3=A1=C5=A1 Czerner:
>
>> The fact is that the current patches are useless for anything other
>> than proof-of-concept. Now you know more that needs to be done or
>
>
> That's wrong. The patches already work. If you delete a file which is=
n't in
> use by something else, the current contents will be wiped on traditio=
nal
> harddrives. I assume that already fulfills more than 50% of use cases=
 of
> ordinary people.

You are getting various feedback from people, that you seem to be ignor=
ing.

Al Viro, in his curmedgeonly way, points out that the problems are
much deeper than you realize. He does not say so explicitly, but I
imagine his point is that he does not want to see the kernel cluttered
with "partial" solutions that will simply increase the maintenance
burden in the long term, and leave bugs to be fixed further down the
line. You seem not to be listening.

Luk=C3=A1=C5=A1 points out to you that getting a feature like this into=
 the
kernel is complex process. You seem unwilling to hear that, and still
just want your partial solution.

I tell you that discussions of APIs should CC linux-api, which I am
now CCing into this thread, again, because, again, you're not
listening to feedback.

Nobody is asking for "high towers"; they just have their eyes on the
big picture. And the people here are just "ordinary people" with a
*lot* of experience dealing with kernel code (I exclude myself) . They
see many complexities that you don't. Getting intersting features into
the kernel requires a lot of work, and careful listening.

Thanks,

Michael


--=20
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
