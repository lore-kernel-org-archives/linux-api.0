From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Tue, 29 Jan 2019 19:15:24 -0600
Message-ID: <87r2cvx7wz.fsf@xmission.com>
References: <87va2716mh.fsf@xmission.com>
        <03e0993b-21db-1cc4-7a33-0236de7be20d@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <03e0993b-21db-1cc4-7a33-0236de7be20d@schaufler-ca.com> (Casey
        Schaufler's message of "Tue, 29 Jan 2019 15:01:30 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Karel Zak <kzak@redhat.com>, util-linux@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, LSM <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> On 1/29/2019 1:44 PM, Eric W. Biederman wrote:
>> All,
>>
>> With the existing mount API it is possible to mount a filesystem
>> like:
>>
>> mount -t ext4 /dev/sda1 -o user_xattr /some/path
>> mount -t ext4 /dev/sda1 -o nouser_xattr /some/other/path
>>
>> And have both mount commands succeed and have two mounts of the same
>> filesystem.  If the mounter is not attentive or the first mount is added
>> earlier it may not be immediately noticed that a mount option that is
>> needed for the correct operation or the security of the system is lost.
>>
>> We have seen this failure mode with both devpts and proc.  So it is not
>> theoretical, and it has resulted in CVEs.
>>
>> In some cases the existing mount API (such as a conflict between ro and
>> rw) handles this by returning -EBUSY.  So we may be able to correct this
>> in the existing mount API.  But it is always very tricky to to get
>> adequate testing for a change like that to avoid regressions, so I am
>> proposing we change this in the new mount api.
>>
>> This has been brought up before and I have been told it is technically
>> infeasible to make this work.  To counter that I have sat down and
>> implemented it.
>>
>> The basic idea is:
>>  - get a handle to a filesystem
>>    (passing enough options to uniquely identify the super block).
>>    Also capture enough state in the file handle to let you know if
>>    the file system has it's mount options changed between system calls.
>>    (essentially this is just the fs code that calls sget)
>>
>>  - If the super block has not been configured allow setting the file
>>    systems options.
>>
>>  - If the super block has already been configured require reading the
>>    file systems mount options before setting/updating the file systems
>>    mount options.
>>
>> To complement that I have functionality that:
>>  - Allows reading a file systems current mount options.
>>  - Allows reading the mount options that are needed to get a handle to
>>    the filesystem.  For most filesystems it is just the block device
>>    name.  For nfs is is essentially all mount options.  For btrfs
>>    it is the block device name, and the "devices=" mount option for
>>    secondary block device names.
>
> Are you taking the LSM specific mount options into account?

In the design yes, and I allow setting them.  It appears in the code
to retrieve the mount options I forgot to call security_sb_show_options.

For finding the super block that you are going to mount the LSM mount
options are not relevant.  Even nfs will not want to set those early as
they do not help determine the nfs super block.  So the only place where
there is anything interesting in my api is in reading back the security
options so they can be compared to the options the mounter is setting.

I will add the missing call to security_sb_show_options which is enough
to fix selinux.  Unfortunately smack does not currently implement
.sb_show_options.  Not implementing smack_sb_show_options means
/proc/mounts fails to match /etc/mtab which is a bug and it is likely
a real workd bug for the people who use smack and don't want to depend
on /etc/mtab, or are transitioning away from it.

Casey do you want to implement smack_sb_show_options or should I put it
on my todo list?

Eric
