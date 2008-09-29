From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: New list: linux-api@vger for API/ABI discussions
Date: Mon, 29 Sep 2008 08:14:30 +0200
Message-ID: <cfd18e0f0809282314v65bfe4e1i8d048d1250435cb1@mail.gmail.com>
References: <cfd18e0f0809260304q26fc1d7t44c50ab2e155d75d@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0809260304q26fc1d7t44c50ab2e155d75d-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Gidday,

At my request David Miller has created linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Short description:
This list is for discussions of changes to the Linux kernel/user
interface (API or ABI); please CC this list on all patches that change
the interface.

Long description:

There are many groups who have an interest in tracking changes to the
Linux programming interface, for example: kernel developers, glibc and
other C libraries, the man-pages project, LTP, LSB, and userland
programmers.  Currently there is no easy to track these changes; this
list is a step towards fixing that.

The list is for discussion of Linux API and (notwithstanding the list
name) ABI changes.  Its focus is particularly intended to be on
changes in the Linux kerrnel-userland interface, but (IMO) notes on
changes in the glibc interface would also be welcome, since many of
the people that are interested in the kernel-userland interface are
also interested in the glibc interface.

Please CC linux-api@ on all patches that change the Linux
kernel-userland interface, so that any interested parties can learn
about those changes.  (I'll submit patches to SubmitChecklist and
Documentation/HOWTO to mention this.)

If you see a patch that changes the interface that wasn't CCed to
linux-api@, please forward the patch to that list, or better still,
remind the author to CC the list with such patches should be CCed to
the list.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
