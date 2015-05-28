From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CFT][PATCH 00/10] Making new mounts of proc and sysfs as safe as bind mounts (take 2)
Date: Thu, 28 May 2015 16:42:34 -0500
Message-ID: <871ti0fkfp.fsf@x220.int.ebiederm.org>
References: <87pp63jcca.fsf@x220.int.ebiederm.org>
	<87siaxuvik.fsf@x220.int.ebiederm.org>
	<87wq004im1.fsf@x220.int.ebiederm.org>
	<CALCETrUhXBR5WQ6gXr9KzGc4=7tph7kzopY29Hug4g+FhOzEKg@mail.gmail.com>
	<20150528140839.GD28842@ubuntumail>
	<87lhg8pwvz.fsf@x220.int.ebiederm.org>
	<20150528210438.GA14849@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150528210438.GA14849-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org> (Serge E. Hallyn's
	message of "Thu, 28 May 2015 16:04:38 -0500")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Kenton Varda <kenton-AuYgBwuPrUQTaNkGU808tA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

"Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> writes:

> On Thu, May 28, 2015 at 10:03:28AM -0500, Eric W. Biederman wrote:
>> Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> writes:
>> 
>> > Quoting Andy Lutomirski (luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org):
>> >> On Fri, May 22, 2015 at 10:39 AM, Eric W. Biederman
>> >> <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>> >> > I had hoped to get some Tested-By's on that patch series.
>> >> 
>> >> Sorry, I've been totally swamped.
>> >> 
>> >> I suspect that Sandstorm is okay, but I haven't had a chance to test
>> >> it for real.  Sandstorm makes only limited use of proc and sysfs in
>> >> containers, but I'll see if I can test it for real this weekend.
>> >
>> > Testing this with unprivileged containers, I get
>> >
>> > lxc-start: conf.c: lxc_mount_auto_mounts: 808 Operation not permitted
>> > - error mounting sysfs on
>> > /usr/lib/x86_64-linux-gnu/lxc/sys/devices/virtual/net flags 0
>> 
>> Grr..  I was afraid this would break something. :(
>> 
>> Looking at my system I see that sysfs is currently mounted
>> "nosuid,nodev,noexec"
>> 
>> Looking at the lxc-start code I don't see it as including any of those
>> mount options.  In practice for sysfs I think those options are
>> meaningless (as there should be no devices and nothing executable in
>> sysfs) but I can understand the past concerns with chmod on virtual
>> filesystems that would incline people to use them, so I think the
>> failure is reporting a legitimate security issue in the lxc userspace
>> code where the the unprivileged code is currently attempting to give
>> greater access to sysfs than was given by the original mount of sysfs.
>> 
>> As nosuid,nodev,noexec should not impair the operation of sysfs
>> operation it looks like you can always specify those options and just
>> make this concern go away.
>> 
>> Something like the untested patch below I expect.
>> 
>> diff --git a/src/lxc/conf.c b/src/lxc/conf.c
>> index 9870455b3cae..d9ccd03afe68 100644
>> --- a/src/lxc/conf.c
>> +++ b/src/lxc/conf.c
>> @@ -770,8 +770,8 @@ static int lxc_mount_auto_mounts(struct lxc_conf *conf, int flags, struct lxc_ha
>>  		{ LXC_AUTO_PROC_MASK, LXC_AUTO_PROC_MIXED, "%r/proc/sysrq-trigger",                             "%r/proc/sysrq-trigger",        NULL,       MS_BIND,                        NULL },
>>  		{ LXC_AUTO_PROC_MASK, LXC_AUTO_PROC_MIXED, NULL,                                                "%r/proc/sysrq-trigger",        NULL,       MS_REMOUNT|MS_BIND|MS_RDONLY,   NULL },
>>  		{ LXC_AUTO_PROC_MASK, LXC_AUTO_PROC_RW,    "proc",                                              "%r/proc",                      "proc",     MS_NODEV|MS_NOEXEC|MS_NOSUID,   NULL },
>> -		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RW,     "sysfs",                                             "%r/sys",                       "sysfs",    0,                              NULL },
>> -		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RO,     "sysfs",                                             "%r/sys",                       "sysfs",    MS_RDONLY,                      NULL },
>> +		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RW,     "sysfs",                                             "%r/sys",                       "sysfs",    MS_NODEV|MS_NOEXEC|MS_NOSUID,   NULL },
>> +		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_RO,     "sysfs",                                             "%r/sys",                       "sysfs",    MS_NODEV|MS_NOEXEC|MS_NOSUID|MS_RDONLY, NULL },
>>  		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_MIXED,  "sysfs",                                             "%r/sys",                       "sysfs",    MS_NODEV|MS_NOEXEC|MS_NOSUID,   NULL },
>>  		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_MIXED,  "%r/sys",                                            "%r/sys",                       NULL,       MS_BIND,                        NULL },
>>  		{ LXC_AUTO_SYS_MASK,  LXC_AUTO_SYS_MIXED,  NULL,                                                "%r/sys",                       NULL,       MS_REMOUNT|MS_BIND|MS_RDONLY,   NULL },
>
> fwiw - the first one works, the second one does not due to an apparent
> inability to statvfs the origin.

Good to hear.  That confirms there are no other gotchas waiting in the
wings.

Apparently my second suggested patch is buggy due to an invalid source
string.  The source would need to be %r/proc or %r/sysfs to use statvfs
productively.


>> Alternately you can read the flags off of the original mount of proc or sysfs.
>> 
>> diff --git a/src/lxc/conf.c b/src/lxc/conf.c
>> index 9870455b3cae..50ea49973e80 100644
>> --- a/src/lxc/conf.c
>> +++ b/src/lxc/conf.c
>> @@ -712,7 +712,9 @@ static unsigned long add_required_remount_flags(const char *s, const char *d,
>>         struct statvfs sb;
>>         unsigned long required_flags = 0;
>>  
>> -       if (!(flags & MS_REMOUNT))
>> +       if (!(flags & MS_REMOUNT) &&
>> +           (strcmp(s, "proc") != 0) &&
>> +           (strcmp(s, "sysfs") != 0))
>>                 return flags;
>>  
>>         if (!s)
>> 
>> Eric
>> _______________________________________________
>> Containers mailing list
>> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers
