From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2 review 09/11] quota: Handle quota data stored in
 s_user_ns.
Date: Mon, 4 Jul 2016 11:11:00 +0200
Message-ID: <20160704091100.GD5200@quack2.suse.cz>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
 <20160702172035.19568-1-ebiederm@xmission.com>
 <20160702172035.19568-9-ebiederm@xmission.com>
 <87mvm03pxy.fsf_-_@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87mvm03pxy.fsf_-_-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat 02-07-16 12:33:29, Eric W. Biederman wrote:
> In Q_XSETQLIMIT use sb->s_user_ns to detect when we are dealing with
> the filesystems notion of id 0.

Hum, is it really usable? Basically the tool calling Q_XSETQLIMIT would
have to be aware of the namespace the filesystem is mounted in to be able
to perform the desired operation (and if it gets is wrong, there's
possibility it would just silently set the timers for some user instead of
for all users).

> For the dquot hashfn translate the qid into sb->s_user_ns to remove
> extraneous bits before hashing.
> 
> When dealing with generic quota files in quota_tree.c, quota_v1.c, and
> quota_v2.c before writing quotas to the file encode them in
> sb->s_user_ns, and decode ids read from the file from sb->s_user_ns.

And here the sb->s_user_ns becomes part of the on-disk format because the
numerical ID value is used to compute the position in on-disk data
structures. This seems to be in conflict with the idea that anything that
is stored on disk is stored in the initial user namespace.

> One complication comes up in qtree_get_next_id, as it is possible in
> principle for id's to be present in the quota file that do not have a
> mapping in the filesystems user namespace.  If that is the case the
> code is modified to skip the unmapped ids.

So I'm not 100% sure how this is going to work. qtree_get_next_id() is used
as an interface to report quota information for the whole filesystem. So
skipping ids without mappings makes sense. However userspace uses the
interface as:

id = 0;
while (get_next_quota(id, &result)) {
	do stuff;
	id = result.dq_id + 1;
}

If sb->s_user_ns is the current namespace of the process, I suppose this is
going to work as expected. If the namespace of the process is different
(including the init_user_ns), I expect this breaks, doesn't it?

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
