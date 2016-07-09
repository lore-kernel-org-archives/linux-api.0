From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Fri, 08 Jul 2016 17:15:32 -0700
Message-ID: <1468023332.2390.10.camel@HansenPartnership.com>
References: <c2a26220-69f2-f2f5-491a-e43abd9a6f92@gmail.com>
	 <87r3b7pxja.fsf@x220.int.ebiederm.org>
	 <CAKgNAkgQbxLH-B3N3Xti3LLis+1Y-SJD2h1DEaXao7zTDA7pug@mail.gmail.com>
	 <20160706141348.GB20728@mail.hallyn.com>
	 <871t36kbvq.fsf@x220.int.ebiederm.org>
	 <20160708015758.GA10512@outlook.office365.com>
	 <87vb0gy3nr.fsf@x220.int.ebiederm.org>
	 <1467988533.2322.118.camel@HansenPartnership.com>
	 <20160708203818.GA2602@outlook.office365.com>
	 <5e4cc802-f0e0-4f4c-a2f7-585aaaa8feec@email.android.com>
	 <87wpkvpu1i.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87wpkvpu1i.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 2016-07-08 at 18:52 -0500, Eric W. Biederman wrote:
> James Bottomley <James.Bottomley-RxcU5blhW6jCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> writes:
> 
> > On July 8, 2016 1:38:19 PM PDT, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> > wrote:
> 
> > > What do you think about the idea to mount nsfs and be able to 
> > > look up any alive namespace by inum:
> > 
> > I think I like it.  It will give us a way to enter any extant
> > namespace.  It will work for Eric's fs namespaces as well.  Perhaps 
> > a /process/ns/<inum> Directory?

As you understood, I meant /proc/ns/<inum> (damn mobile phone
completions).

> *Shivers*
> 
> That makes it very easy to bypass any existing controls that exist 
> for getting at namespaces.  It is true that everything of that kind 
> is directory based but still.
> 
> Plus I think it would serve as information leak to information 
> outside of the container.
> 
> An operation to get a user namespace file descriptor from some kernel
> object sounds reasonably sane.
> 
> A great big list of things sounds about as scary as it can get.  This 
> is not the time to be making it easier to escape from containers.

To be honest, I think this argument is rubbish.  If we're afraid of
giving out a list of all the namespaces, it means we're afraid there's
some security bug and we're trying to obscure it by making the list
hard to get.  All we've done is allayed fears about the bug but the
hackers still know the portals to get through.

If such a bug exists, it will be possible to exploit it by simply
reconstructing the information from the individual process directories,
so obscurity doesn't protect us and all it does is give us a false
sense of security.   If such a bug doesn't exist, then all the security
mechanisms currently in place (like no re-entry to prior namespace)
should protect us and we can give out the list.

Let's deal with the world as we'd like it to be (no obscure namespace
bugs) and accept the consequences and the responsibility for fixing
them if we turn out to be slightly incorrect.  We'll end up in a far
better place than security by obscurity would land us.

James
