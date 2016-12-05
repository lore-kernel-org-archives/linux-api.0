From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available [ver #3]
Date: Mon, 05 Dec 2016 15:37:39 +0000
Message-ID: <13727.1480952259@warthog.procyon.org.uk>
References: <20161204160504.GG1555@ZenIV.linux.org.uk> <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk> <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk> <20161204043803.GA1022@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161204160504.GG1555-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Content-ID: <13726.1480952259.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:

> > I understand wanting to avoid extra arguments, but you are asking for
> > trouble with that sort of calling conventions.  Verifying that all call
> > chains have these fields initialized is bloody unpleasant and it *is*
> > going to break, especially since the rules are "you need to initialize it
> > for vfs_xgetattr(), but not for vfs_getattr()" - the names are similar
> > enough for confusion, and that's not the only such pair.
> 
> BTW, after some grepping: you seem to leave ecryptfs_getattr() as-is, which
> means that flags it had been passed by caller in *stat are not seen by
> underlying fs.  Looks fishy...

I have patches for some other filesystems as well, but I'm trying to nail the
core down before whipping those back into shape.

David
