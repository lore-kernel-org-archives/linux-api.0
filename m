From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v2 review 09/11] quota: Handle quota data stored in s_user_ns.
Date: Tue, 05 Jul 2016 16:28:53 -0500
Message-ID: <8737nnrcyy.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
	<20160702172035.19568-9-ebiederm@xmission.com>
	<87mvm03pxy.fsf_-_@x220.int.ebiederm.org>
	<20160704091100.GD5200@quack2.suse.cz>
	<87d1msumhy.fsf@x220.int.ebiederm.org>
	<20160705205721.GG27480@dastard>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160705205721.GG27480@dastard> (Dave Chinner's message of "Wed,
	6 Jul 2016 06:57:21 +1000")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> writes:

> On Tue, Jul 05, 2016 at 10:34:49AM -0500, Eric W. Biederman wrote:
>> The more I think of it the more I think that sounds like wisdom.
>> Dropping this patch and replacing it by one that just does:
>> 
>> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
>> index d8fb0fd3ff6f..9c9890fe18b7 100644
>> --- a/fs/quota/dquot.c
>> +++ b/fs/quota/dquot.c
>> @@ -2273,6 +2273,11 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
>>                 error = -EINVAL;
>>                 goto out_fmt;
>>         }
>> +       /* Filesystems outside of init_user_ns not yet supported */
>> +       if (sb->s_user_ns != &init_user_ns) {
>> +               error = -EINVAL;
>> +               goto out_fmt;
>> +       }
>>         /* Usage always has to be set... */
>>         if (!(flags & DQUOT_USAGE_ENABLED)) {
>>                 error = -EINVAL;
>> 
>> 
>> seems a lot more appropriate at this point.  That is enough to give a
>> great big hint there is something that needs to be done but won't
>> embrittle the code with untested corner cases.
>
> You'll need to propagate that to all filesystems that have their own
> quota implemenation, too.

All of the filesytems that have their own quota implementations omit the
flag FS_USERNS_MOUNT in fs_flags in struct filesystem so they are
protected.

The above change is extending to the generic implementation of quota
files the same protection that is already enjoyed by filesystems in
general.  Recognition that being attacked by malicious users is a
difficult thing to defend against, and not enabling the code until there
is a reasonable certainty the code is robust against maliciuos attack
and everyone involved with maintaining the code is comfortable about the
situtation.

I have every intention of keeping all of the changes to the generic
parts of the quota layer so that filesystems who wish to implement
unprivileged mounts and implement quotas may proceed if they so desire.

Eric

p.s.  I  expect the the generic quota implementation is simple enough
that it is not particularly suseptible to problems caused by malicious
data.  But I don't currently care enough to verify and test that
assumption so this is very much the wrong time for me to be enabling the
feature.
