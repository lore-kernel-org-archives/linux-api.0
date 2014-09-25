From: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/4] Adds project quota support for ext4
Date: Thu, 25 Sep 2014 09:28:24 +0800
Message-ID: <CAPTn0cB8X3DYprX-oKCu8aV5OLLfJJ2rh9YvMY7re69gi1s-LA@mail.gmail.com>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-4-git-send-email-lixi@ddn.com>
	<20140924173123.GH27000@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140924173123.GH27000-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 25, 2014 at 1:31 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Wed 24-09-14 22:04:29, Li Xi wrote:
>> This patch adds mount options for enabling/disabling project quota
>> accounting and enforcement. A new specific inode is also used for
>> project quota accounting.
>   The patch looks mostly fine. A few smaller things below.
>
> ...
>> @@ -1433,6 +1437,8 @@ static const struct mount_opts {
>>                                                       MOPT_SET | MOPT_Q},
>>       {Opt_grpquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_GRPQUOTA,
>>                                                       MOPT_SET | MOPT_Q},
>> +     {Opt_prjquota, EXT4_MOUNT_QUOTA | EXT4_MOUNT_PRJQUOTA,
>> +                                                     MOPT_SET | MOPT_Q},
>>       {Opt_noquota, (EXT4_MOUNT_QUOTA | EXT4_MOUNT_USRQUOTA |
>>                      EXT4_MOUNT_GRPQUOTA), MOPT_CLEAR | MOPT_Q},
>   I think you missed to add EXT4_MOUNT_PRJQUOTA to Opt_noquota...
>
> ...
>> @@ -2833,6 +2855,13 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
>>                        "without CONFIG_QUOTA");
>>               return 0;
>>       }
>> +     if (EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_PROJECT) &&
>> +         !readonly) {
>> +             ext4_msg(sb, KERN_ERR,
>> +                      "Filesystem with project quota feature cannot be"
>> +                      "mounted RDWR without CONFIG_QUOTA");
>> +             return 0;
>> +     }
>   Hum, I don't think this is right. EXT4_FEATURE_RO_COMPAT_PROJECT is about
> maintaining project IDs not about quota. So it seems perfectly OK to have
> EXT4_FEATURE_RO_COMPAT_PROJECT without CONFIG_QUOTA.
Ah, I see. This might be my main misunderstanding. I thought it is
about maintaining
both project IDs and quota. And I misunderstood so that I removed all
EXT4_FEATURE_RO_COMPAT_PROJECT checking when set/get project ID.
If we only use EXT4_FEATURE_RO_COMPAT_PROJECT to protect imcompatibility
of project ID, what about the change of struct ext4_super_block? I am
still confused.
Please advise.

Regards,
Li Xi
