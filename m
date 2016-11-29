From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] user-namespaced file capabilities - now with even
 more magic
Date: Tue, 29 Nov 2016 15:29:52 -0600
Message-ID: <20161129212952.GA10816@mail.hallyn.com>
References: <20161119151739.GA16398@mail.hallyn.com>
 <8acb3b53-d5eb-0524-2c57-31fcb7e736d9@gmail.com>
 <20161124225246.GA16648@mail.hallyn.com>
 <d2160ca5-12e5-0be7-ade7-c4ee63e1df32@gmail.com>
 <20161125175009.GA326@mail.hallyn.com>
 <0d1a7bc4-2e9c-73ba-11fb-f233e790b3a6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0d1a7bc4-2e9c-73ba-11fb-f233e790b3a6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> On 11/25/2016 06:50 PM, Serge E. Hallyn wrote:
> > On Fri, Nov 25, 2016 at 09:33:50AM +0100, Michael Kerrisk (man-pages) wrote:
> >> Hi Serge,
> >>
> >> On 11/24/2016 11:52 PM, Serge E. Hallyn wrote:
> >>> Quoting Michael Kerrisk (man-pages) (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> >>
> >> [...]
> >>
> >>>> Could we have a man-pages patch for this feature? Presumably for 
> >>>> user_namespaces(7) or capabilities(7).
> >>>
> >>> capabilities.7 doesn't actually mention anything about user namespaces
> >>> right now.  
> >>
> >> True. There's really just this:
> >>
> >>    Interaction with user namespaces
> >>        For a discussion of  the  interaction  of  capabilities  and  user
> >>        namespaces, see user_namespaces(7).
> >>
> >>> I'll come up with a patch for both I think.  Do you have a
> >>> deadline for a new release coming up?
> >>
> >> No deadlines as such. The last couple of years, as a sort of 
> >> experiment, I've fallen into the same release cycle as the kernel
> >> (typically making a release in the week or so after the kernel release),
> >> and I am even using a similar numbering scheme. Ideally, the man-pages
> >> patch would go into the release that corresponds to the kernel release
> >> that makes the change.
> > 
> > Cool - I'll write something up in the next few weeks.
> 
> Obviously, the sooner you write it, the sooner others may read--and
> perhaps test--it.

Hi,

first draft

https://git.kernel.org/cgit/linux/kernel/git/sergeh/man-pages.git/commit/?h=2016-11-29/nscaps

>From 62578b7cb2e0cbb100d1b29000de5657e9d998c4 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Date: Tue, 29 Nov 2016 15:25:37 -0600
Subject: [PATCH 1/1] Describe the new namespaced file capabilities.

---
 man7/user_namespaces.7 | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/man7/user_namespaces.7 b/man7/user_namespaces.7
index 0c99df0..b1dd027 100644
--- a/man7/user_namespaces.7
+++ b/man7/user_namespaces.7
@@ -208,6 +208,41 @@ further removed descendant user namespaces as well.
 .\"
 .\" ============================================================
 .\"
+.SS File capabilities in user namespaces
+Until v4.9, writing file capabilities required the writer to possess
+.BR CAP_SETFCAP
+targeted at the initial user namespace.  In v4.10 a new version (v3) of the
+file capability extended attribute was introduced, which targets the
+capabilities at a namespace root userid.  This means that a task executing the
+file will receive elevated privilege only if it is running in a namespace whose
+root is mapped to the specified target uid.  If a task does not have
+.BR CAP_SETFCAP
+toward the user namespace which owns the filesystem hosting the file, then it
+can only write file capabilities targeted at uids mapped in the task's own
+namespace.
+
+As a detailed example, assume a user namespace where uid 0 is mapped to host
+uid 100000.  Root in the container writes a file capability.  If the file
+capability xattr is v2, then a v3 capability xattr targeted to 100000 will be
+written.
+
+If instead a v3 capability xattr is written, then the kernel will verify that
+the writer is privileged with
+.BR CAP_SETFCAP
+over its own namespace and that the file owner's uid and gid are mapped into
+the current task's namespace.
+
+The capability target uid which is written to disk is mapped into the
+filesystem's user namespace.  Therefore, in the above example, if uid 0 in the
+namespace (100000 on the host) mounted the filesystem, the target uid value
+actually written will be converted back to 0 (the mapped value for host uid
+100000).  In this case the mount will be treated as foreign for any tasks in
+the initial user namespace, so that the file capability (as well as setuid and
+setgid bits) will be ignored, preventing a leak of privilege.
+
+.\"
+.\" ============================================================
+.\"
 .SS Effect of capabilities within a user namespace
 Having a capability inside a user namespace
 permits a process to perform operations (that require privilege)
-- 
2.7.4
