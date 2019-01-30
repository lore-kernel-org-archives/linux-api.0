From: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 08:19:46 -0800
Message-ID: <9e7789f8-2f03-d576-d7ee-a4f78e27ddd2@schaufler-ca.com>
References: <87va2716mh.fsf@xmission.com>
 <03e0993b-21db-1cc4-7a33-0236de7be20d@schaufler-ca.com>
 <87r2cvx7wz.fsf@xmission.com> <87ef8vx7jz.fsf@xmission.com>
 <8736pawbw2.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8736pawbw2.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LSM <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "SMACK-discuss-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <SMACK-discuss-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 1/30/2019 4:47 AM, Eric W. Biederman wrote:
> ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
>
>> ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman) writes:
>>
>>> Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> writes:
>>>> Are you taking the LSM specific mount options into account?
>>> In the design yes, and I allow setting them.  It appears in the code
>>> to retrieve the mount options I forgot to call security_sb_show_options.
>>>
>>> For finding the super block that you are going to mount the LSM mount
>>> options are not relevant.  Even nfs will not want to set those early as
>>> they do not help determine the nfs super block.  So the only place where
>>> there is anything interesting in my api is in reading back the security
>>> options so they can be compared to the options the mounter is setting.
>>>
>>> I will add the missing call to security_sb_show_options which is enough
>>> to fix selinux.  Unfortunately smack does not currently implement
>>> .sb_show_options.  Not implementing smack_sb_show_options means
>>> /proc/mounts fails to match /etc/mtab which is a bug and it is likely
>>> a real workd bug for the people who use smack and don't want to depend
>>> on /etc/mtab, or are transitioning away from it.
>>>
>>> Casey do you want to implement smack_sb_show_options or should I put it
>>> on my todo list?
>> Oh.  I should add that I am always parsing the LSM mount options out so
>> that there is not a chance of the individual filesystems implementing
>> comflicting options even when there are no LSMs active.  Without that I
>> am afraid we run the risk of having LSM mount otions in conflict with
>> ordinary filesystems options at some point and by the time we discover
>> it it would start introducing filesystem regressions.
>>
>> That does help with stack though as there is no fundamental reason only
>> one LSM could process mount options.
> Sigh.  I just realized that there is a smack variant of the bug I am
> working to fix.
>
> smack on remount does not fail if you change the smack mount options.
> It just silently ignores the smack mount options.  Which is exactly the
> same poor interaction with userspace that has surprised user space
> and caused CVEs.
>
> How much do you think the smack users will care if you start verifying
> that if smack options are present in remount that they are unchanged
> from mount?

I've added the smack-discuss list to the conversation.

> I suspect the smack userbase is small enough, and the corner case is
> crazy enough we can fix this poor communication by smack.  Otherwise it
> looks like there needs to be a new security hook so old and new remounts
> can be distinguished by the LSMs, and smack can be fixed in the new
> version.

I fear that it may be worse than that. It's not enough to distinguish
a mount from a remount. On remount you need an LSM specific way to
compare mount options. Smack may decide that it's OK to remount a
filesystem with more restrictive smackfshat values, for example. Or,
it may allow smackfsroot=Pop for one and smackfstransmute=Pop on
the other. I'm not sure about the 2nd case, but you should get the idea.

>
> Eric
>
>
