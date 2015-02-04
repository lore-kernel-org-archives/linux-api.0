From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 4 Feb 2015 14:33:16 -0500
Message-ID: <20150204193316.GH2509@thunk.org>
References: <54D0C3B8.2050507@ahsoftware.de>
 <20150203174839.GD2509@thunk.org>
 <54D10D0E.8090204@ahsoftware.de>
 <20150203233332.GE29656@ZenIV.linux.org.uk>
 <54D1F215.9030404@ahsoftware.de>
 <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain>
 <54D20F02.5050700@ahsoftware.de>
 <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com>
 <54D21CC8.4020705@ahsoftware.de>
 <alpine.LFD.2.00.1502041533130.26766@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1502041533130.26766@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Alexander Holler <holler@ahsoftware.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 04, 2015 at 03:52:02PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> > I'm happy for all the feedback. But it doesn't help me. I'm not goi=
ng to spend
> > the necessary time unpaid.
>=20
> Right, you'd much rather have someone else to spend the time on your
> request unpaid. That's understandable, but unreasonable. You want
> it, implement it, or pay someone else to do it for you.
>=20
> > It doesn't help me nor anyone else. As Eric Sandeen made me aware t=
hrough in
> > bug, look at http://lwn.net/Articles/462437/ what already happened.
>=20
> That's what people have been trying to tell you. It's not an easy
> task and there are plenty of cases to think about. As you can see
> IBM tasked their developer to do it, but they did not succeed. And
> here you come with your simplistic patches crying about "high
> towers. But you're the one apparently interested in this feature
> and you've been warned that's it's not a simple task.

And indeed, people who do have salaries paid by companies who care
about this general problem in actual products have been working on
addressing it using encryption, such that when the user is removed
from the device, the key is blasted.  More importantly, when the user
is not logged in, the key isn't even *available* on the device.  So it
solves more problems than the one that you are concerned about, and in
general maintainers prefer solutions that solve multiple problems,
because that minimizes the number of one-time hacks and partial/toy
solutions which turn into long-term maintainance headaches.  (After
all, if you insist on having a partial/toy solution merged, that turns
into an unfunded mandate which the maintainers effectively have to
support for free, forever.)

You've rejected encryption as a proposed solution as not meeting your
requirements (which if I understand your objections, can be summarized
as "encryption is too hard").  This is fine, but if you want someone
*else* to implement your partial toy solution which is less secure,
then you will either need to pay someone to do it or do it yourself.

> > Wrong. I don't want my partial solution to be part of the official =
kernel. I
> > don't care. I offered it for other users because I'm aware that has=
 become
> > almost impossible for normal people to get something into the kerne=
l without
> > spending an unbelievable amount of time most people can't afford to=
 spend.

So you expect other users to just apply your patches and use an
unofficial system call number that might get reassigned to some other
user later on?

If that's all you want, then ok, you're done.  The patches have been
posted to LKML, and you can give people URL's if they want to try
applying the patches on their own.

Cheers,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
