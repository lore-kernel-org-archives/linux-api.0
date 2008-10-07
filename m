From: Kees Cook <kees.cook@canonical.com>
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Date: Tue, 7 Oct 2008 09:14:22 -0700
Message-ID: <20081007161422.GD10357@outflux.net>
References: <20081002211424.GJ10632@outflux.net> <20081004145149.52c34ee7@infradead.org> <20081004220220.GK10632@outflux.net> <20081004164239.0c1483a4@infradead.org> <20081005004233.GL10632@outflux.net> <20081004174843.6fe48a8e@infradead.org> <20081005091120.GA21003@x200.localdomain> <20081005101438.GR10632@outflux.net> <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756055AbYJGQOo@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Michael,

On Tue, Oct 07, 2008 at 03:39:26PM +0200, Michael Kerrisk wrote:
> On Sun, Oct 5, 2008 at 12:14 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > Make process personality flags visible in /proc.  Since a process's
> > personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
> > file only readable by the process owner.
> 
> Please CC userland interface changes to linux-api@vger.kernel.org

Sure, I'd be happy to do that for future stuff.  I don't see this email
address mentioned anywhere in the kernel tree.  It seems like this is
useful information that should go in either MAINTAINERS or better yet
Documentation/SubmittingPatches for it to be discoverable by future
patch-senders -- and somewhere that I can look it up easily later.  :)

-Kees

-- 
Kees Cook
Ubuntu Security Team
