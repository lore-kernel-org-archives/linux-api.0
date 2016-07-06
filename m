From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH review 0/11] General unprivileged mount support
Date: Wed, 6 Jul 2016 10:54:40 +0200
Message-ID: <20160706085440.GD14067@quack2.suse.cz>
References: <87ziq03qnj.fsf@x220.int.ebiederm.org>
	<20160704085220.GC5200@quack2.suse.cz>
	<87h9c52wsd.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87h9c52wsd.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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

On Mon 04-07-16 11:27:46, Eric W. Biederman wrote:
> Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Sat 02-07-16 12:18:08, Eric W. Biederman wrote:
> >> 
> >> As well as in these patches the code is also available from:
> >> git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-testing
> >> 
> >> It has been a long time in coming but recently in the userns tree the
> >> superblock has been expanded with a s_user_ns field indicating the user
> >> namespace that owns a superblock.
> >> 
> >> The s_user_ns owner of a superblock has three implications.
> >> - Only kuids and kgids that map into s_user_ns are allowed to be sent to a
> >>  filesystem from the vfs.
> >> - If the uid or gid on the filesystem does not map into s_user_ns i_uid
> >>   is set to INVALID_UID and i_gid is set to INVALID_GID.
> >> - The scope of permission checks can be changed from global to a
> >>   capabilitiy check in s_user_ns.
> >
> > OK, to check that I understand it right:
> >
> > So the uids and gids that are stored on disk are still expected to be in
> > the initial id namespace, aren't they?
> 
> No.
> 
> The general expectation is that the ids on disk are store in s_user_ns.
>
> Id's that don't map to the initial id namespace get stored in the
> generic data structures as INVALID_UID and INVALID_GID.

> In practice I don't expect anyone will set up a situation knowingly
> where id's don't map, but the case has to be handled because mistakes
> and malicious code happens.

OK, thanks for explanation. But then the namespace the filesystem is
mounted with essentially becomes part of the on-disk format, doesn't it?
Because if someone mounts the media from a different namespace, suddently
the UID/GIDs may map to different users in initial user namespace and
consequences may be weird, right? Shouldn't it thus be somehow stored
together with the filesystem to make things more robust?

I don't remember the indented uses for user-ns mounts so I may be just
wrong. But my experience tells me that external data (such as user
namespace ID mappings in your case) that modify meaning of on-disk format
tend to cause maintenance difficulties in the long run... Because someone
*will* have the idea of migrating these fs images between containers /
machines and then they have to make sure mappings get migrated as well and
it all becomes cumbersome.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
