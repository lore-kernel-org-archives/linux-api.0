From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] locks: Ability to test for flock presence on fd
Date: Tue, 2 Sep 2014 15:53:51 -0400
Message-ID: <20140902155351.79183446@tlielax.poochiereds.net>
References: <5405FBAE.5020303@parallels.com>
	<20140902184456.GC31793@fieldses.org>
	<54061562.4080306@parallels.com>
	<20140902194300.GE31793@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140902194300.GE31793-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 2 Sep 2014 15:43:00 -0400
"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:

> On Tue, Sep 02, 2014 at 11:07:14PM +0400, Pavel Emelyanov wrote:
> > On 09/02/2014 10:44 PM, J. Bruce Fields wrote:
> > > On Tue, Sep 02, 2014 at 09:17:34PM +0400, Pavel Emelyanov wrote:
> > >> Hi,
> > >>
> > >> There's a problem with getting information about who has a flock on
> > >> a specific file. The thing is that the "owner" field, that is shown in
> > >> /proc/locks is the pid of the task who created the flock, not the one
> > >> who _may_ hold it.
> > >>
> > >> If the flock creator shared the file with some other task (by forking
> > >> or via scm_rights) and then died or closed the file, the information
> > >> shown in proc no longer corresponds to the reality.
> > >>
> > >> This is critical for CRIU project, that tries to dump (and restore)
> > >> the state of running tasks. For example, let's take two tasks A and B
> > >> both opened a file "/foo", one of tasks places a LOCK_SH lock on the 
> > >> file and then "obfuscated" the owner field in /proc/locks. After this
> > >> we have no ways to find out who is the lock holder.
> > >>
> > >> I'd like to note, that for LOCK_EX this problem is not critical -- we
> > >> may go to both tasks and "ask" them to LOCK_EX the file again (we can
> > >> do it in CRIU, I can tell more if required). The one who succeeds is 
> > >> the lock holder.
> > > 
> > > It could be both, actually, right?
> > 
> > Two succeeding with LOCK_EX? AFAIU no. Am I missing something?
> 
> After a fork, two processes "own" the lock, right?:
> 
> 	int main(int argc, char *argv[])
> 	{
> 		int fd, ret;
> 	
> 		fd = open(argv[1], O_RDWR);
> 		ret = flock(fd, LOCK_EX);
> 		if (ret)
> 			err(1, "flock");
> 		ret = fork();
> 		if (ret == -1)
> 			err(1, "flock");
> 		ret = flock(fd, LOCK_EX);
> 		if (ret)
> 			err(1, "flock");
> 		printf("%d got exclusive lock\n", getpid());
> 		sleep(1000);
> 	}
> 
> 	$ touch TMP
> 	$ ./test TMP
> 	15882 got exclusive lock
> 	15883 got exclusive lock
> 	^C
> 
> I may misunderstand what you're doing.
> 

Yeah, I don't understand either.

Flock locks are owned by the file description. The task that set
them is really irrelevant once they are set.

In the second flock() call there, you're just "modifying" an existing
lock (which turns out to be a noop here).

So, I don't quite understand the problem this solves. I get that you're
trying to reestablish the flock "state" after a checkpoint/restore
event, but why does it matter what task actually sets the locks as long
as they're set on the correct set of fds?

> > >> With LOCK_SH this doesn't work. Trying to drop the
> > >> lock doesn't work either, as flock(LOCK_UN) reports 0 in both cases:
> > >> if the file is locked and if it is not.
> > >>
> > >> That said, I'd like to propose the LOCK_TEST flag to the flock call,
> > >> that would check whether the lock of the given type (LOCK_SH or LOCK_EX)
> > >> exists on the file we test. It's not the same as the existing in-kernel
> > >> FL_ACCESS flag, which checks whether the new lock is possible, but
> > >> it's a new FL_TEST flag, that checks whether the existing lock is there.
> > >>
> > >> What do you think?
> > > 
> > > I guess I can't see anything really wrong with it.
> > > 
> > > It ignores the (poorly documented) LOCK_MAND case, but maybe that's OK.
> > 
> > I actually checked it and it seemed to work. What problems do
> > you see with this case?
> 
> On its own it just doesn't tell you whether or not LOCK_MAND is set.
> But I guess you can still get that out of /proc/locks.
> 
> To be honest I don't really know whether LOCK_MAND works or is used.
> 
> --b.


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
