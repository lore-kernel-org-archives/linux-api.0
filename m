From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Ksummit-discuss] [MAINTAINERS SUMMIT] & [TECH TOPIC] Improve
 regression tracking
Date: Wed, 5 Jul 2017 10:06:24 -0400
Message-ID: <9b377a08-bf38-b41e-040c-41cb078bcfc3@redhat.com>
References: <576cea07-770a-4864-c3f5-0832ff211e94@leemhuis.info>
 <20170703123025.7479702e@gandalf.local.home>
 <ad94dc65-cc9c-f4f1-27c1-5a48603c7f59@leemhuis.info>
 <20170705084528.67499f8c@gandalf.local.home>
 <4080ecc7-1aa8-2940-f230-1b79d656cdb4@redhat.com>
 <20170705092757.63dc2328@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170705092757.63dc2328-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, ksummit-discuss-cunTk1MwBs98uUxBSJOaYoYkZiVZrdSR2LY78lusg7I@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/05/2017 09:27 AM, Steven Rostedt wrote:
>> As a concrete action item, glibc core developers took a harder stance on
>> (a) all user-visible bugs need a bug # (forces people to think about the
> 
> Unfortunately, we don't have a good system for a "bug #". Most kernel
> developers hate bugzilla, and I think that includes Linus ;-) Which
> means, unless Linus builds us a new bug tracking system, there wont be
> any mandate for it.

Use the XMLRPC API to build a better interface for kernel developers?

Our "fixed bugs" list is automatically culled via XMLRPC to generate our
release announcement with "fixed bugs."

The bug # mandate has had a few key effects. It allows non-developers to
search for old similar regressions in an easier fashion than having to
trawl the mailing list for incomprehensible (to them) discussions about
semantics. The bugs are described and talked about in terms of user
facing aspects, not internal implementation details. Regressed bugs can
be reopened and discussed on the mailing list with links to the discussions
and summaries of conclusions.

All of this means we have a cleaner, clearer, description of the problem
from the user side. This again needs priority from a group of people for
whom time is precious, so you have to get buy in from them.

I don't think (a) is needed, but the glibc community found it helpful.
 
>> problem and file a coherent public bug about it) (b) all bugs needs a
>> regression test if possible, (c) and if not possible we need to extend
> 
> I would love all bug fixes to come with a test (when possible).

We have lots of hardware-specific tests that are marked UNSUPPORTED if
say you're not running on AVX512 enabled hardware.

>> the testing framework to make it possible (we've started using kernel
>> namespaces to create isolated test configurations).
> 
> Well, we have a selftest directory that should include all of these.
> And most people run them on either a test box or a VM.
Improving the test infrastructure must also be a priority, otherwise you
will grow to the limit of that infrastructure.

>> This change in reviewer priorities has had a noticeable impact on developer
>> priorities over the last 5 years. Timelines for this problem will be
>> measured in years.
> 
> Your "b" above is what I would like to push. But who's going to enforce
> this? With 10,000 changes per release, and a lot of them are fixes, the
> best we can do is the honor system. Start shaming people that don't
> have a regression test along with a Fixes tag (but we don't want people
> to fix bugs without adding that tag either). There is a fine line one
> must walk between getting people to change their approaches to bugs and
> regression tests, and pissing them off where they start doing the
> opposite of what would be best for the community.

I did say "hard problem" earlier didn't I?

* Start with yourself.

* For everyone you know well, and have met in person, be brutal and
  require them to submit regression tests with their bug fixes. These
  people are already committed to getting their fixes in and they will
  understand you are making an example of them.

* For everyone you don't know well, be gentle, and begin reminding
  them you need a regression test, and if you feel generous try to write
  one yourself for them. Often the act of writing such a test will show
  you how hard it is, and what is missing from your infrastructure to make
  this easy, because if it was easy everyone would do it.

YMMV.

-- 
Cheers,
Carlos.
