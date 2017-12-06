From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2] mmap.2: MAP_FIXED updated documentation
Date: Wed, 6 Dec 2017 13:21:25 -0800
Message-ID: <deb952d9-82bc-e737-8060-8fe7e70f44a1@nvidia.com>
References: <20171204021411.4786-1-jhubbard@nvidia.com>
 <20171204105549.GA31332@rei>
 <efb6eae4-7f30-42c3-0efe-0ab5fbf0fdb4@nvidia.com>
 <20171205070510.aojohhvixijk3i27@dhcp22.suse.cz>
 <2cff594a-b481-269d-dd91-ff2cc2f4100a@nvidia.com>
 <20171206100118.GA13979@rei>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20171206100118.GA13979@rei>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-man <linux-man@vger.kernel.org>, linux-api@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>
List-Id: linux-api@vger.kernel.org

On 12/06/2017 02:01 AM, Cyril Hrubis wrote:
> Hi!
>> (It does seem unfortunate that the man page cannot help the programmer
>> actually write correct code here. He or she is forced to read the kernel
>> implementation, in order to figure out the true alignment rules. I was
>> hoping we could avoid that.)
> 
> It would be nice if we had this information exported somehere so that we
> do not have to rely on per-architecture ifdefs.
> 
> What about adding MapAligment or something similar to the /proc/meminfo?
> 

What's the use case you envision for that? I don't see how that would be
better than using SHMLBA, which is available at compiler time. Because 
unless someone expects to be able to run an app that was compiled for 
Arch X, on Arch Y (surely that's not requirement here?), I don't see how
the run-time check is any better.

Or maybe you're thinking that since the SHMLBA cannot be put in the man
pages, we could instead provide MapAlignment as sort of a different
way to document the requirement?
