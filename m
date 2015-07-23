From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH -mm v9 7/8] proc: export idle flag via kpageflags
Date: Thu, 23 Jul 2015 10:57:46 +0300
Message-ID: <20150723075746.GA19029@esperanza>
References: <cover.1437303956.git.vdavydov@parallels.com>
 <4c1eb396150ee14d7c3abf1a6f36ec8cc9dd9435.1437303956.git.vdavydov@parallels.com>
 <20150721163500.528bd39bbbc71abc3c8d429b@linux-foundation.org>
 <20150722162528.GN23374@esperanza>
 <20150722124421.3313e8f007d76b386e1d61ec@linux-foundation.org>
 <CAJu=L5-QKjd8ZjsUY8xrrtVB0k=aK5HSQAvscmqRjoJapj3_-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJu=L5-QKjd8ZjsUY8xrrtVB0k=aK5HSQAvscmqRjoJapj3_-A@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>
Cc: Minchan Kim <minchan@kernel.org>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>, Michel Lespinasse <walken@google.com>, David Rientjes <rientjes@google.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Jonathan Corbet <corbet@lwn.net>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Jul 22, 2015 at 01:46:21PM -0700, Andres Lagar-Cavilla wrote:
> In page_referenced_one:
> 
> +       if (referenced)
> +               clear_page_idle(page);
> 

Yep, that's it. Thanks, Andres.
