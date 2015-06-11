From: Ingo Molnar <mingo@kernel.org>
Subject: Re: Generic kernel features that need architecture(mips) support
Date: Thu, 11 Jun 2015 08:24:53 +0200
Message-ID: <20150611062452.GB32133@gmail.com>
References: <55759543.1010408@gmail.com>
 <20150610145804.GG2753@linux-mips.org>
 <5578679D.2030307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5578679D.2030307@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Jonathan Corbet <corbet@lwn.net>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org


(Jon Cc:-ed)

* Xose Vazquez Perez <xose.vazquez@gmail.com> wrote:

> On 06/10/2015 04:58 PM, Ralf Baechle wrote:
> 
> > How are the documentation files in Documentation/features/ maintained?
> > They were automatically generated so I wonder if I have to take care
> > of anything.
> 
> CC: Ingo and related ml.

So changes to Documentation/features/ should come as simple patches done from hand 
editing, there's no need to preserve any initial (half-)automated generation. 
Formatting should be preserved so that Documentation/features/list-arch.sh still 
works as before.

Jon: would you like to receive all patches to Documentation/features/ so you can 
collect them in the documentation tree, or can maintainers patch it as part of any 
feature work that affects the tables? I think it's all finegrained enough to not 
create conflicts. That way they would become partly self-maintaining. (Or at least 
one can always hope! ;-)

Thanks,

	Ingo
