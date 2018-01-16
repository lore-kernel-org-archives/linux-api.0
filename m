From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: User-visible context-mount API
Date: Tue, 16 Jan 2018 11:35:57 +0100
Message-ID: <CAOssrKc46bf=yme=zSubYF6t-TGfxEpCaKMQ6GVp30-vuaXWLw@mail.gmail.com>
References: <28167.1516032442@warthog.procyon.org.uk> <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <22576.1516097412@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <22576.1516097412@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>, "Eric W. Biederman" <ebiederm@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 16, 2018 at 11:10 AM, David Howells <dhowells@redhat.com> wrote:

>> >  (8) Change R/O protection on a mountpoint:
>> >
>> >         mount_protect(int dfd, const char *path,
>> >                       bool read_only);
>> >
>> >      This involves changing the R/O protection on the superblock also, but
>> >      might be mergeable with mount_reconfigure().
>>
>> Methinks this should be merged with mount_reconfigure(), and if
>> superblock state needs to be changed, than that should be done with
>> the "remount" procedure below.
>
> Maybe - the problem is that it's harder to manage if you've got multiple
> mounts attached to a single superblock as you can only change the superblock
> state if all the mounts are R/O.

Not true:

 [root@veci ~]# cat /proc/self/mountinfo | grep 46
212 78 0:46 / /tmp/1 rw,relatime shared:153 - tmpfs tmpfs rw,seclabel
219 78 0:46 / /tmp/2 rw,relatime shared:153 - tmpfs tmpfs rw,seclabel
[root@veci ~]# mount -oremount,ro /tmp/1
[root@veci ~]# cat /proc/self/mountinfo | grep 46
212 78 0:46 / /tmp/1 ro,relatime shared:153 - tmpfs tmpfs ro,seclabel
219 78 0:46 / /tmp/2 rw,relatime shared:153 - tmpfs tmpfs ro,seclabel
[root@veci ~]# mount -oremount,bind,rw /tmp/1
[root@veci ~]# cat /proc/self/mountinfo | grep 46
212 78 0:46 / /tmp/1 rw,relatime shared:153 - tmpfs tmpfs ro,seclabel
219 78 0:46 / /tmp/2 rw,relatime shared:153 - tmpfs tmpfs ro,seclabel
[root@veci ~]#

R/O flag on mount and on superblock can be changed independently.

>
>> >         write(mfd, "o bind=1"); // Set MS_BIND
>>
>> What does MS_BIND mean here?
>
> Sorry, bad example; MS_BIND wouldn't be allowed there.  Consider the following
> instead:
>
>      write(mfd, "o nodev=1"); // Set 'MS_NODEV'
>
>> >         write(mfd, "o nosuid=1"); // Set MS_NOSUID
>> >
>> >         mount_create(mfd, AT_FDCWD, "/mnt/a", sbfd);
>>
>> Yeah, more flexible, but also more complicated, with mount_create()
>> now taking 3 file descriptors, ugh...
>
> Yeah, I know:-/ ... but there are more parameters that I can foresee adding
> (such as [ug]id mapping tables), and a syscall just doesn't have enough
> argument space.

Okay.

Thanks,
Miklos
