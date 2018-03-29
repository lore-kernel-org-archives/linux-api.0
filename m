From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [REVIEW][PATCH 00/11] ipc: Fixing the pid namespace support
Date: Thu, 29 Mar 2018 13:42:00 -0500
Message-ID: <874lky911j.fsf@xmission.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
        <87vadzqqq6.fsf@xmission.com>
        <990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
        <877eqejowd.fsf@xmission.com>
        <3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
        <87a7v2z2qa.fsf@xmission.com> <87vadmobdw.fsf_-_@xmission.com>
        <20180329011241.v5kgiwbbayz425hk@linux-n805>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180329011241.v5kgiwbbayz425hk@linux-n805> (Davidlohr Bueso's
        message of "Wed, 28 Mar 2018 18:12:41 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Linux Containers <containers@lists.linux-foundation.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, khlebnikov@yandex-team.ru, prakash.sangappa@oracle.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, serge.hallyn@ubuntu.com, esyr@redhat.com, jannh@google.com, linux-security-module@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
List-Id: linux-api@vger.kernel.org

Davidlohr Bueso <dave@stgolabs.net> writes:

> On Fri, 23 Mar 2018, Eric W. Biederman wrote:
>
>>Still I would like to see this fixed and I plan on merging this code.

The code is merged into my for-next tree now.

> Yes, it needs fixed, but 1) there are pending issues (such as the
> extra atomics)

Concerns not issues.  I documented them but I don't see any serious
reason to be concerned.  The data structures are sufficiently different
from AF_UNIX as well as the usage patterns that I have no reasonable
expectation that there will be problems.

There is no reasonable alternate implementation for correcting this bug.
Because of my concerns I looked at several other possibilities and they
all showed incorrect behavior, in different circumstances.

The implementations are simple enough there are no deep subtle issues.

I have tested the code.

If a regression happens the code is carefully split up so things can be
bisected easily and reverted if necessary.

> and 2) its late in the -rc cycle. Plus this issue has existed for 11 years without
> the world ending, so I'm sure we can hold on until at least one more
> release.

People really are starting to seriously look at accessing a single ipc
namespace from multiple pid namespaces.  The work arounds I saw posted
for the current brokenness were too nasty to live.

Better to fix things before there is code that actually starts depending
on the current brokenness.

I am the namespace maintianer and this is my area of responsibility.

The code is ready and I see no reason or benefit in delay.

Eric
