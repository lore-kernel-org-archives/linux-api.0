From: Ulrich Drepper <drepper-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Date: Wed, 4 Feb 2009 15:45:47 -0800
Message-ID: <a36005b50902041545qb9ce459y710bb3b9b8949b17@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	 <20090204150507.665b5b7c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090204150507.665b5b7c.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 4, 2009 at 3:05 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> How would you recommend that userspace determine whether its kernel
> supports this feature, bearing in mind that someone might backport this
> patch into arbitrarily earlier kernel versions?

   fd = eventfd2 (CNT, EFD_SEMAPHORE);
   if (fd == -1 && errno == EINVAL)
     puts("cannot handled EFD_SEMAPHORE");
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
