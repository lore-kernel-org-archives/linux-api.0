From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Tue, 7 Oct 2014 15:19:12 -0700
Message-ID: <CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk> <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org> <20141007204627.GI28519@ubuntumail>
 <87wq8bvbzg.fsf@x220.int.ebiederm.org> <20141007213257.GJ28519@ubuntumail> <87zjd7r1z9.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87zjd7r1z9.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>
> I am squinting and looking this way and that but while I can imagine
> someone more clever than I can think up some unique property of rootfs
> that makes it a little more exploitable than just mounting a ramfs,
> but since you have to be root to exploit those properties I think the
> game is pretty much lost.

Yes.  rootfs might not be empty, it might have totally insane
permissions, and it's globally shared, which makes it into a wonderful
channel to pass things around that shouldn't be passed around.

Can non-root do this?  You'd need to be in a userns with a "/" that
isn't MNT_LOCKED.  Can this happen on any normal setup?

FWIW, I think we should unconditionally MNT_LOCKED the root on userns
unshare, even if it's the only mount.


>
>>> >> So it is only root (and not root in a container) who can get to the
>>> >> exposed rootfs.
>>> >>
>>> >> I have a vague memory someone actually had a real use in miminal systems
>>> >> for being able to get back to the rootfs and being able to use rootfs as
>>> >> the rootfs.  There was even a patch at that time that Andrew Morton was
>>> >> carrying for a time to allow unmounting root and get at rootfs, and to
>>> >> prevent the oops on rootfs unmount in some way.
>>> >>
>>> >> So not only do I not think it is a bug to get back too rootfs, I think
>>> >> it is a feature that some people have expressed at least half-way sane
>>> >> uses for.
>>> >
>>> > They can still do that if they want, using chroot :)
>>>
>>> It would take fchdir or fchroot and a directory file descriptor open on
>>> rootfs.  Frequently there is no appropriate directory file descriptor.
>>
>> ?  you can always escape if you're simply chrooted.  waterbuffalo :)
>
> filesystem type rootfs.
>
> Eric
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
