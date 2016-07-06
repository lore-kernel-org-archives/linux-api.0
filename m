From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH review 07/11] vfs: Don't create inodes with a uid or gid
	unknown to the vfs
Date: Wed, 6 Jul 2016 11:07:05 +0200
Message-ID: <20160706090705.GE14067@quack2.suse.cz>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160702172035.19568-1-ebiederm@xmission.com>
	<20160702172035.19568-7-ebiederm@xmission.com>
	<20160704075919.GA5200@quack2.suse.cz>
	<87zipwxhgp.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87zipwxhgp.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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

On Tue 05-07-16 09:55:18, Eric W. Biederman wrote:
> Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Sat 02-07-16 12:20:31, Eric W. Biederman wrote:
> >> It is expected that filesystems can not represent uids and gids from
> >> outside of their user namespace.  Keep things simple by not even
> >> trying to create filesystem nodes with non-sense uids and gids.
> >> 
> >> Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> >
> > So if we have sb->s_user_ns that doesn't map UID and GID 0, root cannot
> > directly create files in this filesystem. EOVERFLOW error will at least
> > hint us where the problem is but still I'm suspecting this is going to
> > create hard to debug configuration issues... I'm not sure if we can do
> > anything about this but I wanted to point it out.
> 
> A reasonable point.
> 
> A couple of details.
> 
> - If there is no uid or gid 0 inside of a user namespace there is
>   no root user in that namespace so this is a moot point.
> 
> - If we are talking about uid 0 in the initial user namespace the
>   scenario you are worried about can occur, but you have to work at it
>   to get into that situation.
> 
> To create a superblock has s_user_ns != &init_user_ns something like
> the following has to occur.
> 
> setuid(1000);
> unshare(CLONE_NEWUSER);
> unshare(CLONE_NEWNS);
> mount(....);
> 
> At which point the oridinary root user can not see the filesystem
> with s_user_ns != &init_user_ns as it is located in another mount
> namespace.
> 
> Which means root has to use setns to get into that mount namespace,
> so there are going to be larger hints than -EOVERFLOW.

OK, I see. Thanks for explanation. The inability of the admin (UID 0 in
init_user_ns) to easily see and change any filesystem mounted in the system
makes me somewhat nervous ;). But I guess the complexity is the price for
the flexibility...

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
