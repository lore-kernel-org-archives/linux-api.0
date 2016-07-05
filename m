From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 review 09/11] quota: Handle quota data stored in s_user_ns.
Date: Tue, 05 Jul 2016 10:34:49 -0500
Message-ID: <87d1msumhy.fsf@x220.int.ebiederm.org>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
	<20160702172035.19568-9-ebiederm@xmission.com>
	<87mvm03pxy.fsf_-_@x220.int.ebiederm.org>
	<20160704091100.GD5200@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160704091100.GD5200@quack2.suse.cz> (Jan Kara's message of
	"Mon, 4 Jul 2016 11:11:00 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Seth Forshee <seth.forshee@canonical.com>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-fsdevel@vger.kernel.org, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Sat 02-07-16 12:33:29, Eric W. Biederman wrote:
>> In Q_XSETQLIMIT use sb->s_user_ns to detect when we are dealing with
>> the filesystems notion of id 0.
>
> Hum, is it really usable? Basically the tool calling Q_XSETQLIMIT would
> have to be aware of the namespace the filesystem is mounted in to be able
> to perform the desired operation (and if it gets is wrong, there's
> possibility it would just silently set the timers for some user instead of
> for all users).

In general yes.  Because we are talking about the uid of the root user
in the container that mounted the filesystem.  It is the uid that is
stored as 0 on the filesystem.  So in the small everything looks normal.

>> For the dquot hashfn translate the qid into sb->s_user_ns to remove
>> extraneous bits before hashing.
>> 
>> When dealing with generic quota files in quota_tree.c, quota_v1.c, and
>> quota_v2.c before writing quotas to the file encode them in
>> sb->s_user_ns, and decode ids read from the file from sb->s_user_ns.
>
> And here the sb->s_user_ns becomes part of the on-disk format because the
> numerical ID value is used to compute the position in on-disk data
> structures. This seems to be in conflict with the idea that anything that
> is stored on disk is stored in the initial user namespace.

Up to now it has been the case that all filesystems with a backing store
that the kernel could mount stored their data in the initial user
namespace.  This set of changes is all about making it so that a
filesystem with uids and gids stored in s_user_ns can be supported
safely by the kernel.

>> One complication comes up in qtree_get_next_id, as it is possible in
>> principle for id's to be present in the quota file that do not have a
>> mapping in the filesystems user namespace.  If that is the case the
>> code is modified to skip the unmapped ids.
>
> So I'm not 100% sure how this is going to work. qtree_get_next_id() is used
> as an interface to report quota information for the whole filesystem. So
> skipping ids without mappings makes sense. However userspace uses the
> interface as:
>
> id = 0;
> while (get_next_quota(id, &result)) {
> 	do stuff;
> 	id = result.dq_id + 1;
> }
>
> If sb->s_user_ns is the current namespace of the process, I suppose this is
> going to work as expected. If the namespace of the process is different
> (including the init_user_ns), I expect this breaks, doesn't it?

Possibly.  And this is a good question.

Where this will break initially in that scenario is in:
static int quota_getnextquota(struct super_block *sb, int type, qid_t id,
			  void __user *addr)
{
        ...

	if (!sb->s_qcop->get_nextdqblk)
		return -ENOSYS;
	qid = make_kqid(current_user_ns(), type, id);
	if (!qid_has_mapping(sb->s_user_ns, qid))
		return -EINVAL;
	ret = sb->s_qcop->get_nextdqblk(sb, &qid, &fdq);
	if (ret)

If userspace actually has to perform the increment.  The way
I read the code in 

Now it has occurred to me that I am probably getting ahead of things
with actually enabling all of this for the quota subsystem as I don't
think we have fileystems that use the vfs quota support on our short
term list.   I don't think these patches are wrong except possibily
in handling a quota interface with unmapped ids.  Which is sufficiently
weird I don't know if there is something better we can do.

Given that we are not likely to use quotas for a while I am happy
to add a test in vfs_load_quota_inode (the guts of quota_on, and
quota_enable) that tests if s_user_ns != &init_user_ns and just fails.
Then the quota changes can be left until we figure out how to support a
filesystem that uses quota support.  That should ensure better testing
coverage if nothing else.

The more I think of it the more I think that sounds like wisdom.
Dropping this patch and replacing it by one that just does:

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index d8fb0fd3ff6f..9c9890fe18b7 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2273,6 +2273,11 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
                error = -EINVAL;
                goto out_fmt;
        }
+       /* Filesystems outside of init_user_ns not yet supported */
+       if (sb->s_user_ns != &init_user_ns) {
+               error = -EINVAL;
+               goto out_fmt;
+       }
        /* Usage always has to be set... */
        if (!(flags & DQUOT_USAGE_ENABLED)) {
                error = -EINVAL;


seems a lot more appropriate at this point.  That is enough to give a
great big hint there is something that needs to be done but won't
embrittle the code with untested corner cases.

Especially since the code probably needs testing and a very close review
to see what problems a hostile quota file can create.  I the quota files
are simple enough we can't get into to much trouble but that is an
important consideration at this point.

So I am going to go respin this patchset replacing this change.

Eric
