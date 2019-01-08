From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: [PATCH] mm/mincore: allow for making sys_mincore() privileged
Date: Tue, 8 Jan 2019 14:53:00 +0100
Message-ID: <8c9feac8-fecb-a56a-afaf-c1352a666991@petrovitsch.priv.at>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm>
 <d4846cb2-2a4b-b8b3-daac-e5f51751bbf1@suse.cz>
 <nycvar.YFH.7.76.1901052016250.16954@cbobk.fhfr.pm>
 <fb0414ea-953b-0252-b1d1-12028b190949@suse.cz>
 <047f0582-a4d3-490d-7284-48dfdf9e9471@petrovitsch.priv.at>
 <nycvar.YFH.7.76.1901081235380.16954@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1901081235380.16954@cbobk.fhfr.pm>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/01/2019 12:37, Jiri Kosina wrote:
> On Tue, 8 Jan 2019, Bernd Petrovitsch wrote:
> 
>> Shouldn't the application use e.g. mlock()/.... to guarantee no page 
>> faults in the first place?
> 
> Calling mincore() on pages you've just mlock()ed is sort of pointless 
> though.

Obviously;-)

Sorry for being unclear above: If I want my application to
avoid suffering from page faults, I use simply mlock()
(and/or friends) to nail the relevant pages into physical
RAM and not "look if they are out, if yes, get them in" which
has also the risk that these important pages are too soon
evicted again.

But perhaps I'm missing some very special use cases ....

MfG,
	Brend
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at
