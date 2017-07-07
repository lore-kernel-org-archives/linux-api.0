From: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Thu, 6 Jul 2017 21:52:25 -0700
Message-ID: <595F1389.60308@gmail.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
 <20170705140607.GA30187@kroah.com>
 <a462fb3b-a6d4-e969-b301-b404981de224@roeck-us.net>
 <20170705112707.54d7f345@gandalf.local.home>
 <20170707033302.rgpq5knzx3qvvr2p@wfg-t540p.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170707033302.rgpq5knzx3qvvr2p-q6ZYBFIlbFFi0tQiZxhdj1DQ4js95KgL@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 07/06/17 20:33, Fengguang Wu wrote:
> On Wed, Jul 05, 2017 at 11:27:07AM -0400, Steven Rostedt wrote:
> [snip]
>> I need to be clearer on this. What I meant was, if there's a bug
>> where someone has a test that easily reproduces the bug, then if
>> there's not a test added to selftests for said bug, then we should
>> shame those into doing so.
> 
> Besides shaming, there's one more option -- acknowledgement.
> 
> When it's a test case or test tool that discovered the bug, we could
> acknowledge it by adding one line in the bug fixing patch. The exact
> forms can be discussed, but here are some examples to show the basic
> idea:
> 
> Tool: lockdep
> Tool: ktest
> Tool: smatch
> Tool: trinity
> Tool: syzkaller
> Tool: xfstests/tests/ext4/025
> Tool: scripts/coccinelle/locks/call_kern.cocci
> Tool: tools/testing/selftests/bpf/test_align.c
> 
> Reports from test infrastructures like 0day could go further to help
> acknowledge the tool author or maintainer by showing such lines in its
> bug report email:
> 
> You may consider adding these lines in the bug fixing patch:
> 
> -----------------------[ cut here ]----------------------------------
> Fixes: XXXXXXXXXX ("title of the buggy commit")
> Tool: tools/testing/selftests/bpf/test_align.c <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> Reported-by: 0day test robot <xiaolong.ye-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> -----------------------[ cut here ]----------------------------------
> 
> Regards,
> Fengguang
> _______________________________________________
> Ksummit-discuss mailing list
> Ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-discuss
> 

That is a great idea!  If a tool is shown to be catching a large
number of bugs then I am more likely to add it to my test process.

-Frank
