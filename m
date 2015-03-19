From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 3/3] mm: idle memory tracking
Date: Thu, 19 Mar 2015 13:45:24 +0300
Message-ID: <20150319104524.GD27066@moon>
References: <cover.1426706637.git.vdavydov@parallels.com>
 <0b70e70137aa5232cce44a69c0b5e320f2745f7d.1426706637.git.vdavydov@parallels.com>
 <20150319101205.GC27066@moon>
 <20150319104103.GA12162@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150319104103.GA12162@esperanza>
Sender: linux-doc-owner@vger.kernel.org
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 19, 2015 at 01:41:03PM +0300, Vladimir Davydov wrote:
> > 
> > Vladimir, might we need get_online_mems/put_online_mems here,
> > or if node gets offline this wont be a problem? (Asking
> > because i don't know).
> 
> I only need to dereference page structs corresponding to the node here,
> and page structs are not freed when the node gets offline AFAICS, so I
> guess it must be safe.

OK, thanks for info!
