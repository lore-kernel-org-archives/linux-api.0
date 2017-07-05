From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 09:09:51 -0400
Message-ID: <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705084528.67499f8c-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Cc: ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/05/2017 08:45 AM, Steven Rostedt wrote:
> I'm betting there's a lot of reproducer code that never makes it into a
> test. How do we solve that? Perhaps we need people looking at LKML for
> any signs "I did this, and it caused a bug" or "Here's a test case
> which can trigger the bug". Each of these instances should end up in
> selftests, and I'm sure they are not.
> 
> We can't do much for special hardware, even though those tests should
> still be in the selftests for those that have the hardware, but we can
> do something about special configs. Perhaps selfttests should have a
> "config test" section. I have that in my own tests, but I use ktest to
> build them.

This problem is a reflection of our own explicit or implicit priorities.
The priorities of developers and reviewers needs to change to make an
impact on the problem. This is a hard problem.

As a concrete action item, glibc core developers took a harder stance on
(a) all user-visible bugs need a bug # (forces people to think about the
problem and file a coherent public bug about it) (b) all bugs needs a
regression test if possible, (c) and if not possible we need to extend
the testing framework to make it possible (we've started using kernel
namespaces to create isolated test configurations).

This change in reviewer priorities has had a noticeable impact on developer
priorities over the last 5 years. Timelines for this problem will be
measured in years.

-- 
Cheers,
Carlos.
