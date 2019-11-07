From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: documentation of clone3() system call
Date: Thu, 7 Nov 2019 13:26:03 +0100
Message-ID: <CAKgNAkhzaJmBuphwkXEVD+Kng7i1cHwK0DjPQ9OfNK7FJCsyyA@mail.gmail.com>
References: <CAKgNAkjo2WHq+zESU1iuCHJJ0x-fTNrakS9-d1+BjzUuV2uf2Q@mail.gmail.com>
 <20191025170726.rqsquw4v4cuhduek@wittgenstein>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191025170726.rqsquw4v4cuhduek@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Christian Brauner <christian@brauner.io>, lkml <linux-kernel@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Florian Weimer <fweimer@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@gmail.com>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

Hey, Christian,

Ping!

Cheers,

Michael

On Fri, 25 Oct 2019 at 19:09, Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Fri, Oct 25, 2019 at 06:59:31PM +0200, Michael Kerrisk (man-pages) wrote:
> > Hello Christian and all,
> >
> > I've made a first shot at adding documentation for clone3(). You can
> > see the diff here:
> > https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=faa0e55ae9e490d71c826546bbdef954a1800969
> >
> > In the end, I decided that the most straightforward approach was to
> > add the documentation as part of the existing clone(2) page. This has
> > the advantage of avoiding duplication of information across two pages,
> > and perhaps also makes it easier to see the commonality of the two
> > APIs.
> >
> > Because the new text is integrated into the existing page, I think it
> > makes most sense to just show that page text for review purposes. I
> > welcome input on the below.
> >
> > The notable changes are:
> > * In the first part of the page, up to and including the paragraph
> > with the subheading "The flags bit mask"
> > * Minor changes in the description of CLONE_CHILD_CLEARTID,
> > CLONE_CHILD_SETTID, CLONE_PARENT_SETTID, and CLONE_PIDFD, to reflect
> > the argument differences between clone() and clone2()
> >
> > Most of the resy of page is unchanged.
> >
> > I welcome fixes, suggestions for improvements, etc.
>
> Thank you Michael, for doing this. I will hopefully get around to
> reviewing this soon but it might take a few days (latest after next week
> :( because of OSS/LSS).
>
> Christian



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
