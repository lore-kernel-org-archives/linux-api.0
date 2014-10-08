From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Tue, 7 Oct 2014 17:25:34 -0700
Message-ID: <CALCETrVuJbjWwTfZrH4U3hZDSxwMi9b3XxL5-KAi4bTSJgq0jw@mail.gmail.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk> <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org> <20141007204627.GI28519@ubuntumail>
 <87wq8bvbzg.fsf@x220.int.ebiederm.org> <20141007213257.GJ28519@ubuntumail>
 <87zjd7r1z9.fsf@x220.int.ebiederm.org> <CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
 <87h9zfpkm3.fsf@x220.int.ebiederm.org> <CALCETrWqD7j8d+0GYZeUMhf5PnZKmV0DGoHu49qo3tGx0TUnhg@mail.gmail.com>
 <87siizla5p.fsf@x220.int.ebiederm.org> <CALCETrV-B=ahQ9mDdZkSQTGD1zmHcFQA0OyQxxwFC9Ei8Vsp4Q@mail.gmail.com>
 <87vbnvif9e.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87vbnvif9e.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrey Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 7, 2014 at 5:20 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>
>> On Tue, Oct 7, 2014 at 4:42 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>>
>>>> On Tue, Oct 7, 2014 at 3:42 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>>> Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> writes:
>>>>>
>>>>>> On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>>>>>>
>>>>>>> I am squinting and looking this way and that but while I can imagine
>>>>>>> someone more clever than I can think up some unique property of rootfs
>>>>>>> that makes it a little more exploitable than just mounting a ramfs,
>>>>>>> but since you have to be root to exploit those properties I think the
>>>>>>> game is pretty much lost.
>>>>>>
>>>>>> Yes.  rootfs might not be empty, it might have totally insane
>>>>>> permissions, and it's globally shared, which makes it into a wonderful
>>>>>> channel to pass things around that shouldn't be passed around.
>>>>>
>>>>> But if only root with proc mounted can reach it...  I don't know.
>>>>
>>>> It doesn't have to be global root.  It could be userns root.
>>>>
>>>>> There might be a case for setting MNT_LOCKED when we overmount "/"
>>>>> as root but I don't yet see it.
>>>>>
>>>>>> Can non-root do this?  You'd need to be in a userns with a "/" that
>>>>>> isn't MNT_LOCKED.  Can this happen on any normal setup?
>>>>>>
>>>>>> FWIW, I think we should unconditionally MNT_LOCKED the root on userns
>>>>>> unshare, even if it's the only mount.
>>>>>
>>>>> To the best of my knowledge MNT_LOCKED is set uncondintially on userns
>>>>> unshare.
>>>>
>>>> Only if list_empty(&old->mnt_expire), whatever that means, I think.
>>>
>>> An autofs or nfs automounted mount.  Can those ever become root?
>>
>> Dunno.
>>
>> I thought that this code was what set MNT_LOCKED for things that
>> should be locked:
>
> It does.
>
>>     /* Don't allow unprivileged users to reveal what is under a mount */
>>     if ((flag & CL_UNPRIVILEGED) && list_empty(&old->mnt_expire))
>>         mnt->mnt.mnt_flags |= MNT_LOCKED;
>>
>> Now I'm confused.  Shouldn't that be checking for submounts?  Is that
>> what it's doing?
>
> As it copies each mount (mostly submounts) it sets MNT_LOCKED.

Oh.  They're *all* MNT_LOCKED.  Duh.

>
>> Anyway, I think that this should unconditionally set MNT_LOCKED on the
>> thing that mounted on rootfs.
>
> As I read the code mnt_set_expiry is only for nfs, cifs, and afs
> submounts (and perhaps proc should use them). So as they are generated
> mnt_expiry should never start on the root of filesystem of the mount tree.
>
> Furthermore mnt_expiry is cleared when a mount is moved, and when
> it is bind mounted, or propagated.
>
> pivot_root does look as though it may be missing the proper mnt_expiry
> handling list_del_init(&old->mnt_expire), but pivot_root does have
> proper MNT_LOCKED handling.

pivot_root is quite broken, as noted in my other email.  It's just not
broken like this, I think. :)

>
> Looking that test was slightly off and it should be:
>         if ((flag & CL_UNPRIVILEGED) &&
>             (!(flag & CL_EXPIRE) || list_empty(&old->mnt_expire))
>                 mnt->mnt.mnt_flags |= MNT_LOCKED;
>
> So on that note we might clear CL_EXPIRE when CL_UNPRIVILEGED is set
> in copy_tree but I don't see that as being really needed.
>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
