From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 0/3] mm, proc: Implement /proc/<pid>/totmaps
Date: Mon, 12 Sep 2016 14:02:48 +0200
Message-ID: <20160912120248.GK14524@dhcp22.suse.cz>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: robert.foss@collabora.com
Cc: corbet@lwn.net, akpm@linux-foundation.org, vbabka@suse.cz, hughd@google.com, koct9i@gmail.com, n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com, john.stultz@linaro.org, minchan@kernel.org, ross.zwisler@linux.intel.com, jmarchan@redhat.com, hannes@cmpxchg.org, keescook@chromium.org, oleg@redhat.com, viro@zeniv.linux.org.uk, mguzik@redhat.com, jdanis@google.com, calvinowens@fb.com, adobriyan@gmail.com, ebiederm@xmission.com, sonnyrao@chromium.org, seth.forshee@canonical.com, tixxdz@gmail.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Zhang <benzh@chromium.org>, Bryan Freed <bfreed@chromium.org>, Filipe Brandenburger <filbranden@chromium.org>, Jann Horn <jann@thejh.net>, linux-api@vger.kernel.org, Jacek Anaszewski <j.anaszewski@samsung.com>
List-Id: linux-api@vger.kernel.org

On Mon 05-09-16 16:14:06, robert.foss@collabora.com wrote:
> From: Robert Foss <robert.foss@collabora.com>
> 
> This series provides the /proc/PID/totmaps feature, which
> summarizes the information provided by /proc/PID/smaps for
> improved performance and usability reasons.
> 
> A use case is to speed up monitoring of memory consumption in
> environments where RSS isn't precise.
> 
> For example Chrome tends to many processes which have hundreds of VMAs
> with a substantial amount of shared memory, and the error of using
> RSS rather than PSS tends to be very large when looking at overall
> memory consumption.  PSS isn't kept as a single number that's exported
> like RSS, so to calculate PSS means having to parse a very large smaps
> file.
> 
> This process is slow and has to be repeated for many processes, and we
> found that the just act of doing the parsing was taking up a
> significant amount of CPU time, so this patch is an attempt to make
> that process cheaper.

I still maintain my concerns about a single pss value. It might work in
a very specific situations where the consumer knows what is shared but
other than that the value can be more misleading than helpful. So a NACK
from me until I am shown that this is usable in general and still
helpful.

-- 
Michal Hocko
SUSE Labs
