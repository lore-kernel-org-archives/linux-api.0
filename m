From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v2 0/5] selftests/kdbus: small fixes
Date: Wed, 17 Jun 2015 11:07:46 -0600
Message-ID: <5581A962.3040601@osg.samsung.com>
References: <1434558808-16129-1-git-send-email-sergei@s15v.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434558808-16129-1-git-send-email-sergei-E844GTqJAzo@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergei Zviagintsev <sergei-E844GTqJAzo@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, David Herrmann <dh.herrmann-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Djalal Harouni <tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/17/2015 10:33 AM, Sergei Zviagintsev wrote:
> Set of different fixes over selftests/kdbus.
> 
> These were first sent as independent patches, and in v2 they just
> properly threaded.
> 
> Links to previous patches:
> 
> http://lkml.kernel.org/g/1434550697-24785-1-git-send-email-sergei-E844GTqJAzo@public.gmane.org
> http://lkml.kernel.org/g/1434550697-24785-2-git-send-email-sergei-E844GTqJAzo@public.gmane.org
> http://lkml.kernel.org/g/1434550697-24785-3-git-send-email-sergei-E844GTqJAzo@public.gmane.org
> http://lkml.kernel.org/g/1434550697-24785-4-git-send-email-sergei-E844GTqJAzo@public.gmane.org
> http://lkml.kernel.org/g/1434550697-24785-5-git-send-email-sergei-E844GTqJAzo@public.gmane.org
> 
> Sergei Zviagintsev (5):
>   selftests/kdbus: handle cap_get_proc() error properly
>   selftests/kdbus: drop useless assignment
>   selftests/kdbus: remove useless initializations from
>     kdbus_clone_userns_test()
>   selftests/kdbus: drop duplicated code from __kdbus_msg_send()
>   selftests/kdbus: fix error paths in __kdbus_msg_send()
> 
>  tools/testing/selftests/kdbus/kdbus-util.c       | 46 ++++++++++++------------
>  tools/testing/selftests/kdbus/test-metadata-ns.c |  9 ++---
>  2 files changed, 27 insertions(+), 28 deletions(-)
> 

Nice work! Thanks for these fixes.
Greg! Are you going to apply these into your kdbus tree?

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
