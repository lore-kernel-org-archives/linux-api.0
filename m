From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/5] WIP: Add syscall unlinkat_s (currently x86* only)
Date: Wed, 04 Feb 2015 10:00:32 -0500
Message-ID: <54D23410.3050006@gmail.com>
References: <1422896713-25367-1-git-send-email-holler@ahsoftware.de> <1422896713-25367-2-git-send-email-holler@ahsoftware.de> <20150203060542.GZ29656@ZenIV.linux.org.uk> <54D071AA.1030302@ahsoftware.de> <20150203075616.GA29656@ZenIV.linux.org.uk> <54D08BF4.3000903@ahsoftware.de> <54D093A0.7090201@ahsoftware.de> <54D0C3B8.2050507@ahsoftware.de> <20150203174839.GD2509@thunk.org> <54D10D0E.8090204@ahsoftware.de> <20150203233332.GE29656@ZenIV.linux.org.uk> <54D1F215.9030404@ahsoftware.de> <alpine.LFD.2.00.1502041247530.23002@localhost.localdomain> <54D20F02.5050700@ahsoftware.de> <CAHO5Pa0_2HE23dPU5Fg-sUgi2-e-szCpqoR98Vd6zE70_yd8Sw@mail.gmail.com> <54D21CC8.4020705@ahsoftware.de> <54D21EB8.6020208@ahsoftware.de> <54D22A63.7090603@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54D22A63.7090603-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Holler <holler-SXC+2es9fhnfWeYVQQPykw@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?THVrw6HFoSBDemVybg==?= =?UTF-8?B?ZXI=?= <lczerner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linux-Fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2015-02-04 09:19, Alexander Holler wrote:
> Am 04.02.2015 um 14:29 schrieb Alexander Holler:
> I'm really sorry that I can't spend several unpaid months with reading
> and understanding ever changing linux kernel sources in order to become
> a Linux filesystem expert and send some fully working perfect patches
> which do fix the problem in question.
You aren't expected to do so.  Code review is an integral part of the 
development process here, and only truly trivial patches (stuff like 
fixing typos in kernel messages and documentation) get merged without 
it.  If you pay attention to the list itself, even the veteran kernel 
developers almost never manage to produce a patch that is deemed 
absolutely perfect, and end up revising things multiple times before 
they get merged.
> And I can't spend the necessary time to play remote keyboard for kernel
> maintainers which might be willing to explain me what has to be done
> according to their view. I've already offered what I was willing to do,
> for the price of having to defend myself over and over. And
> unfortunately that wasn't the first time I've ended up with having to
> defend myself.
You seem to fail to understand that open source development runs 
primarily on volunteer work (yes there are people paid to work on open 
source software, but that is a generally exceptional case).  A large 
majority of the people who are kernel maintainers are donating their 
free time to the project.
> My conclusion is that I'm a real fool having posted multiple times
> patches to this list. It just doesn't make any sense and most of the
> time the only reward are flames.
If you aren't serious about trying to get something into the mainline 
kernel, you should be tagging _all_ of the e-mails in that patch-set 
with [RFC] in the subject line.

In none of the responses that I've seen has anyone been anything but 
polite (albeit in some cases moderately annoyed).  If you really 
consider such attempts at constructive criticism to be flames, then a 
development mailing list isn't the place you should be posting patches.
