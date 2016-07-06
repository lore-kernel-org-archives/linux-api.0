From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH v2 review 09/11] quota: Handle quota data stored in
	s_user_ns.
Date: Wed, 6 Jul 2016 16:35:04 +1000
Message-ID: <20160706063504.GH27480@dastard>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
	<20160702172035.19568-9-ebiederm@xmission.com>
	<87mvm03pxy.fsf_-_@x220.int.ebiederm.org>
	<20160704091100.GD5200@quack2.suse.cz>
	<87d1msumhy.fsf@x220.int.ebiederm.org>
	<20160705205721.GG27480@dastard>
	<8737nnrcyy.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8737nnrcyy.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 05, 2016 at 04:28:53PM -0500, Eric W. Biederman wrote:
> Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> writes:
> 
> > On Tue, Jul 05, 2016 at 10:34:49AM -0500, Eric W. Biederman wrote:
> >> The more I think of it the more I think that sounds like wisdom.
> >> Dropping this patch and replacing it by one that just does:
> >> 
> >> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> >> index d8fb0fd3ff6f..9c9890fe18b7 100644
> >> --- a/fs/quota/dquot.c
> >> +++ b/fs/quota/dquot.c
> >> @@ -2273,6 +2273,11 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
> >>                 error = -EINVAL;
> >>                 goto out_fmt;
> >>         }
> >> +       /* Filesystems outside of init_user_ns not yet supported */
> >> +       if (sb->s_user_ns != &init_user_ns) {
> >> +               error = -EINVAL;
> >> +               goto out_fmt;
> >> +       }
> >>         /* Usage always has to be set... */
> >>         if (!(flags & DQUOT_USAGE_ENABLED)) {
> >>                 error = -EINVAL;
> >> 
> >> 
> >> seems a lot more appropriate at this point.  That is enough to give a
> >> great big hint there is something that needs to be done but won't
> >> embrittle the code with untested corner cases.
> >
> > You'll need to propagate that to all filesystems that have their own
> > quota implemenation, too.
> 
> All of the filesytems that have their own quota implementations omit the
> flag FS_USERNS_MOUNT in fs_flags in struct filesystem so they are
> protected.

Which is the same situation currently for every filesystem that
supports quotas, regardless of the implementation infrastructure.

> p.s.  I  expect the the generic quota implementation is simple enough
> that it is not particularly suseptible to problems caused by malicious
> data.  But I don't currently care enough to verify and test that
> assumption so this is very much the wrong time for me to be enabling the
> feature.

All the more reason you should be adding the same guard to all the
other filesystems....

All i'm asking you to do is to make this check in a way that all
filesystems that implement quotas will execute it. Don't leave
landmines with security implications around - make sure all
filesystems have the same protections.

-Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
