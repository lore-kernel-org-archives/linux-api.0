From: Patrick Bellasi <patrick.bellasi@arm.com>
Subject: Re: [PATCH v12 0/6] Add utilization clamping support (CGroups API)
Date: Thu, 1 Aug 2019 12:25:27 +0100
Message-ID: <20190801112527.3cmogmb5vrzqjwzn@e110439-lin>
References: <20190718181748.28446-1-patrick.bellasi@arm.com>
 <20190729200606.GA136335@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190729200606.GA136335@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>
List-Id: linux-api@vger.kernel.org

On 29-Jul 13:06, Tejun Heo wrote:
> Hello,

Hi Tejun,

> Looks good to me.  On cgroup side,
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

Happy we converged toward something working for you.

I'll add the two small changes suggested by Michal and respin a v13
with your ACK on the series.

Cheers Patrick

-- 
#include <best/regards.h>

Patrick Bellasi
