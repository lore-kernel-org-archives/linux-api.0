From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available [ver #3]
Date: Mon, 5 Dec 2016 15:49:12 +0100
Message-ID: <CAJfpeguM2cvzbfKRzPJUNbccXUBS6o0rv9j=qE_XfdnZpqAZ7g@mail.gmail.com>
References: <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk>
 <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
 <20161204043803.GA1022@ZenIV.linux.org.uk> <20161204173317.GH1555@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161204173317.GH1555-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Dec 4, 2016 at 6:33 PM, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> On Sun, Dec 04, 2016 at 04:38:05AM +0000, Al Viro wrote:
>
>> I understand wanting to avoid extra arguments, but you are asking for trouble
>> with that sort of calling conventions.  Verifying that all call chains have
>> these fields initialized is bloody unpleasant and it *is* going to break,
>> especially since the rules are "you need to initialize it for vfs_xgetattr(),
>> but not for vfs_getattr()" - the names are similar enough for confusion,
>> and that's not the only such pair.
>
> FWIW, there's a bit of abuse of struct kstat in overlayfs object
> creation paths - for one thing, it ends up with a very small subset
> of struct kstat (mode + rdev), for another it also needs link in
> case of symlinks and ends up passing it separately.
>
> IMO it would be better to introduce a separate object for that; does anybody
> have objections to something like the patch below?  In principle, we might
> even lift that thing into general API and switch ->mkdir()/->mknod()/->symlink()
> to identical calling conventions.  Hell knows, perhaps ->create() as well...
> Comments?

Good cleanup.  Applied, thanks.

Miklos
