From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [CRIU] Introspecting userns relationships to other namespaces?
Date: Fri, 08 Jul 2016 18:52:09 -0500
Message-ID: <87wpkvpu1i.fsf@x220.int.ebiederm.org>
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
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5e4cc802-f0e0-4f4c-a2f7-585aaaa8feec-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org> (James
	Bottomley's message of "Fri, 08 Jul 2016 15:19:28 -0700")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-RxcU5blhW6jCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

James Bottomley <James.Bottomley-RxcU5blhW6jCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> writes:

> On July 8, 2016 1:38:19 PM PDT, Andrew Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

>>What do you think about the idea to mount nsfs and be able to look up
>>any alive namespace by inum:
>
> I think I like it.  It will give us a way to enter any extant
> namespace.  It will work for Eric's fs namespaces as well.  Perhaps a
> /process/ns/<inum> Directory?

*Shivers*

That makes it very easy to bypass any existing controls that exist for
getting at namespaces.  It is true that everything of that kind is
directory based but still.

Plus I think it would serve as information leak to information outside
of the container.

An operation to get a user namespace file descriptor from some kernel
object sounds reasonably sane.

A great big list of things sounds about as scary as it can get.  This is
not the time to be making it easier to escape from containers.

Eric
