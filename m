From: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 0/5] selftests/kdbus: small fixes
Date: Thu, 18 Jun 2015 12:05:51 +0200
Message-ID: <CANq1E4Qi4zGxB__BfWG+QWXqf49iux4+Mvs86rebF=VwdL2vvA@mail.gmail.com>
References: <1434558808-16129-1-git-send-email-sergei@s15v.net>
	<5581A962.3040601@osg.samsung.com>
	<20150617191130.GB3186@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617191130.GB3186-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi

On Wed, Jun 17, 2015 at 9:11 PM, Greg Kroah-Hartman
<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> On Wed, Jun 17, 2015 at 11:07:46AM -0600, Shuah Khan wrote:
>> On 06/17/2015 10:33 AM, Sergei Zviagintsev wrote:
>> > Set of different fixes over selftests/kdbus.
>> >
>> > These were first sent as independent patches, and in v2 they just
>> > properly threaded.
>> >
>> > Links to previous patches:
>> >
>> > http://lkml.kernel.org/g/1434550697-24785-1-git-send-email-sergei-E844GTqJAzo@public.gmane.org
>> > http://lkml.kernel.org/g/1434550697-24785-2-git-send-email-sergei-E844GTqJAzo@public.gmane.org
>> > http://lkml.kernel.org/g/1434550697-24785-3-git-send-email-sergei-E844GTqJAzo@public.gmane.org
>> > http://lkml.kernel.org/g/1434550697-24785-4-git-send-email-sergei-E844GTqJAzo@public.gmane.org
>> > http://lkml.kernel.org/g/1434550697-24785-5-git-send-email-sergei-E844GTqJAzo@public.gmane.org
>> >
>> > Sergei Zviagintsev (5):
>> >   selftests/kdbus: handle cap_get_proc() error properly
>> >   selftests/kdbus: drop useless assignment
>> >   selftests/kdbus: remove useless initializations from
>> >     kdbus_clone_userns_test()
>> >   selftests/kdbus: drop duplicated code from __kdbus_msg_send()
>> >   selftests/kdbus: fix error paths in __kdbus_msg_send()
>> >
>> >  tools/testing/selftests/kdbus/kdbus-util.c       | 46 ++++++++++++------------
>> >  tools/testing/selftests/kdbus/test-metadata-ns.c |  9 ++---
>> >  2 files changed, 27 insertions(+), 28 deletions(-)
>> >
>>
>> Nice work! Thanks for these fixes.
>> Greg! Are you going to apply these into your kdbus tree?
>
> Yes, I will take them.

The 5 selftest changes are:

Reviewed-by: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks
David
