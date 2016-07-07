From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Introspecting userns relationships to other namespaces?
Date: Thu, 07 Jul 2016 12:17:35 -0700
Message-ID: <1467919055.2322.36.camel@HansenPartnership.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	 <87r3b7pxja.fsf@x220.int.ebiederm.org>
	 <CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	 <20160706141348.GB20728@mail.hallyn.com>
	 <CAKgNAkhtQNg0mVv6ei_JigNz3njo_G3opE+rzd4OtKpa2hQe9g@mail.gmail.com>
	 <20160707133631.GA2994@mail.hallyn.com>
	 <1467903712.2347.16.camel@HansenPartnership.com>
	 <CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKgNAkg+OiBngdFsdVR0gsSnVhMppuH2DxMBLCNAx8in5C0-zQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2016-07-07 at 20:21 +0200, Michael Kerrisk (man-pages) wrote:
> On 7 July 2016 at 17:01, James Bottomley
> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
[Serge already answered the parenting issue]
> > On Thu, 2016-07-07 at 08:36 -0500, Serge E. Hallyn wrote:
> > > Hm.  Probably best-effort based on the process hierarchy.  So 
> > > yeah you could probably get a tree into a state that would be 
> > > wrongly recreated. Create a new netns, bind mount it, exit;  Have 
> > > another task create a new user_ns, bind mount it, exit;  Third 
> > > task setns()s first to the new netns then to the new user_ns.  I 
> > > suspect criu will recreate that wrongly.
> > 
> > This is a bit pathological, and you have to be root to do it: so 
> > root can set up a nesting hierarchy, bind it and destroy the pids 
> > but I know of no current orchestration system which does this.
> > 
> > Actually, I have to back pedal a bit: the way I currently set up
> > architecture emulation containers does precisely this: I set up the
> > namespaces unprivileged with child mount namespaces, but then I ask
> > root to bind the userns and kill the process that created it so I 
> > have a permanent handle to enter the namespace by, so I suspect 
> > that when our current orchestration systems get more sophisticated, 
> > they might eventually want to do something like this as well.
> > 
> > In theory, we could get nsfs to show this information as an option
> > (just add a show_options entry to the superblock ops), but the 
> > problem is that although each namespace has a parent user_ns, 
> > there's no way to get it without digging in the namespace specific 
> > structure.  Probably we should restructure to move it into 
> > ns_common, then we could display it (and enforce all namespaces 
> > having owning user_ns) but it would be a
> 
> I'm missing something here. Is it not already the case that all
> namespaces have an owning user_ns?

Um, yes, I don't believe I said they don't.  The problem I thought you
were having is that there's no way of seeing what it is.

nsfs is the Namespace fileystem where bound namespaces appear to a cat
of /proc/self/mounts.  It can display any information that's in
ns_common (the common core of namespaces) but the owning user_ns
pointer currently isn't in this structure.  Every user namespace has a
pointer to it, but they're all privately embedded in the individual
namespace specific structures.  What I was proposing was that since
every current namespace has a pointer somewhere to the owning user
namespace, we could abstract this out into ns_common so it's now
accessible to be displayed by nsfs, probably as a mount option.

James
