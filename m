From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Tue, 29 Jan 2019 19:23:12 -0600
Message-ID: <87ef8vx7jz.fsf@xmission.com>
References: <87va2716mh.fsf@xmission.com>
        <03e0993b-21db-1cc4-7a33-0236de7be20d@schaufler-ca.com>
        <87r2cvx7wz.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r2cvx7wz.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
        "Tue, 29 Jan 2019 19:15:24 -0600")
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:

> Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> writes:
>> Are you taking the LSM specific mount options into account?
>
> In the design yes, and I allow setting them.  It appears in the code
> to retrieve the mount options I forgot to call security_sb_show_options.
>
> For finding the super block that you are going to mount the LSM mount
> options are not relevant.  Even nfs will not want to set those early as
> they do not help determine the nfs super block.  So the only place where
> there is anything interesting in my api is in reading back the security
> options so they can be compared to the options the mounter is setting.
>
> I will add the missing call to security_sb_show_options which is enough
> to fix selinux.  Unfortunately smack does not currently implement
> .sb_show_options.  Not implementing smack_sb_show_options means
> /proc/mounts fails to match /etc/mtab which is a bug and it is likely
> a real workd bug for the people who use smack and don't want to depend
> on /etc/mtab, or are transitioning away from it.
>
> Casey do you want to implement smack_sb_show_options or should I put it
> on my todo list?

Oh.  I should add that I am always parsing the LSM mount options out so
that there is not a chance of the individual filesystems implementing
comflicting options even when there are no LSMs active.  Without that I
am afraid we run the risk of having LSM mount otions in conflict with
ordinary filesystems options at some point and by the time we discover
it it would start introducing filesystem regressions.

That does help with stack though as there is no fundamental reason only
one LSM could process mount options.

Eric
