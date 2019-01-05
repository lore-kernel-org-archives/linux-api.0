From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Sat, 5 Jan 2019 11:46:33 -0800
Message-ID: <CAHk-=wicks2BEwm1BhdvEj_P3yawmvQuG3NOnjhdrUDEtTGizw@mail.gmail.com>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jan 5, 2019 at 9:27 AM Jiri Kosina <jikos@kernel.org> wrote:
>
> From: Jiri Kosina <jkosina@suse.cz>
>
> There are possibilities [1] how mincore() could be used as a converyor of
> a sidechannel information about pagecache metadata.

Can we please just limit it to vma's that are either anonymous, or map
a file that the user actually owns?

Then the capability check could be for "override the file owner check"
instead, which makes tons of sense.

No new sysctl's for something like this, please.

             Linus
