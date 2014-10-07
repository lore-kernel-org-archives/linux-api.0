From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
Date: Tue, 07 Oct 2014 15:42:44 -0700
Message-ID: <87h9zfpkm3.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
	<87r3yjy64e.fsf@x220.int.ebiederm.org>
	<20141007204627.GI28519@ubuntumail>
	<87wq8bvbzg.fsf@x220.int.ebiederm.org>
	<20141007213257.GJ28519@ubuntumail>
	<87zjd7r1z9.fsf@x220.int.ebiederm.org>
	<CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVZNDTa3jc2HJ+_9sab+MhdXQ-rgNPHqT8qbDmJGXByBg@mail.gmail.com>
	(Andy Lutomirski's message of "Tue, 7 Oct 2014 15:19:12 -0700")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrey Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, Rob Landley <rob@landley.net>
List-Id: linux-api@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Tue, Oct 7, 2014 at 2:42 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> I am squinting and looking this way and that but while I can imagine
>> someone more clever than I can think up some unique property of rootfs
>> that makes it a little more exploitable than just mounting a ramfs,
>> but since you have to be root to exploit those properties I think the
>> game is pretty much lost.
>
> Yes.  rootfs might not be empty, it might have totally insane
> permissions, and it's globally shared, which makes it into a wonderful
> channel to pass things around that shouldn't be passed around.

But if only root with proc mounted can reach it...  I don't know.
There might be a case for setting MNT_LOCKED when we overmount "/"
as root but I don't yet see it.

> Can non-root do this?  You'd need to be in a userns with a "/" that
> isn't MNT_LOCKED.  Can this happen on any normal setup?
>
> FWIW, I think we should unconditionally MNT_LOCKED the root on userns
> unshare, even if it's the only mount.

To the best of my knowledge MNT_LOCKED is set uncondintially on userns
unshare.

Eric

