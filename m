From: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC v13][PATCH 05/14] x86 support for checkpoint/restart
Date: Tue, 24 Feb 2009 08:06:46 -0800
Message-ID: <1235491606.26788.248.camel@nimitz>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	 <1233076092-8660-6-git-send-email-orenl@cs.columbia.edu>
	 <20090224014739.1b82fc35@thinkcentre.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090224014739.1b82fc35-4v5LP+xe+1byhTdZtsIeww@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nathan Lynch <ntl-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 2009-02-24 at 01:47 -0600, Nathan Lynch wrote:
> But I think this has been pointed out before.  If I understand the
> justification for cr_hbuf_get correctly, the allocations it services
> are somehow known to be bounded in size and nesting.  But even if that
> is the case, it's not much of a reason to avoid using kmalloc, is it?

Oren wants this particular facility to be used for live migration.  To
support good live migration, we need to be able to return from the
syscall as fast as possible.  To do that, Oren proposed that we buffer
all the data needed for the checkpoint inside the kernel.

The current cr_hbuf_put/get() could easily be modified to support this
usage by basically making put() do nothing, then handing off a handle to
the cr_ctx structure elsewhere in the kernel.  When the time comes to
free up the in-memory image, you only have one simple structure to go
free (the hbuf) as opposed to a bunch of little kmalloc()'d objects.

I'm sure I'm missing something.  I'm also sure that this *will* work
eventually.  But, I don't think the code as it stands supports keeping
the abstraction in there.  It is virtually impossible to debate the
design or its alternatives in this state.

-- Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
