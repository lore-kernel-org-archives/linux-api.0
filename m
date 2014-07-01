From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Tue, 1 Jul 2014 10:53:56 +0100
Message-ID: <20140701095356.GC2242@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com>
 <87mwcuw2pj.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mwcuw2pj.fsf-KWJ+5VKanrL29G5dvP0v1laTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 01:40:40PM -0700, Andi Kleen wrote:
> David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:
> 
> > Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
> > provided path, rejecting (with -EACCES) paths that are not beneath
> > the provided dfd.  In particular, reject:
> >  - paths that contain .. components
> >  - paths that begin with /
> >  - symlinks that have paths as above.
> 
> How about bind mounts?
> 
> -Andi
> 
> -- 
> ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only

Bind mounts won't get rejected because they just look like normal
path components.  In other words, if dir/subdir is a bind mount to
/root/dir then:
  fd = openat(AT_FDCWD, "dir/subdir", O_RDONLY|O_BENEATH_ONLY);
will work fine.
