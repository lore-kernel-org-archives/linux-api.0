From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH] mm: Support compiling out madvise and fadvise
Date: Mon, 22 Sep 2014 18:47:40 +0200
Message-ID: <1411404460.28679.12.camel@linux-t7sj.site>
References: <20140922161109.GA25027@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140922161109.GA25027@thin>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-api@vger.kernel.org

On Mon, 2014-09-22 at 09:11 -0700, Josh Triplett wrote:
> Many embedded systems will not need these syscalls, and omitting them
> saves space.  Add a new EXPERT config option CONFIG_ADVISE_SYSCALLS
> (default y) to support compiling them out.

general question: if a user chooses CONFIG_ADVISE_SYSCALLS=n (or any
config option related to tinyfication) and breaks the system/workload...
will that be acceptable for a kernel pov? In other words, what's the
degree of responsibility the user will have when choosing such builds?

Thanks,
Davidlohr
