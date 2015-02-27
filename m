From: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] epoll: introduce EPOLLEXCLUSIVE and EPOLLROUNDROBIN
Date: Fri, 27 Feb 2015 17:24:29 -0500
Message-ID: <54F0EE9D.5010502@akamai.com>
References: <cover.1424200151.git.jbaron@akamai.com>	<7956874bfdc7403f37afe8a75e50c24221039bd2.1424200151.git.jbaron@akamai.com> <CAPh34mcPNQELwZCDTHej+HK=bpWgJ=jb1LeCtKoUHVgoDJOJoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPh34mcPNQELwZCDTHej+HK=bpWgJ=jb1LeCtKoUHVgoDJOJoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hagen Paul Pfeifer <hagen-GvnIQ6b/HdU@public.gmane.org>
Cc: normalperson-rMlxZR9MS24@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

v3 of this series implements this idea using using a different
approach:

http://lkml.iu.edu/hypermail/linux/kernel/1502.3/00667.html

If that still meets your needs it would be helpful to know in
order to move this forward.

Looking back at your posting, I was concerned about the
test case not lining up with the kernel code change.

Thanks,

-Jason

On 02/27/2015 03:56 PM, Hagen Paul Pfeifer wrote:
>
> Applause! Nice patch, sad that I submitted this patch ~3 years ago with
> exactly the same naming (EPOLLEXCLUSIVE) & nearly exact commit message and
> you rejected the patch ...
>
> Hagen
>
