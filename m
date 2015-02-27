From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 0/3] epoll: introduce round robin wakeup mode
Date: Fri, 27 Feb 2015 13:10:34 -0800
Message-ID: <20150227131034.2f2787dcabf285191a1f6ffa@linux-foundation.org>
References: <cover.1424805740.git.jbaron@akamai.com>
	<20150225073814.GA14558@gmail.com>
	<54EDF7D8.60201@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54EDF7D8.60201-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexander Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 25 Feb 2015 11:27:04 -0500 Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org> wrote:

> > Libenzi inactive eventpoll appears to be without a 
> > dedicated maintainer since 2011 or so. Is there anyone who 
> > knows the code and its usages in detail and does final ABI 
> > decisions on eventpoll - Andrew, Al or Linus?
> >
> Generally, Andrew and Al do more 'final' reviews here,
> and a lot of others on lkml are always very helpful in
> looking at this code. However, its not always clear, at
> least to me, who I should pester.

Yes, it's a difficult situation.

The 3/3 changelog refers to "EPOLLROUNDROBIN" which I assume is
a leftover from some earlier revision?

I don't really understand the need for rotation/round-robin.  We can
solve the thundering herd via exclusive wakeups, but what is the point
in choosing to wake the task which has been sleeping for the longest
time?  Why is that better than waking the task which has been sleeping
for the *least* time?  That's probably faster as that task's data is
more likely to still be in cache.

The changelogs talks about "starvation" but they don't really say what
this term means in this context, nor why it is a bad thing.
