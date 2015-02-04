From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 4 Feb 2015 15:52:02 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1502041533130.26766@localhost.localdomain>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de> <1422896713-25367-2-git-send-email-holler@ahsoftware.de> <20150203060542.GZ29656@ZenIV.linux.org.uk> <54D071AA.1030302@ahsoftware.de> <20150203075616.GA29656@ZenIV.linux.org.uk>
 <54D08BF4.3000903@ahsoftware.de> <54D093A0.7090201@ahsoftware.de> <54D0C3B8.2050507@ahsoftware.de> <20150203174839.GD2509@thunk.org> <54D10D0E.8090204@ahsoftware.de> <20150203233332.GE29656@ZenIV.linux.org.uk> <54D1F215.9030404@ahsoftware.de>
 <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain> <54D20F02.5050700@ahsoftware.de> <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com> <54D21CC8.4020705@ahsoftware.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2100170863-1423061526=:26766"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D21CC8.4020705-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2100170863-1423061526=:26766
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 4 Feb 2015, Alexander Holler wrote:

> Date: Wed, 04 Feb 2015 14:21:12 +0100
> From: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
> To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Lukáš Czerner <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
>     Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
>     Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
>     Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
>     Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
> 
> Am 04.02.2015 um 14:06 schrieb Michael Kerrisk:
> > Alexander,
> > 
> > On Wed, Feb 4, 2015 at 1:22 PM, Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
> > wrote:
> > > Am 04.02.2015 um 13:07 schrieb Lukáš Czerner:
> > > 
> > > > The fact is that the current patches are useless for anything other
> > > > than proof-of-concept. Now you know more that needs to be done or
> > > 
> > > 
> > > That's wrong. The patches already work. If you delete a file which isn't
> > > in
> > > use by something else, the current contents will be wiped on traditional
> > > harddrives. I assume that already fulfills more than 50% of use cases of
> > > ordinary people.
> > 
> > You are getting various feedback from people, that you seem to be ignoring.
> 
> I'm happy for all the feedback. But it doesn't help me. I'm not going to spend
> the necessary time unpaid.

Right, you'd much rather have someone else to spend the time on your
request unpaid. That's understandable, but unreasonable. You want
it, implement it, or pay someone else to do it for you.

> .
> > Al Viro, in his curmedgeonly way, points out that the problems are
> > much deeper than you realize. He does not say so explicitly, but I
> > imagine his point is that he does not want to see the kernel cluttered
> > with "partial" solutions that will simply increase the maintenance
> > burden in the long term, and leave bugs to be fixed further down the
> > line. You seem not to be listening.
> 
> It doesn't help me nor anyone else. As Eric Sandeen made me aware through in
> bug, look at http://lwn.net/Articles/462437/ what already happened.

That's what people have been trying to tell you. It's not an easy
task and there are plenty of cases to think about. As you can see
IBM tasked their developer to do it, but they did not succeed. And
here you come with your simplistic patches crying about "high
towers. But you're the one apparently interested in this feature
and you've been warned that's it's not a simple task.

But if you really want it I really do encourage you to try. I'd be
happy to have a working and reliable secure delete feature but it's
not my priority at all.

-Lukas

> 
> > Lukáš points out to you that getting a feature like this into the
> > kernel is complex process. You seem unwilling to hear that, and still
> > just want your partial solution.
> 
> Wrong. I don't want my partial solution to be part of the official kernel. I
> don't care. I offered it for other users because I'm aware that has become
> almost impossible for normal people to get something into the kernel without
> spending an unbelievable amount of time most people can't afford to spend.
> 
> > I tell you that discussions of APIs should CC linux-api, which I am
> > now CCing into this thread, again, because, again, you're not
> > listening to feedback.
> 
> Please don't confuse "not listening" with "unable to fulfill Linux kernel
> maintainer requests".
> 
> Alexander Holler
> 
> 
--8323328-2100170863-1423061526=:26766--
