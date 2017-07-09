From: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Sun, 9 Jul 2017 15:46:50 +0200
Message-ID: <8e49d1f3-2216-ca77-ac06-d62c08c18aea@leemhuis.info>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <20170705103335.0cbd9984@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705103335.0cbd9984-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Content-Language: en-MW
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05.07.2017 16:33, Steven Rostedt wrote:
> On Wed, 5 Jul 2017 16:06:07 +0200
> Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
> [...]
>> I don't mean to poo-poo the idea, but please realize that around 75% of
>> the kernel is hardware/arch support, so that means that 75% of the
>> changes/fixes deal with hardware things (yes, change is in direct
>> correlation to size of the codebase in the tree, strange but true).
> I would say that if it's for a specific hardware, then it's really up
> to the maintainer if there should be a test or not. As a lot of these
> is just to deal with some quirk or non standard that the hardware does.
> But are these regressions, or just some feature that's been broken on
> that hardware since its conception?
> 
> That is, Thorsten this is more for you, how much real regressions are in
> hardware? [...]
>From this and other mails in this thread I got the impression some more
data would be helpful -- for example a few percentage numbers on
 * how many of the regressions are in hardware-specific/driver code
 * how many regressions suddenly pop up due to a unrelated (and maybe
even correct) change
 * for how many regressions does it make sense to write a selftest to
catch similar issues beforehand in the future.

I'll try to gather some of those numbers when doing regression tracking
for 4.13 (sorry again that I had to skip 4.12), so be prepare yourself
for a mail when you include a "Fixes:" tag in a commit ;-) Then there is
some data to talk about on the summit or continue the discussion on this
mailing list or LKML.

BTW, Steven, you in this thread wrote "discuss if we want to consolidate
the format of all the kselftests and have something that everyone (or
most) developers agree on". I put that in my notes and try to make sure
we do not forget about this. Or is this something you'll drive forward
yourself?

Ciao, Thorsten

P.S.: Sorry, I'm a bit late with my reply here. My real job (which is
not really about kernel work) and some other things required my
attention in the past few days...
