From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Mon, 11 Jul 2016 06:06:48 +0900
Message-ID: <1468184808.19833.30.camel@HansenPartnership.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	<87r3b7pxja.fsf@x220.int.ebiederm.org>
	<CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	<20160706141348.GB20728@mail.hallyn.com>
	<CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	<20160707133631.GA2994@mail.hallyn.com>
	<1467903712.2347.16.camel@HansenPartnership.com>
	<20160709031528.GA25507@odin.tremily.us>
	<87ziprmrln.fsf@x220.int.ebiederm.org>
	<20160710053609.GB4868@outlook.office365.com>
	<87furhjkxw.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87furhjkxw.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk
	(man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, 2016-07-10 at 15:29 -0500, Eric W. Biederman wrote:
> Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
> 
> > On Fri, Jul 08, 2016 at 10:13:08PM -0500, Eric W. Biederman wrote:
> > > "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org> writes:
> > > 
> > > > On Thu, Jul 07, 2016 at 08:01:52AM -0700, James Bottomley
> > > > wrote:
> > > > > In theory, we could get nsfs to show this information as an
> > > > > option
> > > > > (just add a show_options entry to the superblock ops), but
> > > > > the
> > > > > problem is that although each namespace has a parent user_ns,
> > > > > there's no way to get it without digging in the namespace
> > > > > specific
> > > > > structure.  Probably we should restructure to move it into
> > > > > ns_common, then we could display it (and enforce all
> > > > > namespaces
> > > > > having owning user_ns) but it would be a reasonably large
> > > > > (but
> > > > > mechanical) change.
> > > > 
> > > > It sounds like everyone is either positive or or neutral on
> > > > this
> > > > groundwork, even if we haven't decided if/how to expose the
> > > > information to userspace.  I'm happy to work up a patch while
> > > > the rest
> > > > of the discussion continues.  I'm also happy to let someone
> > > > else work
> > > > up the patch, if anyone else is chomping at the bit ;).
> > > 
> > > I am dubious on moving all of the user namespace members into
> > > ns_common.
> > > 
> > > I would happy to be proved wrong but I suspect in the cases where
> > > we
> > > actually use that user namespace the code will become uglier. 
> > >  Making
> > > the ordinary uses uglier to make a rare corner case nicer is the
> > > wrong
> > > trade off.
> > > 
> > > But feel free to try it is certainly worth doing if it doesn't
> > > make the
> > > code that uses the user namespaces uglier.
> > 
> > If it's interesting for someone, I have this patch in my tree
> > https://github.com/avagin/linux-task-diag/commit/63b32df68ae8d3a384
> > 2bae42bbcae3468db76d85
> > 
> > I can't say that it makes something uglier.
> 
> I have only skimmed things but overall it looks better than I had
> feared.

It looks about as messy as I feared, but since someone else has done
all the hard work, I'm happy.

> At the same time I really really don't like losing the parent pointer 
> in the user namespace case.  That is seriously obfuscating.

Because it has a slightly different meaning from all other namespaces? 
 If I assume that's what you mean, I think looking at it in a different
way can solve the problem:  The pointer in ns_common is always to the
owning user_ns, so we can label it as such.  Even for a child user_ns,
the owning user_ns is simply the parent.  I think it makes logical
sense to think of all user_ns to namespace relationships as
owning/owned rather than most as owning/owned and some as parent/child.

James

> Eric
> 
> _______________________________________________
> Containers mailing list
> Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
> 
