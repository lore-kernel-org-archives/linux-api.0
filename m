From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Subject: Re: [RFC v10][PATCH 05/13] Dump memory address space
Date: Mon, 01 Dec 2008 15:57:09 -0500
Message-ID: <49344FA5.90004@cs.columbia.edu>
References: <1227747884-14150-1-git-send-email-orenl@cs.columbia.edu>	 <1227747884-14150-6-git-send-email-orenl@cs.columbia.edu>	 <20081128105351.GQ28946@ZenIV.linux.org.uk> <1228154412.2971.44.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1228154412.2971.44.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org



Dave Hansen wrote:
> On Fri, 2008-11-28 at 10:53 +0000, Al Viro wrote:
>>> +static int cr_ctx_checkpoint(struct cr_ctx *ctx, pid_t pid)
>>> +{
>>> +     ctx->root_pid = pid;
>>> +
>>> +     /*
>>> +      * assume checkpointer is in container's root vfs
>>> +      * FIXME: this works for now, but will change with real containers
>>> +      */
>>> +     ctx->vfsroot = &current->fs->root;
>>> +     path_get(ctx->vfsroot);
>> This is going to break as soon as you get another thread doing e.g. chroot(2)
>> while you are in there.
> 
> Yeah, we do need at least a read_lock(&current->fs->lock) to keep people
> from chroot()'ing underneath us.

True.
(while adapting older and safer code I omitted these tests with no reason).

> 
>> And it's a really, _really_ bad idea to take a
>> pointer to shared object, increment refcount on the current *contents* of
>> said object and assume that dropping refcount on the later contents of the
>> same will balance out.
> 
> Absolutely.  I assume you mean get_fs_struct(current) instead of
> path_get().

True.

Should change the type of ctx->vfsroot to not be a pointer, and do:

>>> +     ctx->vfsroot = *current->fs->root;
>>> +     path_get(&ctx->vfsroot);

and adjust accordingly in where the refcount is dropped.

What we need here is a reference point (this will change later when we handle
multiple fs-namespaces), which is the path of the "container root". Assuming
locking is correct so that current->fs does not change under us, it's enough
to get that path and later release that path.

BW, the current->fs is assumed to not change during the checkpoint; if it does,
then it's a mis-use of the checkpoint interface, and the resulting behavior
is undefined - restart is guaranteed to restore the exact old state even if
checkpoint succeeds.

Thanks,

Oren.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
