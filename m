From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] [RFC] mnt: add ability to clone mntns starting with the current root
Date: Tue, 07 Oct 2014 14:42:18 -0700
Message-ID: <87zjd7r1z9.fsf@x220.int.ebiederm.org>
References: <1412683977-29543-1-git-send-email-avagin@openvz.org>
	<20141007133039.GG7996@ZenIV.linux.org.uk>
	<20141007133339.GH7996@ZenIV.linux.org.uk>
	<87r3yjy64e.fsf@x220.int.ebiederm.org>
	<20141007204627.GI28519@ubuntumail>
	<87wq8bvbzg.fsf@x220.int.ebiederm.org>
	<20141007213257.GJ28519@ubuntumail>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141007213257.GJ28519@ubuntumail> (Serge Hallyn's message of
	"Tue, 7 Oct 2014 21:32:57 +0000")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Andrey Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Serge Hallyn <serge.hallyn@canonical.com>, Rob Landley <rob@landley.net>
List-Id: linux-api@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):

>> What I meant is that it isn't about containers.   It is about something
>> root can do.  So this is not a "container" problem.
>
> Oh, ok.  
>
> Sorry, I'm getting the two thread confused anyway.  I'm going to bow out
> here until I can pay proper attention.

I think there is half a point here that may be legit, when you are using
mount namespaces to jail applications, there may be a problem
with umounting / and making it to the underlying rootfs filesystem.

I am squinting and looking this way and that but while I can imagine
someone more clever than I can think up some unique property of rootfs
that makes it a little more exploitable than just mounting a ramfs,
but since you have to be root to exploit those properties I think the
game is pretty much lost.

>> >> So it is only root (and not root in a container) who can get to the
>> >> exposed rootfs.
>> >> 
>> >> I have a vague memory someone actually had a real use in miminal systems
>> >> for being able to get back to the rootfs and being able to use rootfs as
>> >> the rootfs.  There was even a patch at that time that Andrew Morton was
>> >> carrying for a time to allow unmounting root and get at rootfs, and to
>> >> prevent the oops on rootfs unmount in some way.
>> >> 
>> >> So not only do I not think it is a bug to get back too rootfs, I think
>> >> it is a feature that some people have expressed at least half-way sane
>> >> uses for.
>> >
>> > They can still do that if they want, using chroot :)
>> 
>> It would take fchdir or fchroot and a directory file descriptor open on
>> rootfs.  Frequently there is no appropriate directory file descriptor.
>
> ?  you can always escape if you're simply chrooted.  waterbuffalo :)

filesystem type rootfs.

Eric

