From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Tue, 8 Jan 2019 10:14:23 +0100
Message-ID: <047f0582-a4d3-490d-7284-48dfdf9e9471@petrovitsch.priv.at>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <d4846cb2-2a4b-b8b3-daac-e5f51751bbf1@suse.cz>
 <nycvar.YFH.7.76.1901052016250.16954@cbobk.fhfr.pm>
 <fb0414ea-953b-0252-b1d1-12028b190949@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fb0414ea-953b-0252-b1d1-12028b190949@suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, Jiri Kosina <jikos@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/01/2019 20:38, Vlastimil Babka wrote:
[...]
> I was thinking about "return true" here, assuming that userspace generally wants
> to ensure itself there won't be page faults when it starts doing something
> critical, and if it sees a "false" it will try to do some kind of prefaulting,
> possibly in a loop. There might be somebody trying to make sure something is out

Isn't that racy by design as the pages may get flushed out after the check?
Shouldn't the application use e.g. mlock()/.... to guarantee no page
faults in the first place?

MfG,
	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at
