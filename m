From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 04 Feb 2015 20:56:25 +0100
Message-ID: <54D27969.3090606@ahsoftware.de>
References: <54D0C3B8.2050507@ahsoftware.de> <20150203174839.GD2509@thunk.org> <54D10D0E.8090204@ahsoftware.de> <20150203233332.GE29656@ZenIV.linux.org.uk> <54D1F215.9030404@ahsoftware.de> <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain> <54D20F02.5050700@ahsoftware.de> <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com> <54D21CC8.4020705@ahsoftware.de> <alpine.LFD.2.00.1502041533130.26766@localhost.localdomain> <20150204193316.GH2509@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150204193316.GH2509@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Am 04.02.2015 um 20:33 schrieb Theodore Ts'o:

> And indeed, people who do have salaries paid by companies who care
> about this general problem in actual products have been working on
> addressing it using encryption, such that when the user is removed
> from the device, the key is blasted.  More importantly, when the user
> is not logged in, the key isn't even *available* on the device.  So it
> solves more problems than the one that you are concerned about, and in
> general maintainers prefer solutions that solve multiple problems,
> because that minimizes the number of one-time hacks and partial/toy
> solutions which turn into long-term maintainance headaches.  (After
> all, if you insist on having a partial/toy solution merged, that turns
> into an unfunded mandate which the maintainers effectively have to
> support for free, forever.)

It's just another layer above and an rather ugly workaround which ends 
up in having to manage keys and doesn't solve the real problem. Besides 
that it's much more complicated especially in kind of kernel sources to 
manage.

> You've rejected encryption as a proposed solution as not meeting your
> requirements (which if I understand your objections, can be summarized
> as "encryption is too hard").  This is fine, but if you want someone
> *else* to implement your partial toy solution which is less secure,
> then you will either need to pay someone to do it or do it yourself.

I haven't rejected it. I'm using that myself since around 10 years, 
because of the impossibility to really delete files when using Linux.

>>> Wrong. I don't want my partial solution to be part of the official kernel. I
>>> don't care. I offered it for other users because I'm aware that has become
>>> almost impossible for normal people to get something into the kernel without
>>> spending an unbelievable amount of time most people can't afford to spend.
>
> So you expect other users to just apply your patches and use an
> unofficial system call number that might get reassigned to some other
> user later on?

People do such all the time because the mainline kernel is otherwise 
unusable on many boards.

Besides that, I don't expect that anyone uses my patches.

As said multiple times before, they are an offer and were primarily 
meant to show a possible simple solution for many use cases. They 
already work with inside some, of course maybe uncomfortable, limits and 
don't do any worse. just better.

Alexander Holler
