From: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
Date: Fri, 19 Oct 2012 15:39:03 +0200
Message-ID: <508157F7.3010906@redhat.com>
References: <CCA6A06A.10264%pholland@adobe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CCA6A06A.10264%pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paton Lewis <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Il 19/10/2012 15:29, Paul Holland ha scritto:
> A disadvantage of solutions in this direction, which was not preset in
> Paton's patch, is that all calls to epoll_wait would need to specify some
> timeout value (!= -1) to guarantee that they each come out of epoll_wait
> and execute the "pass the buck" or "grace_period" logic.  So you would
> then have contention between designs that want highly responsive "delete"
> operations (those would require very short timeout values to epoll_wait)
> and those that want low execution overhead (those would want larger
> timeout values).

Is this really a problem?  If your thread pool risks getting oversized,
you might need some kind of timeout anyway to expire threads.  If your
thread pool is busy, the timeout will never be reached.

I'm not against EPOLL_CTL_DISABLE, just couldn't resist replying to "The
optimal data structure to do this without killing scalability is not
obvious". :)

Paolo
