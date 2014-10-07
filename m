From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the
 current root
Date: Tue, 7 Oct 2014 16:44:45 -0700
Message-ID: <CALCETrV-B=ahQ9mDdZkSQTGD1zmHcFQA0OyQxxwFC9Ei8Vsp4Q@mail.gmail.com>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
 <20141007133039.GG7996@ZenIV.linux.org.uk> <20141007133339.GH7996@ZenIV.linux.org.uk>
 <87r3yjy64e.fsf@x220.int.ebiederm.org> <20141007204627.GI28519@ubuntumail>
 <87wq8bvbzg.fsf@x220.int.ebiederm.org> <20141007213257.GJ28519@ubuntumail>
 <87zjd7r1z9.fsf@x220.int.ebiederm.org> <CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
 <87h9zfpkm3.fsf@x220.int.ebiederm.org> <CALCETrWqD7j8d+0GYZeUMhf5PnZKmV0DGoHu49qo3tGx0TUnhg@mail.gmail.com>
 <87siizla5p.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87siizla5p.fsf@x220.int.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, Rob Landley <rob@landley.net>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 7, 2014 at 4:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Tue, Oct 7, 2014 at 3:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>
>>>> On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>
>>>>> I am squinting and looking this way and that but while I can imagine
>>>>> someone more clever than I can think up some unique property of rootfs
>>>>> that makes it a little more exploitable than just mounting a ramfs,
>>>>> but since you have to be root to exploit those properties I think the
>>>>> game is pretty much lost.
>>>>
>>>> Yes.  rootfs might not be empty, it might have totally insane
>>>> permissions, and it's globally shared, which makes it into a wonderful
>>>> channel to pass things around that shouldn't be passed around.
>>>
>>> But if only root with proc mounted can reach it...  I don't know.
>>
>> It doesn't have to be global root.  It could be userns root.
>>
>>> There might be a case for setting MNT_LOCKED when we overmount "/"
>>> as root but I don't yet see it.
>>>
>>>> Can non-root do this?  You'd need to be in a userns with a "/" that
>>>> isn't MNT_LOCKED.  Can this happen on any normal setup?
>>>>
>>>> FWIW, I think we should unconditionally MNT_LOCKED the root on userns
>>>> unshare, even if it's the only mount.
>>>
>>> To the best of my knowledge MNT_LOCKED is set uncondintially on userns
>>> unshare.
>>
>> Only if list_empty(&old->mnt_expire), whatever that means, I think.
>
> An autofs or nfs automounted mount.  Can those ever become root?

Dunno.

I thought that this code was what set MNT_LOCKED for things that
should be locked:

    /* Don't allow unprivileged users to reveal what is under a mount */
    if ((flag & CL_UNPRIVILEGED) && list_empty(&old->mnt_expire))
        mnt->mnt.mnt_flags |= MNT_LOCKED;

Now I'm confused.  Shouldn't that be checking for submounts?  Is that
what it's doing?

Anyway, I think that this should unconditionally set MNT_LOCKED on the
thing that mounted on rootfs.

--Andy
