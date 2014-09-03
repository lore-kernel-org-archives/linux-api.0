From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Date: Wed, 3 Sep 2014 12:03:21 -0400
Message-ID: <20140903120321.604f9039@tlielax.poochiereds.net>
References: <5405FBAE.5020303@parallels.com>
	<20140902184456.GC31793@fieldses.org>
	<54061562.4080306@parallels.com>
	<20140902194300.GE31793@fieldses.org>
	<20140902155351.79183446@tlielax.poochiereds.net>
	<540727E0.6030005@parallels.com>
	<20140903115504.63a7ae6f@tlielax.poochiereds.net>
	<54073B02.2060707@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54073B02.2060707-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 3 Sep 2014 20:00:02 +0400
Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:

> On 09/03/2014 07:55 PM, Jeff Layton wrote:
> > On Wed, 3 Sep 2014 18:38:24 +0400
> > Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> > 
> >> On 09/02/2014 11:53 PM, Jeff Layton wrote:
> >>> On Tue, 2 Sep 2014 15:43:00 -0400
> >>> "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
> >>>
> >>>> On Tue, Sep 02, 2014 at 11:07:14PM +0400, Pavel Emelyanov wrote:
> >>>>> On 09/02/2014 10:44 PM, J. Bruce Fields wrote:
> >>>>>> On Tue, Sep 02, 2014 at 09:17:34PM +0400, Pavel Emelyanov wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> There's a problem with getting information about who has a flock on
> >>>>>>> a specific file. The thing is that the "owner" field, that is shown in
> >>>>>>> /proc/locks is the pid of the task who created the flock, not the one
> >>>>>>> who _may_ hold it.
> >>>>>>>
> >>>>>>> If the flock creator shared the file with some other task (by forking
> >>>>>>> or via scm_rights) and then died or closed the file, the information
> >>>>>>> shown in proc no longer corresponds to the reality.
> >>>>>>>
> >>>>>>> This is critical for CRIU project, that tries to dump (and restore)
> >>>>>>> the state of running tasks. For example, let's take two tasks A and B
> >>>>>>> both opened a file "/foo", one of tasks places a LOCK_SH lock on the 
> >>>>>>> file and then "obfuscated" the owner field in /proc/locks. After this
> >>>>>>> we have no ways to find out who is the lock holder.
> >>>>>>>
> >>>>>>> I'd like to note, that for LOCK_EX this problem is not critical -- we
> >>>>>>> may go to both tasks and "ask" them to LOCK_EX the file again (we can
> >>>>>>> do it in CRIU, I can tell more if required). The one who succeeds is 
> >>>>>>> the lock holder.
> >>>>>>
> >>>>>> It could be both, actually, right?
> >>>>>
> >>>>> Two succeeding with LOCK_EX? AFAIU no. Am I missing something?
> >>>>
> >>>> After a fork, two processes "own" the lock, right?:
> >>>>
> >>>> 	int main(int argc, char *argv[])
> >>>> 	{
> >>>> 		int fd, ret;
> >>>> 	
> >>>> 		fd = open(argv[1], O_RDWR);
> >>>> 		ret = flock(fd, LOCK_EX);
> >>>> 		if (ret)
> >>>> 			err(1, "flock");
> >>>> 		ret = fork();
> >>>> 		if (ret == -1)
> >>>> 			err(1, "flock");
> >>>> 		ret = flock(fd, LOCK_EX);
> >>>> 		if (ret)
> >>>> 			err(1, "flock");
> >>>> 		printf("%d got exclusive lock\n", getpid());
> >>>> 		sleep(1000);
> >>>> 	}
> >>>>
> >>>> 	$ touch TMP
> >>>> 	$ ./test TMP
> >>>> 	15882 got exclusive lock
> >>>> 	15883 got exclusive lock
> >>>> 	^C
> >>>>
> >>>> I may misunderstand what you're doing.
> >>>>
> >>>
> >>> Yeah, I don't understand either.
> >>>
> >>> Flock locks are owned by the file description. The task that set
> >>> them is really irrelevant once they are set.
> >>>
> >>> In the second flock() call there, you're just "modifying" an existing
> >>> lock (which turns out to be a noop here).
> >>>
> >>> So, I don't quite understand the problem this solves. I get that you're
> >>> trying to reestablish the flock "state" after a checkpoint/restore
> >>> event, but why does it matter what task actually sets the locks as long
> >>> as they're set on the correct set of fds?
> >>
> >> Sorry for confusion. Let me try to explain it more clearly.
> >>
> >> First, what I meant talking about two LOCK_EX locks. Let's consider
> >> this scenario:
> >>
> >> pid = fork()
> >> fd = open("/foo"); /* both parent and child has _different_ files */
> >> if (pid == 0)
> >> 	/* child only */
> >> 	flock(fd, LOCK_EX);
> >>
> >> at this point we have two different files pointing to "/foo" and 
> >> only one of them has LOCK_EX on it. So if try to LOCK_EX it again, 
> >> only at child's file this would succeed. So we can distinguish which
> >> file is locked using this method.
> >>
> >>
> >>
> >> Now, what problem this patch is trying to solve. It's quite tricky, 
> >> but still. Let's imagine this scenario:
> >>
> >> pid = fork();
> >> fd = open("/foo"); /* yet again -- two different files */
> >> if (pid == 0) {
> >> 	flock(fd, LOCK_SH);
> >> 	pid2 = fork();
> >> 	if (pid2 != 0)
> >> 		exit(0);
> >> }
> >>
> >> at this point we have:
> >>
> >> task A -- the original task with file "/foo" opened
> >> task B -- the first child, that exited at the end
> >> task C -- the 2nd child, that "inherited" a file with the lock from B
> >>
> >> Note, that file at A and file at C are two different files (struct 
> >> file-s). And it's only the C's one that is locked.
> >>
> >> The problem is that the /proc/locks shows the pid of B in this lock's
> >> owner field. And we have no glue to find out who the real lock owner
> >> is using the /proc/locks.
> >>
> >> If we try to do the trickery like the one we did with LOCK_EX above,
> >> this is what we would get.
> >>
> >> If putting the 2nd LOCK_SH from A and from C, both attempts would succeed,
> >> so this is not the solution.
> >>
> >> If we try to LOCK_EX from A and C, only C would succeed, so this seem
> >> to be the solution, but it's actually not. If there's another pair of 
> >> A' and C' tasks holding the same "/foo" and having the LOCK_SH on C', 
> >> this trick would stop working as none of the tasks would be able to 
> >> put such lock on this file.
> >>
> >>
> >> Thus, we need some way to find out whether a task X has a lock on file F.
> >> This patch is one of the ways of doing this.
> >>
> >> Hope this explanation is more clear.
> >>
> > 
> > Yes, thanks for clarifying.
> > 
> > I think we do need to be a bit careful when describing this though.
> > 
> > flock locks are not owned by tasks, but by the file description. So you
> > can't really tell whether task X has a lock on file F. Several tasks
> > could have a reference to file F and none of them has any more "claim"
> > to a lock on that file than another (at least from an API standpoint).
> > 
> > What your patch really does is tell you whether that file description
> > has a particular type of lock set on it.
> 
> Exactly.
> 
> > Like Bruce, I think this looks fairly reasonable. That said, I had to
> > go through a bunch of API gyrations recently when getting the OFD lock
> > patches merged. It would be good to accompany your kernel patch with
> > glibc and manpage patches as well so we can make sure we have the
> > design settled before merging anything.
> > 
> > Sound OK?
> 
> Sure! But I think glibc and man-pages people would first want the
> kernel part to get finished, as it's the part that mostly drives the
> API. Since the linux-api@ is in Cc for this patch, what else would
> you suggest me to do to keep the process moving?
> 
> Thanks,
> Pavel
> 

(cc'ing Michael Kerrisk, the manpages maintainer)

Michael had good suggestions for me when I was doing the OFD lock work.
I'd also consider cc'ing the glibc development list.

Cheers,
-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
