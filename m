From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 06:47:09 -0600
Message-ID: <8736pawbw2.fsf@xmission.com>
References: <87va2716mh.fsf@xmission.com>
        <03e0993b-21db-1cc4-7a33-0236de7be20d@schaufler-ca.com>
        <87r2cvx7wz.fsf@xmission.com> <87ef8vx7jz.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ef8vx7jz.fsf@xmission.com> (Eric W. Biederman's message of
        "Tue, 29 Jan 2019 19:23:12 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, LSM <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> Casey Schaufler <casey@schaufler-ca.com> writes:
>>> Are you taking the LSM specific mount options into account?
>>
>> In the design yes, and I allow setting them.  It appears in the code
>> to retrieve the mount options I forgot to call security_sb_show_options.
>>
>> For finding the super block that you are going to mount the LSM mount
>> options are not relevant.  Even nfs will not want to set those early as
>> they do not help determine the nfs super block.  So the only place where
>> there is anything interesting in my api is in reading back the security
>> options so they can be compared to the options the mounter is setting.
>>
>> I will add the missing call to security_sb_show_options which is enough
>> to fix selinux.  Unfortunately smack does not currently implement
>> .sb_show_options.  Not implementing smack_sb_show_options means
>> /proc/mounts fails to match /etc/mtab which is a bug and it is likely
>> a real workd bug for the people who use smack and don't want to depend
>> on /etc/mtab, or are transitioning away from it.
>>
>> Casey do you want to implement smack_sb_show_options or should I put it
>> on my todo list?
>
> Oh.  I should add that I am always parsing the LSM mount options out so
> that there is not a chance of the individual filesystems implementing
> comflicting options even when there are no LSMs active.  Without that I
> am afraid we run the risk of having LSM mount otions in conflict with
> ordinary filesystems options at some point and by the time we discover
> it it would start introducing filesystem regressions.
>
> That does help with stack though as there is no fundamental reason only
> one LSM could process mount options.

Sigh.  I just realized that there is a smack variant of the bug I am
working to fix.

smack on remount does not fail if you change the smack mount options.
It just silently ignores the smack mount options.  Which is exactly the
same poor interaction with userspace that has surprised user space
and caused CVEs.

How much do you think the smack users will care if you start verifying
that if smack options are present in remount that they are unchanged
from mount?

I suspect the smack userbase is small enough, and the corner case is
crazy enough we can fix this poor communication by smack.  Otherwise it
looks like there needs to be a new security hook so old and new remounts
can be distinguished by the LSMs, and smack can be fixed in the new
version.

Eric
