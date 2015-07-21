From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm v9 7/8] proc: export idle flag via kpageflags
Date: Tue, 21 Jul 2015 16:35:00 -0700
Message-ID: <20150721163500.528bd39bbbc71abc3c8d429b@linux-foundation.org>
References: <cover.1437303956.git.vdavydov@parallels.com>
	<4c1eb396150ee14d7c3abf1a6f36ec8cc9dd9435.1437303956.git.vdavydov@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4c1eb396150ee14d7c3abf1a6f36ec8cc9dd9435.1437303956.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 19 Jul 2015 15:31:16 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:

> As noted by Minchan, a benefit of reading idle flag from
> /proc/kpageflags is that one can easily filter dirty and/or unevictable
> pages while estimating the size of unused memory.
> 
> Note that idle flag read from /proc/kpageflags may be stale in case the
> page was accessed via a PTE, because it would be too costly to iterate
> over all page mappings on each /proc/kpageflags read to provide an
> up-to-date value. To make sure the flag is up-to-date one has to read
> /proc/kpageidle first.

Is there any value in teaching the regular old page scanner to update
these flags?  If it's doing an rmap scan anyway...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
