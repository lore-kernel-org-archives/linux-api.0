From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mmap.2: MAP_FIXED is no longer discouraged
Date: Sat, 2 Dec 2017 07:05:55 -0800
Message-ID: <20171202150554.GA30203@bombadil.infradead.org>
References: <20171202021626.26478-1-jhubbard@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171202021626.26478-1-jhubbard@nvidia.com>
Sender: linux-arch-owner@vger.kernel.org
To: john.hubbard@gmail.com
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-man <linux-man@vger.kernel.org>, linux-api@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>
List-Id: linux-api@vger.kernel.org

On Fri, Dec 01, 2017 at 06:16:26PM -0800, john.hubbard@gmail.com wrote:
> MAP_FIXED has been widely used for a very long time, yet the man
> page still claims that "the use of this option is discouraged".

I think we should continue to discourage the use of this option, but
I'm going to include some of your text in my replacement paragraph ...

-Because requiring a fixed address for a mapping is less portable,
-the use of this option is discouraged.
+The use of this option is discouraged because it forcibly unmaps any
+existing mapping at that address.  Programs which use this option need
+to be aware that their memory map may change significantly from one run to
+the next, depending on library versions, kernel versions and random numbers.
+In a threaded process, checking the existing mappings can race against
+a new dynamic library being loaded, for example in response to another
+thread making a library call which causes a PAM module to be loaded.

(I don't love this text, in particular "PAM module".  I'm going off to
use the ATM machine now.  Please edit.)
