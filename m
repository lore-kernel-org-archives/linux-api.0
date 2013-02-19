From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] ptrace: add ability to retrieve signals without
	removing them from a queue
Date: Tue, 19 Feb 2013 20:34:24 +0100
Message-ID: <20130219193424.GA9606@redhat.com>
References: <1360768595-31943-1-git-send-email-avagin@openvz.org> <CAKgNAkicAGEkvNFnSso__wK6QKao8jyDu5yuRmeyUOeaXLGChw@mail.gmail.com> <5123BC20.9040405@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5123BC20.9040405@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Emelyanov <xemul@parallels.com>
Cc: mtk.manpages@gmail.com, Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-api@vger.kernel.org, Roland McGrath <roland@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On 02/19, Pavel Emelyanov wrote:
>
> On 02/19/2013 04:15 PM, Michael Kerrisk (man-pages) wrote:
> > On Wed, Feb 13, 2013 at 4:16 PM, Andrey Vagin <avagin@openvz.org> wrote:
> >> This patch adds a new ptrace request PTRACE_PEEKSIGINFO.
> >>
> >> This request is used to retrieve information about a signal with the
> >> specified sequence number. A siginfo_t structure is copied from the child
> >> to location data in the parent.
> >>
> >> The low 16 bits of addr contains a sequence number of signal in a queue:
> >
> > I think 16 bits is probably not enough.... Already, on the "out of the
> > box" system that I have at hand, one can queue more than 2^16-1
> > signals:
> >
> >     $ cat /proc/$$/status | grep SigQ
> >     SigQ:	2/126065
>
> Yup :( Well, actually it would be enough to have only 1 bit as "flags"
> and the rest (31 at least) for the number. But taking into account
> Oleg's wish to have an ability to extend the amount of flags

I am not sure this is really needed, and we can add more PTRACE_PEEK_
codes later. I am fine either way, we can even add PEEK_PRIVATE/SHARED
right now.

But, given that every PEEK does list_for_each() until it finds the
necessary sequence number, I am wondering how this O(n**2) will work
if you want to dump 126065 signals ;)

Oleg.
