From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 09:27:57 -0400
Message-ID: <20170705092757.63dc2328@gandalf.local.home>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
        <20170703123025.7479702e@gandalf.local.home>
        <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
        <20170705084528.67499f8c@gandalf.local.home>
        <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4080ecc7-1aa8-2940-f230-1b79d656cdb4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 5 Jul 2017 09:09:51 -0400
Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> This problem is a reflection of our own explicit or implicit priorities.
> The priorities of developers and reviewers needs to change to make an
> impact on the problem. This is a hard problem.

I 100% agree.

> 
> As a concrete action item, glibc core developers took a harder stance on
> (a) all user-visible bugs need a bug # (forces people to think about the

Unfortunately, we don't have a good system for a "bug #". Most kernel
developers hate bugzilla, and I think that includes Linus ;-) Which
means, unless Linus builds us a new bug tracking system, there wont be
any mandate for it.


> problem and file a coherent public bug about it) (b) all bugs needs a
> regression test if possible, (c) and if not possible we need to extend

I would love all bug fixes to come with a test (when possible).

> the testing framework to make it possible (we've started using kernel
> namespaces to create isolated test configurations).

Well, we have a selftest directory that should include all of these.
And most people run them on either a test box or a VM.

> 
> This change in reviewer priorities has had a noticeable impact on developer
> priorities over the last 5 years. Timelines for this problem will be
> measured in years.
> 

Your "b" above is what I would like to push. But who's going to enforce
this? With 10,000 changes per release, and a lot of them are fixes, the
best we can do is the honor system. Start shaming people that don't
have a regression test along with a Fixes tag (but we don't want people
to fix bugs without adding that tag either). There is a fine line one
must walk between getting people to change their approaches to bugs and
regression tests, and pissing them off where they start doing the
opposite of what would be best for the community.

-- Steve
