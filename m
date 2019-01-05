From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 23:54:32 +0100
Message-ID: <CAG48ez2jAp9xkPXQmVXm0PqNrFGscg9BufQRem2UD8FGX-YzPw@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, Linux-MM <linux-mm@kvack.org>, kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jan 5, 2019 at 6:27 PM Jiri Kosina <jikos@kernel.org> wrote:
> There are possibilities [1] how mincore() could be used as a converyor of
> a sidechannel information about pagecache metadata.
>
> Provide vm.mincore_privileged sysctl, which makes it possible to mincore()
> start returning -EPERM in case it's invoked by a process lacking
> CAP_SYS_ADMIN.
>
> The default behavior stays "mincore() can be used by anybody" in order to
> be conservative with respect to userspace behavior.
>
> [1] https://www.theregister.co.uk/2019/01/05/boffins_beat_page_cache/

Just checking: I guess /proc/$pid/pagemap (iow, the pagemap_read()
handler) is less problematic because it only returns data about the
state of page tables, and doesn't query the address_space? In other
words, it permits monitoring evictions, but non-intrusively detecting
that something has been loaded into memory by another process is
harder?
