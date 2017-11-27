From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Mon, 27 Nov 2017 09:25:16 -0800
Message-ID: <87vahv8whv.fsf@linux.intel.com>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
	<20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz> (Michal Hocko's
	message of "Mon, 27 Nov 2017 11:12:32 +0100")
Sender: owner-linux-mm@kvack.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Mikael Pettersson <mikpelinux@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Michal Hocko <mhocko@kernel.org> writes:
>
> Could you be more explicit about _why_ we need to remove this tunable?
> I am not saying I disagree, the removal simplifies the code but I do not
> really see any justification here.

It's an arbitrary scaling limit on the how many mappings the process
has. The more memory you have the bigger a problem it is. We've
ran into this problem too on larger systems.

The reason the limit was there originally because it allows a DoS
attack against the kernel by filling all unswappable memory up with VMAs.

The old limit was designed for much smaller systems than we have
today.

There needs to be some limit, but it should be on the number of memory
pinned by the VMAs, and needs to scale with the available memory,
so that large systems are not penalized.

Unfortunately just making it part of the existing mlock limit could
break some existing setups which max out the mlock limit with something
else. Maybe we need a new rlimit for this?

-Andi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
