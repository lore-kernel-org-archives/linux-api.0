From: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] reintroduce accept4
Date: Fri, 14 Nov 2008 09:28:39 +1100
Message-ID: <18716.43543.256621.825529@cargo.ozlabs.ibm.com>
References: <200810261641.m9QGfotr024285@hs20-bc2-1.build.redhat.com>
	<517f3f820811131351l1305b2d2u43ab4e0601d97f93@mail.gmail.com>
	<20081113140541.23754cad.akpm@linux-foundation.org>
	<18716.43376.534965.688695@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <18716.43376.534965.688695-UYQwCShxghk5kJ7NmlRacFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, subrata-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-fy+rA21nqHI@public.gmane.org
List-Id: linux-api@vger.kernel.org

I wrote:

> Andrew Morton writes:
> 
> > > I think Ulrich wanted to try to see this patch in for 2.6.28; it's
> > > past the merge window of course, so it's up to you, but I have no
> > > problem with that.
> > 
> > That's easy - I'll send it to Linus and let him decide ;)
> 
> Ulrich's patch only updated x86.  If you're going to send it to Linus,
> please give us other architecture maintainers a chance to get patches
> to you to wire it up on our architectures, and then send Linus the
> combined patch.

Actually, any architecture that uses sys_socketcall should be OK
already, by the looks, and that includes powerpc.

Paul.
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
